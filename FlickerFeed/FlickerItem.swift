//
//  FlickerItem.swift
//  FlickerFeed
//
//  Created by yangjehpark on 2017. 1. 21..
//  Copyright © 2017년 yangjehpark. All rights reserved.
//

import Foundation
import ObjectMapper

class FlickerItem: Mappable {
    
    required init?(_ map: Map){
        
    }
    
    init() {
        
    }
    
    func mapping(map: Map) {
        self.title <- map["title"]
        self.link <- map["link"]
        self.media <- map["media"]
        self.date_taken <- map["date_taken"]
        self.description <- map["description"]
        self.published <- map["published"]
        self.author <- map["author"]
        self.author_id <- map["author_id"]
        self.tags <- map["tags"]
    }
    
    var title: String?
    var link: String?
    var media: FlickerMedia?
    var date_taken: String?
    var description: String?
    var published: String?
    var author: String?
    var author_id: String?
    var tags: String?
}