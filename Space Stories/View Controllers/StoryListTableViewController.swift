//
//  StoryListTableViewController.swift
//  Space Stories
//
//  Created by Alexey Khestanov on 27.11.2021.
//

import UIKit

class StoryListTableViewController: UITableViewController {

    private func reloadTableViewController() {
        DispatchQueue.main.async {
            print("On Finished thred..")
            self.tableView.reloadData()
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
    
    private func cropImageToRect(_ image: UIImage, _ size: Int) {
     //   .. let rect = CGRect(x: image, y: 0, width: 0, height: 0)
        
        
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let row = indexPath.row
        let shared = SpaceStories.shared
        let cell = tableView.dequeueReusableCell(withIdentifier: "spaceStoryCell", for: indexPath)
        var content = cell.defaultContentConfiguration()
        
        if let thumbnail = shared.thumbnails[row] {
            if let image = UIImage.init(data: thumbnail) {
                cell.imageView?.layer.cornerRadius = 50
                //let thumbnail = image.resizableImage(withCapInsets: .init(top: 0, left: 0, bottom: 100, right: 100))
                content.image = image
            }
        } else {
            content.image = UIImage.init(named: "questionMark")
        }
        
        content.text = shared.stories[row].title
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
