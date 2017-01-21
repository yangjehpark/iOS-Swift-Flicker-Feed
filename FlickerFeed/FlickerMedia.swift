//
//  FlickerMedia.swift
//  FlickerFeed
//
//  Created by yangjehpark on 2017. 1. 21..
//  Copyright © 2017년 yangjehpark. All rights reserved.
//

import Foundation
import ObjectMapper

class FlickerMedia: Mappable {
    
    required init?(_ map: Map){
        
    }
    
    init() {
        
    }
    
    func mapping(map: Map) {
        self.m <- map["m"]
    }
    
    var m: String?
}