//
//  Model.swift
//  Space Stories
//
//  Created by Alexey Khestanov on 27.11.2021.
//

import Foundation
import UIKit

struct SpaceStory: Codable {
    let explanation: String?
    let url: String?
    let hdurl: String?
    let title: String?
}

class SpaceStories {
    
    // MARK: - Public properties
    
    static let shared = SpaceStories()

    var onFinished: () -> Void = { }
    var onError: (String) -> Void = {_ in }
    
    var thumbnails: [Data?] = []
    
    var stories: [SpaceStory] {
        manager.stories
    }
    
    // MARK: - Private properties
    private let storyCount = 30
    private let manager: NetworkManager = .init()
    

    // MARK: - Initializer
    private init() {
        manager.onFinished = updateThumbnails
        manager.onError = self.onError
        manager.fetchStories(count: storyCount)
    }
    
    // MARK: - Public methods
    func getStoryImage(forIndex: Int) -> Data? {
        if forIndex < 0 || forIndex >= stories.count {
            return nil
        }
        
        if let hdurl = stories[forIndex].hdurl {
            return manager.fetchImage(imageURL: hdurl)
        } else {
            return nil
        }
    }
    
    // MARK: - Private methods
    private func updateThumbnails() {
        manager.onFinished = self.onFinished
        self.onFinished()
        for story in stories {
            if let url = story.url {
                thumbnails.append(manager.fetchImage(imageURL: url))
            }
        }
    }
}
