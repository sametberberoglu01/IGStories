//
//  Stories.swift
//  IGStories
//
//  Created by Samet Berberoglu on 26.04.2020.
//  Copyright © 2020 Samet Berberoglu. All rights reserved.
//

import Foundation

class Stories: Decodable {
    var stories: [Story]?
    
    lazy var count = stories?.count ?? 0
}

class Story: Decodable {
    var user: User?
    var userStories: [UserStory]?
    
    lazy var count = userStories?.count ?? 0
}

class User: Decodable {
    var username: String?
    var profilePhotoUrl: String?
}

class UserStory: Decodable {
    
    enum ContentType: String {
        case image = "image", video = "video"
    }
    
    var url: String?
    var lastUpdated: String?
    lazy var type = ContentType(rawValue: mimeType ?? "") ?? .image
    
    private var mimeType: String?
}
