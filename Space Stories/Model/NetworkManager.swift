//
//  NetworkManager.swift
//  Space Stories
//
//  Created by Alexey Khestanov on 27.11.2021.
//

import Foundation

class NetworkManager {
        
    var stories: [SpaceStory] = []
    
    var onFinished: () -> Void = {}
    
    private let dataSource = "https://api.nasa.gov/planetary/apod"
    private let apiKey = "ziooiNKqgKArOsZewgeUmwyWYBKIRSZcb2VEPwbv"

    func fetchStories(count: Int) {
        let url = dataSource + "?api_key=\(apiKey)&count=\(count)"
        guard let request = URL(string: url) else { return }
    
        URLSession.shared.dataTask(with: request) { data, _ , error in
            guard let safeData = data else {
                print(error?.localizedDescription ?? "No description")
                return
            }
            do {
                let allStories = try
                    JSONDecoder().decode([SpaceStory].self, from: safeData)
                self.stories = allStories
                DispatchQueue.main.async {
                    self.onFinished()
                }
            } catch let error {
                print(error)
                return
            }
        }.resume()
    }
        
    func fetchImage(imageURL: String) -> Data? {
        guard let url = URL(string: imageURL),
              let imageData = try? Data(contentsOf: url) else {
                  return nil
              }
        self.onFinished()
        return imageData
    }
}


