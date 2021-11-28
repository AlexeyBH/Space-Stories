//
//  StoryViewController.swift
//  Space Stories
//
//  Created by Alexey Khestanov on 27.11.2021.
//

import UIKit

class StoryViewController: UIViewController {
    
    // MARK: - IB Outlets
    
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    
    // MARK: - Public properties
    var index: Int = 0
    
    // MARK: - Private properties
    private var imageData: Data!
    
    // MARK: - Public methods
    func fetchImage(forIndex: Int) {
        print("Detailed image for row: \(forIndex)")
        if let safeData = SpaceStories.shared.getStoryImage(forIndex: index) {
            print("Got safe data..")
            if let image = UIImage(data: safeData) {
                print("Got image finished!")
                DispatchQueue.main.async {
                    self.imageView.image = image
                    self.activityIndicator.stopAnimating()
                }
            }
        }
    }


}
