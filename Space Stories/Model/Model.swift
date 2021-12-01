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
    
    init(from dict: [String: Any]) {
        explanation = dict["explanatiob"] as? String
        url = dict["url"] as? String
        hdurl = dict["hdurl"] as? String
        title = dict["title"] as? String
    }
}


