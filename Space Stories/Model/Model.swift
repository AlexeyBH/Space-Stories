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
    
    static let shared = SpaceStories()

    var onFinished: () -> Void = { }

    var thumbnails: [Data?] = []
    
    var stories: [SpaceStory] {
        manager.stories
    }
    
    private let storyCount = 20
    private let manager: NetworkManager = .init()
    
    private func updateThumbnails() {
        manager.onFinished = self.onFinished
        self.onFinished()
        for story in stories {
            if let url = story.url {
                print("name: '\(story.title ?? "no name")', img: '\(story.url ?? "no url")'")
                thumbnails.append(manager.fetchImage(imageURL: url))
            }
        }
    }
    
    private init() {
        manager.onFinished = updateThumbnails
        manager.fetchStories(count: storyCount)
    }
    
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
}
