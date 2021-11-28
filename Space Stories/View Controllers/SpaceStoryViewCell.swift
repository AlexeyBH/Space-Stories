//
//  SpaceStoryViewCell.swift
//  Space Stories
//
//  Created by Alexey Khestanov on 28.11.2021.
//

import UIKit

class SpaceStoryViewCell: UITableViewCell {

    // MARK: - IB Outlets
    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    
    // MARK: - Public methods
    func configCell(forIndex row: Int) -> UITableViewCell {
        var content = self.defaultContentConfiguration()
        self.selectionStyle = .none
        content.imageProperties.maximumSize = .init(
            width: self.bounds.height - 2,
            height: self.bounds.height - 2
        )
        if row >= SpaceStories.shared.thumbnails.count {
            // Почему-то это не работает, индикатор все равно не отображается
            // storyCell.activityIndicator.startAnimating()
            // Заменил статичной картинкой
            content.image = UIImage(named: "loadingSign")
        } else if let thumbnail = SpaceStories.shared.thumbnails[row],
                  let image = UIImage(data: thumbnail),
                  let cropped = cropImageToSquare(image: image) {
            // Image loaded successfully
            // storyCell.activityIndicator.stopAnimating()
            content.image  = cropped
        } else {
            // Image can not be loaded.
            content.image = UIImage(named: "questionMark")
        }
        content.text = SpaceStories.shared.stories[row].title
        content.textProperties.color = .lightGray
        self.contentConfiguration = content
        return self
    }
  
    
// MARK: - Private methods
    
    private func cropImageToSquare(image: UIImage) -> UIImage? {
        if let cgImage = image.cgImage {
            let size = min(cgImage.width, cgImage.height)
            let rect = CGRect(
                x: (cgImage.width  - size) / 2,
                y: (cgImage.height - size) / 2,
                width: size,
                height: size
            )
            if let cropped = cgImage.cropping(to: rect) {
                return UIImage(cgImage: cropped)
            } else {
                return nil
            }
        } else {
            return nil
        }
    }
    
}
