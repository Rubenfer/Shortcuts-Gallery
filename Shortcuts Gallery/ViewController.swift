//
//  ViewController.swift
//  Shortcuts Gallery
//
//  Created by Ruben Fernandez on 09/07/2018.
//  Copyright © 2018 Ruben Fernandez. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {

    let url = URL(string: "https://sharecuts.app/api/shortcuts/latest")
    var shortcuts: DiscoverShortcuts?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.prefersLargeTitles = true
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 70
        getData()
        tableView.reloadData()
    }
    
    func getData() {
        let dispatchGroup = DispatchGroup()
        dispatchGroup.enter()
        if let url = url {
            let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    print(error!)
                } else {
                    if let data = data {
                        do {
                            self.shortcuts = try JSONDecoder().decode(DiscoverShortcuts.self, from: data)
                        } catch {
                            print(error.localizedDescription)
                        }
                    }
                    dispatchGroup.leave()
                }
            }
            task.resume()
        }
        dispatchGroup.wait()
    }

}


extension ViewController { //TableView config
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let shortcuts = shortcuts {
            return shortcuts.count
        }
        return 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "cell")
        cell.textLabel?.text = shortcuts?.results[indexPath.row].title
        cell.detailTextLabel?.text = shortcuts?.results[indexPath.row].summary
        cell.detailTextLabel?.numberOfLines = 0
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let alert = UIAlertController(title: "Do you want to add this shortcut?", message: "This shortcut have \(shortcuts?.results[indexPath.row].actionCount ?? 0) actions", preferredStyle: .alert)
        let addBtn = UIAlertAction(title: "Yes", style: .default) { Void in
            let shortcutID = self.shortcuts?.results[indexPath.row].id
            let shortcutDetailURL = "https://sharecuts.app/api/shortcuts/" + shortcutID!
            var shortcutDetail: ShortcutDetail!
            let dispatchGroup = DispatchGroup()
            dispatchGroup.enter()
            if let url = URL(string: shortcutDetailURL) {
                let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
                    if error != nil {
                        print(error!)
                    } else {
                        if let data = data {
                            do {
                                shortcutDetail = try JSONDecoder().decode(ShortcutDetail.self, from: data)
                            } catch {
                                print(error.localizedDescription)
                            }
                        }
                        dispatchGroup.leave()
                    }
                }
                task.resume()
            }
            dispatchGroup.wait()
            let deepLink = URL(string: shortcutDetail.deepLink)
            UIApplication.shared.open(deepLink!, options: [:], completionHandler: nil)
        }
        alert.addAction(addBtn)
        alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
        self.present(alert, animated: true)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}
