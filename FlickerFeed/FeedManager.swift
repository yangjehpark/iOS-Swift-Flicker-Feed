//
//  FeedManager.swift
//  FlickerFeed
//
//  Created by yangjehpark on 2017. 1. 21..
//  Copyright © 2017년 yangjehpark. All rights reserved.
//

import UIKit
import Alamofire

class FeedManager {
    
    static let sharedInstance = FeedManager()
    
    var items = [FlickerItem]()
 
    func getFeed(completionHandler: (complete: Bool, error: NSError?) -> Void) {
        let urlString = "http://api.flickr.com/services/feeds/photos_public.gne?lang=en-us&format=json&nojsoncallback=1"
        let responseObjectType = FlickerJSON()
        
        Parser.requestAndResponseObject(Method.GET, urlString: urlString, parameters: nil, encoding: ParameterEncoding.URL, headers: nil, responseObjectType: responseObjectType) { (responseObject, error) in
            if (responseObject != nil) {
                if (responseObject!.items != nil && responseObject!.items?.count != 0) {
                    for item in responseObject!.items! {
                        self.items.append(item)
                    }
                    completionHandler(complete: true, error: nil)
                } else {
                    // no more feed item to get
                    completionHandler(complete: false, error: nil)
                }
            } else {
                // get fail
                completionHandler(complete: false, error: error)
            }
        }
    }
}