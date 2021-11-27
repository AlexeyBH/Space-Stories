//
//  StoryListTableViewController.swift
//  Space Stories
//
//  Created by Alexey Khestanov on 27.11.2021.
//

import UIKit

class StoryListTableViewController: UITableViewController {

    private func reloadTableViewController() {
        self.tableView.reloadData()
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
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
