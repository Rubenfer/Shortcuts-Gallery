//
//  Model.swift
//  Shortcuts Gallery
//
//  Created by Ruben Fernandez on 09/07/2018.
//  Copyright © 2018 Ruben Fernandez. All rights reserved.
//

import Foundation

class DiscoverShortcuts: Codable {
    var count: Int!
    var results: [ShortcutResult]!
}

class ShortcutResult: Codable {
    var summary: String!
    var userID: String!
    var fileID: String!
    var id: String!
    var actionIdentifiers: [String]!
    var title: String!
    var updatedAt: String!
    var createdAt: String!
    var filePath: String!
    var actionCount: Int!
}

class ShortcutDetail: Codable {
    var shortcut: ShortcutResult!
    var deepLink: String!
    var download: String!
    var user: ShortcutUser!
}

class ShortcutUser: Codable {
    var username: String!
    var id: String!
    var name: String!
    var url: String!
}
