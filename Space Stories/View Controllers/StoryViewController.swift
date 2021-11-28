//
//  StoryViewController.swift
//  Space Stories
//
//  Created by Alexey Khestanov on 27.11.2021.
//

import UIKit
import Spring

class StoryViewController: UIViewController {
    
    // MARK: - IB Outlets
    
    @IBOutlet var imageView: SpringImageView!
    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    
    // MARK: - Public properties
    var index: Int = 0
    
    // MARK: - Private properties
    private var imageData: Data!
    
    // MARK: - Public methods
    func fetchImage(forIndex: Int) {
        print("Detailed image for row: \(forIndex)")
        //var data: Data?
        DispatchQueue.global().async {
            print("async")
            //data =
            if let safeData = SpaceStories.shared.getStoryImage(forIndex: self.index) {
                print("Got safe data..")
                if let image = UIImage(data: safeData) {
                    print("Got image finished!")
                    DispatchQueue.main.async {
                        self.activityIndicator.stopAnimating()
                        self.imageView.image = image
                        self.imageView.bounds = .init(
                            x: self.imageView.bounds.minX,
                            y: self.imageView.bounds.minY,
                            width: image.size.width,
                            height: image.size.height
                        )
                        self.imageView.animate()
                    }
                }
            }
        }

    }


}
