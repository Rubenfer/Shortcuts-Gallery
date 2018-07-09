//
//  Utils.swift
//  Shortcuts Gallery
//
//  Created by Ruben Fernandez on 09/07/2018.
//  Copyright © 2018 Ruben Fernandez. All rights reserved.
//

import Foundation

class Utils {
    
    func getShortcuts() -> DiscoverShortcuts {
        var shortcuts: DiscoverShortcuts!
        let dispatchGroup = DispatchGroup()
        let url = URL(string: "https://sharecuts.app/api/shortcuts/latest")
        dispatchGroup.enter()
        if let url = url {
            let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    print(error!)
                } else {
                    if let data = data {
                        do {
                            shortcuts = try JSONDecoder().decode(DiscoverShortcuts.self, from: data)
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
        return shortcuts
    }
    
    func getShortcutDetail(id: String) -> ShortcutDetail {
        var shortcutDetail: ShortcutDetail!
        let shortcutDetailURL = "https://sharecuts.app/api/shortcuts/" + id
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
        return shortcutDetail
    }
    
    func searchShortcuts(keyword: String) -> DiscoverShortcuts {
        if keyword == "" {
            return getShortcuts()
        } else {
            #warning("Waiting to search feature release")
            return getShortcuts()
        }
    }
    
}
