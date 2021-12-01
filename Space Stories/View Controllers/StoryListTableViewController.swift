//
//  StoryListTableViewController.swift
//  Space Stories
//
//  Created by Alexey Khestanov on 27.11.2021.
//

import UIKit

class StoryListTableViewController: UITableViewController {
    // MARK: - Public properties
    var thumbnails: [UIImage?] = []
    var storyAvailable: [Bool] = []
    var spaceStories: [SpaceStory] = []
    var rowId: Int = 0
    
    // MARK: - Private Properties

    private var loadingImage: UIImage!
    private var questionImage: UIImage!

    // MARK: - Override funcs
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadingImage = UIImage(named: "loadingSign")
        questionImage = UIImage(named: "questionMark")
        NetworkManager.shared.fetchStories(handler: handler)
    }

   override func numberOfSections(in tableView: UITableView) -> Int {
       return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return spaceStories.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        100
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "spaceStoryCell", for: indexPath)
        if let storyCell = cell as? SpaceStoryViewCell {
            return storyCell.configCell(parent: self, row: indexPath.row)
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
        if self.rowId >= storyAvailable.count {
            showAlert("Please wait, stories are being downloaded")
        } else if !storyAvailable[self.rowId] {
            showAlert("Sorry, this story can't be opened. Please try another one..")
        } else {
            dest.index = self.rowId
            dest.configView(parent: self)
        }
    }

// MARK: - Private methods
    
    private func handler(result: Result<[SpaceStory], NetworkError>) {
        switch result {
        case .success(let stories):
            self.spaceStories = stories
            self.tableView.reloadData()
            thumbnails = (0..<stories.count).map { _ in loadingImage}
            storyAvailable = (0..<stories.count).map { _ in false }
            for (index, story) in stories.enumerated() {
                if let url = story.url {
                    NetworkManager.shared.fetchData(
                        url: url,
                        handler: makeThumbnailHandler(index: index)
                    )
                }
            }
        case .failure(let error):
            showAlert(error.rawValue)
        }
    }
    
    // Так как сетевые запросы выполняются асинхронно, эта функция генерирует
    // требуемый обработчик в зависимости от индекса картинки в массиве.
    // Созданный обработчик знает к какому именно индексу обращаться при его выполнении.
    private func makeThumbnailHandler(index: Int) -> (Result<Data, NetworkError>) -> Void {
        return { result in
            switch result {
            case .success(let data):
                if let image = UIImage(data: data) {
                    self.thumbnails[index] = self.cropImageToSquare(image: image)
                    self.storyAvailable[index] = true
                } else {
                    self.thumbnails[index] = UIImage(named: "questionMark")
                    self.storyAvailable[index] = false
                }
            case .failure(_):
                self.thumbnails[index] = UIImage(named: "questionMark")
                self.storyAvailable[index] = false
            }
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
  
}
