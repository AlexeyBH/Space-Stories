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
                    let stories = try JSONDecoder().decode(
                        [SpaceStory].self,
                        from: data
                    )
                    // Это нужно так как в ответе часто попадаются
                    // словари с отсутствующими ключевыми свойствами,
                    // а такие записи нам не нужны.
                    // Или надо лучше было делать свойства не опциональными и декодить
                    let filtered = stories.filter {
                        $0.url != nil &&
                        $0.title != nil &&
                        $0.explanation != nil &&
                        $0.hdurl != nil
                    }
                    handler(.success(filtered))
                } catch {
                    handler(.failure(.decodingError))
                }
            case .failure(let error):
                handler(.failure(error))
            }
        }
        
        fetchData(url: url, handler: getStories)
        
    }
    

    // Универсальная функция для получения любых данных - как записей, так и картинок.
    func fetchData(url: String, handler: @escaping (Result<Data, NetworkError>) -> Void) {
        AF.request(url)
            .validate()
            .response { dataResponse in
                DispatchQueue.main.async {
                    switch dataResponse.result {
                    case .success(let value):
                        guard let data = value else {
                            handler(.failure(.noData))
                            return
                        }
                        handler(.success(data))
                    case .failure(let afError):
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



