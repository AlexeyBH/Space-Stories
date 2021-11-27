//
//  NetworkManager.swift
//  Space Stories
//
//  Created by Alexey Khestanov on 27.11.2021.
//

import Foundation

class NetworkManager {
    
    static let shared = NetworkManager()
    
    private let dataSource = "https://api.nasa.gov/planetary/apod?api_key=%s&count=%d"
    private let apiKey = "ziooiNKqgKArOsZewgeUmwyWYBKIRSZcb2VEPwbv"
    
    let storyCount = 20
    let spaceStories: [SpaceStory]
    
    init?() {
        var spaceStories: [SpaceStory] = []
        var successful = false
        guard let request = URL(string: String(format: dataSource, arguments: [apiKey, storyCount])) else { return nil }
        URLSession.shared.dataTask(with: request) { data, _ , error in
            guard let data = data else {
                print(error?.localizedDescription ?? "No description")
                return
            }
            do {
                let stories = try JSONDecoder().decode([SpaceStory].self, from: data)
                spaceStories = stories
                successful = true
            } catch let error {
                print(error.localizedDescription)
                return
            }
        }.resume()
        if successful {
            self.spaceStories = spaceStories
        } else {
            return nil
        }
    }
    
    
}


