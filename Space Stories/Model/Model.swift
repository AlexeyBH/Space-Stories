//
//  Model.swift
//  Space Stories
//
//  Created by Alexey Khestanov on 27.11.2021.
//

import Foundation
import UIKit

struct SpaceStory: Codable {
    let explanation: String
    let url: String
    let hdurl: String
    let title: String
}

class SpaceStories {
    
    static let shared = SpaceStories()
    
    let storyCount = 20
    let stories: [SpaceStory]
    let thumbnails: [Data?]
    
    private let manager: NetworkManager = .init()
    
    private init() {
        if let stories = manager.fetchStories(count: storyCount) {
            self.stories = stories
            var tmpThumbnails: [Data?] = []
            for story in stories {
                tmpThumbnails.append(
                    manager.fetchImage(imageURL: story.url)
                )
            }
            thumbnails = tmpThumbnails
        } else {
            self.stories = []
            self.thumbnails = []
        }
    }
    
    func getStoryImage(forIndex: Int) -> Data? {
        if forIndex < 0 || forIndex >= stories.count {
            return nil
        }
        return manager.fetchImage(imageURL: stories[forIndex].hdurl)
    }
}
