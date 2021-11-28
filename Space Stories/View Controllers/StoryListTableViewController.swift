//
//  StoryListTableViewController.swift
//  Space Stories
//
//  Created by Alexey Khestanov on 27.11.2021.
//

import UIKit

class StoryListTableViewController: UITableViewController {
    
    // MARK: - Private Properties

    private var rowId: Int = 0
     
    // MARK: - Override funcs
    
    override func viewDidLoad() {
        super.viewDidLoad()
        SpaceStories.shared.onFinished = reloadTableViewController
    }

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
        let cell = tableView.dequeueReusableCell(withIdentifier: "spaceStoryCell", for: indexPath)
        if let storyCell = cell as? SpaceStoryViewCell {
            return storyCell.configCell(forIndex: indexPath.row)
        } else {
            return cell
        }
    }

    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        rowId = indexPath.row
        return indexPath
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let dest = segue.destination as? StoryViewController else { return }
        if let data = SpaceStories.shared.thumbnails[self.rowId],
           let _ = UIImage(data: data) {
            dest.index = self.rowId
            dest.configView(forIndex: self.rowId)
        } else {
            showAlert("Sorry, this story can't be opened. Please try another one..")
        }
    }

// MARK: - Private methods
    
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
    
  
}
