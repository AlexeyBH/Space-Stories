//
//  NetworkManager.swift
//  Space Stories
//
//  Created by Alexey Khestanov on 27.11.2021.
//

import Foundation
import Alamofire

enum NetworkError: String, Error {
    case badUrl  = "Bad URL adress"
    case noData = "No data in server responce"
    case decodingError = "JSON Parsing error"
    case otherError = "Other Alamofire error"
}

class NetworkManager {
    
    // MARK: - Public properties
    
    static let shared = NetworkManager()
    let count = 30

    // MARK: - Private properties
    
    private let dataSource = "https://api.nasa.gov/planetary/apod"
    private let apiKey = "ziooiNKqgKArOsZewgeUmwyWYBKIRSZcb2VEPwbv"

    
    // MARK: - Public pmethods
    
    // Не пользовался .responseJSON специально, чтобы два раза не плодить одну и ту же
    // обработку ошибок (для массива и для картинки), которую я вынес в fetchAny()
    func fetchStories(handler: @escaping (Result<[SpaceStory], NetworkError>) -> Void) {
        let url = dataSource + "?api_key=\(apiKey)&count=\(count)"
        
        func getStories(from data: Result<Data, NetworkError>) -> Void {
            switch data {
            case .success(let data):
                do {
                    print("success")
                    let stories = try JSONDecoder().decode(
                        [SpaceStory].self,
                        from: data
                    )
                    // Это нужно так как в ответе часто попадаются
                    // словари с отсутствующими ключевыми свойствами,
                    // а они нам не нужны
                    let filtered = stories.filter {
                        $0.url != nil &&
                        $0.title != nil &&
                        $0.explanation != nil &&
                        $0.hdurl != nil
                    }
                    print("init count: \(stories.count), filtered count: \(filtered.count)")
                    handler(.success(filtered))
                } catch {
                    print("Error 1000")
                    handler(.failure(.decodingError))
                }
            case .failure(let error):
                print("Error 1001")
                handler(.failure(error))
            }
        }
        
        print("Before fetching stories...")
        fetchData(url: url, handler: getStories)
        
    }
    

    func fetchData(url: String, handler: @escaping (Result<Data, NetworkError>) -> Void) {
        AF.request(url)
            .validate()
            .response { dataResponse in
                print("begin fetching data...")
                DispatchQueue.main.async {
                    switch dataResponse.result {
                    case .success(let value):
                        print("success!")
                        guard let data = value else {
                            print("failure - no data")
                            handler(.failure(.noData))
                            return
                        }
                        print("data OK")
                        handler(.success(data))
                    case .failure(let afError):
                        print("Error")
                        handler(.failure(self.convertAFError(afError)))
                    }
                }
            }
    }
    
    // MARK: - Private pmethods
    private init() {
        
    }
    
    private func convertAFError(_ error: AFError) -> NetworkError {
        switch error {
        case .invalidURL(_):
            return .badUrl
        case .responseValidationFailed(_):
            return .noData
        default:
            return .otherError
        }
    }
    
}



