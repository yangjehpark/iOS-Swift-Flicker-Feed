//
//  ImageManager.swift
//  FlickerFeed
//
//  Created by yangjehpark on 2017. 1. 21..
//  Copyright © 2017년 yangjehpark. All rights reserved.
//

import UIKit
import SDWebImage

class ImageParser {
    
    /*
     MARK: Get Image
     */
    class func getImage(imageIndex: Int, completionHandler: (image: UIImage?) -> Void) {
        
        if let imageUrl = NSURL(string: FeedManager.sharedInstance.items[imageIndex].media!.m!) {
            
            SDWebImageManager.sharedManager().downloadImageWithURL(imageUrl, options: SDWebImageOptions.HighPriority, progress: nil, completed: {
                (image:UIImage!, error:NSError!, type:SDImageCacheType, complete:Bool, url:NSURL!) in
                
                if (image != nil) {
                    completionHandler(image: image!)
                } else {
                    completionHandler(image: nil)
                }
            })
        }
        
    }
    
    /*
     MARK: Preload
     */
    class func preloadImages(criteriaIndex:Int) {
        
        let firstIndex = 0
        let lastIndex = FeedManager.sharedInstance.items.count-1
        // preload forward one
        let forwardTargetIndex = (criteriaIndex == lastIndex ? firstIndex : criteriaIndex+1)
        self.getImage(forwardTargetIndex, completionHandler: { (image) in
            if (image != nil) {
                
            }
        })
    }
    
}