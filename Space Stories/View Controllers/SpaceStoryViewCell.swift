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
    func configCell(parent: StoryListTableViewController) -> UITableViewCell {
        let row = parent.rowId
        var content = self.defaultContentConfiguration()
        self.selectionStyle = .none
        content.imageProperties.maximumSize = .init(
            width: self.bounds.height - 10,
            height: self.bounds.height - 10
        )
        
        if row < parent.thumbnails.count,
           let image = parent.thumbnails[row] {
            content.image = image
        } else {
            content.image = UIImage(named: "questionMark")
        }

        content.text = parent.spaceStories[row].title
        content.textProperties.color = .lightGray
        self.contentConfiguration = content
        return self
    }    
}
