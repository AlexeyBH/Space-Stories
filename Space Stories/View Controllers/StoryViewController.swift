//
//  StoryViewController.swift
//  Space Stories
//
//  Created by Alexey Khestanov on 27.11.2021.
//

import UIKit

class StoryViewController: UIViewController {
    
  //  @IBOutlet var imageView: UIImageView!
    
    @IBOutlet var imageView: UIImageView!
    private var imageData: Data!
    
    
    private func updateImage() {
        if let data = imageData {
            imageView.image = UIImage(data: data)
            imageView.reloadInputViews()
        }
    }
    
    var index: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        SpaceStories.shared.onFinished = updateImage
        imageData = SpaceStories.shared.getStoryImage(forIndex: index)
    }

}
