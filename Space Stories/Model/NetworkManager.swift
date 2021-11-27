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
        
        print("fetching stories...")
        
        guard let request = URL(string: url) else { return }
    
            
        URLSession.shared.dataTask(with: request) { data, _ , error in
            guard let safeData = data else {
                print("Data fetch error:")
                print(error?.localizedDescription ?? "No description")
                return
            }
            print("parcing stories...")
            do {
                let allStories = try
                    JSONDecoder().decode([SpaceStory].self, from: safeData)
                self.stories = allStories.filter {
                    $0.hdurl != nil && $0.url != nil &&
                    $0.title != nil && $0.explanation != nil
                }
                DispatchQueue.main.async {
                    print("calling onFinished..")
                    self.onFinished()
                }
            } catch let error {
                print("JSON decoding error:")
                print(error)
                return
            }
        }.resume()
    }
        
    func fetchImage(imageURL: String) -> Data? {
        print("loading image from: \(imageURL)")
        guard let url = URL(string: imageURL),
              let imageData = try? Data(contentsOf: url) else {
                  print("failed: \(imageURL)")
                  return nil
              }
        print("success: \(imageURL)")
        self.onFinished()
        return imageData
    }
}


