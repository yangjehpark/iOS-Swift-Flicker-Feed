//
//  PagingImageViewCell.swift
//  FlickerFeed
//
//  Created by yangjehpark on 2017. 1. 21..
//  Copyright © 2017년 yangjehpark. All rights reserved.
//

import UIKit
import PagingView

class PagingImageViewCell: PagingViewCell, DTZoomableViewDelegate {
    
    static let reuseIdentifier = "PagingImageViewCellReuseIdentifire"
    @IBOutlet weak var zoomableView: DTZoomableView!
    @IBOutlet weak var numberLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    var image:UIImage?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.zoomableView!.zoomableDelegate = self
    }
}
