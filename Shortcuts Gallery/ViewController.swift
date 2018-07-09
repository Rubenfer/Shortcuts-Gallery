//
//  ViewController.swift
//  Shortcuts Gallery
//
//  Created by Ruben Fernandez on 09/07/2018.
//  Copyright © 2018 Ruben Fernandez. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {

    var shortcuts: DiscoverShortcuts?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.prefersLargeTitles = true
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 70
        shortcuts = Utils().getShortcuts()
        tableView.reloadData()
    }
    
    @IBAction func searchBtn(_ sender: Any) {
        let alert = UIAlertController(title: "Search Shortcuts", message: "", preferredStyle: .alert)
        alert.addTextField(configurationHandler: { (textField) in
            textField.placeholder = "Text to search"
        })
        let searchAction = UIAlertAction(title: "Search", style: .default) { Void in
            let textToSearch = alert.textFields?.first?.text
            self.shortcuts = Utils().searchShortcuts(keyword: textToSearch!)
            self.tableView.reloadData()
        }
        alert.addAction(searchAction)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(alert, animated: true)
    }

}

extension ViewController { // TableView config
    
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
            let shortcutDetail = Utils().getShortcutDetail(id: shortcutID!)
            let deepLink = URL(string: shortcutDetail.deepLink)
            UIApplication.shared.open(deepLink!, options: [:], completionHandler: nil)
        }
        alert.addAction(addBtn)
        alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
        self.present(alert, animated: true)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}
