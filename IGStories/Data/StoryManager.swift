//
//  StoryManager.swift
//  IGStories
//
//  Created by Samet Berberoglu on 26.04.2020.
//  Copyright © 2020 Samet Berberoglu. All rights reserved.
//

import Foundation

class StoryManager {
    
    static let shared = StoryManager()
    
    private init() {}
    
    var stories: [Story]?
    
    func loadStories() {
        guard let url = Bundle.main.url(forResource: "stories", withExtension: "json"),
            let data = try? Data.init(contentsOf: url),
            let stories = try? JSONDecoder().decode(Stories.self, from: data) else { return }
        self.stories = stories.stories
    }
    
}
