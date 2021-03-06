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
    @IBOutlet var storyText: SpringLabel!
    
    // MARK: - Public properties
    var index: Int = 0
    
    // MARK: - Public methods
    func configView(parent: StoryListTableViewController) {
        guard let url = parent.spaceStories[parent.rowId].hdurl else {
            return
        }
        NetworkManager.shared.fetchData(url: url, handler: makeHandler(parent: parent))
    }
    
    private func makeHandler(parent: StoryListTableViewController) -> (Result<Data, NetworkError>) -> Void {
        return { result in
            switch result {
            case .success(let data):
                if let image = UIImage(data: data) {
                    self.activityIndicator.stopAnimating()
                    self.imageView.image = image
                    self.imageView.bounds = .init(
                        x: self.imageView.bounds.minX,
                        y: self.imageView.bounds.minY,
                        width: image.size.width,
                        height: image.size.height
                    )
                    
                    let strokeTextAttributes = [
                        NSAttributedString.Key.strokeColor: UIColor.black,
                        NSAttributedString.Key.foregroundColor: UIColor.white,
                        NSAttributedString.Key.strokeWidth: -2.0,
                        NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 25)
                    ] as [NSAttributedString.Key : Any]
                    
                    let myAttrString = NSAttributedString(
                        string: parent.spaceStories[parent.rowId].explanation ?? "",
                        attributes: strokeTextAttributes
                    )
                    self.storyText.attributedText = myAttrString
                }
            default:
                return
            }
        }
 
    }

}
