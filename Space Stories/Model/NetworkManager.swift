//
//  NetworkManager.swift
//  Space Stories
//
//  Created by Alexey Khestanov on 27.11.2021.
//

import Foundation

class NetworkManager {
        
    private let dataSource = "https://api.nasa.gov/planetary/apod?api_key=%s&count=%d"
    private let apiKey = "ziooiNKqgKArOsZewgeUmwyWYBKIRSZcb2VEPwbv"

    func fetchStories(count: Int) -> [SpaceStory]? {
        var stories: [SpaceStory] = []
        var successful = false
        guard let request = URL(string: String(format: dataSource, arguments: [apiKey, count])) else { return nil }
        URLSession.shared.dataTask(with: request) { data, _ , error in
            guard let data = data else {
                print(error?.localizedDescription ?? "No description")
                return
            }
            do {
                let parsedStories = try
                        JSONDecoder().decode([SpaceStory].self, from: data)
                stories = parsedStories
                successful = true
            } catch let error {
                print(error.localizedDescription)
                return
            }
        }.resume()
        if successful {
            return stories
        } else {
            return nil
        }
    }
    
    func fetchImage(imageURL: String) -> Data? {
        guard let url = URL(string: imageURL),
              let imageData = try? Data(contentsOf: url) else { return nil }
        return imageData
    }
}



