//
//  StoryListTableViewController.swift
//  Space Stories
//
//  Created by Alexey Khestanov on 27.11.2021.
//

import UIKit

class StoryListTableViewController: UITableViewController {

    private var rowId: Int = 0
    
    private func onError(message: String) {
        showAlert("Failed to load data from remote site.")
    }
    
    private func reloadTableViewController() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    private func showAlert(_ text: String) {
        DispatchQueue.main.async {
            
            let alert = UIAlertController(
                title: "Error",
                message: text,
                preferredStyle: .alert
            )
            let action = UIAlertAction(title: "OK", style: .default)
            alert.addAction(action)
            self.present(alert, animated: true)
        }
    }
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        SpaceStories.shared.onFinished = reloadTableViewController
    }

    // MARK: - Table view data source

   override func numberOfSections(in tableView: UITableView) -> Int {
       return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return SpaceStories.shared.stories.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        100
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let row = indexPath.row
        let cell = tableView.dequeueReusableCell(withIdentifier: "spaceStoryCell", for: indexPath)
        var content = cell.defaultContentConfiguration()
        
        if let thumbnail = SpaceStories.shared.thumbnails[row],
           let image = UIImage(data: thumbnail),
           let cropped = cropImageToSquare(image: image) {
            content.image  = cropped
            content.imageProperties.maximumSize = .init(
                width: cell.bounds.height - 2,
                height: cell.bounds.height - 2
            )
        } else {
            content.image = UIImage.init(named: "questionMark")
        }
        
        content.text = SpaceStories.shared.stories[row].title
        cell.contentConfiguration = content
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        rowId = indexPath.row
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let dest = segue.destination as? StoryViewController else { return }
        dest.index = rowId
        
    }



}
