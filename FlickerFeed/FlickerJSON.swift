//
//  FlickerJSON.swift
//  FlickerFeed
//
//  Created by yangjehpark on 2017. 1. 21..
//  Copyright © 2017년 yangjehpark. All rights reserved.
//

import Foundation
import ObjectMapper

class FlickerJSON: Mappable {
    
    required init?(_ map: Map){
        
    }
    
    init() {
        
    }
    
    func mapping(map: Map) {
        self.title <- map["title"]
        self.link <- map["link"]
        self.description <- map["description"]
        self.modified <- map["modified"]
        self.generator <- map["generator"]
        self.items <- map["items"]
    }
    
    var title: String?
    var link: String?
    var description: String?
    var modified: String?
    var generator: String?
    var items: [FlickerItem]?
}