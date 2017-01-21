//
//  DTZoomableView.swift
//  DTZoomableView
//
//  Created by Dimitris-Sotiris Tsolis on 24/6/14.
//  Copyright (c) 2014 DFG-Team. All rights reserved.
//

import UIKit

@objc protocol DTZoomableViewDelegate: NSObjectProtocol {
    optional func didDoubleTapZoomableView(zoomableView: DTZoomableView!) -> Void
    optional func didSingleTapZoomableView(zoomableView: DTZoomableView!) -> Void
}

class DTZoomableView: UIScrollView, UIScrollViewDelegate {
    
    // MARK: declarations
    var zoomableDelegate: DTZoomableViewDelegate?
    var imageView: UIImageView?
    
    var image: UIImage? {
        didSet {
            if let unwrappedView = imageView {
                unwrappedView.image = image
                
                if let unwrappedImageView = self.imageView {
                    unwrappedImageView.image = image
                }
            }
        }
    }
    
    // MARK: initializatons
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.commonInit()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.commonInit()
    }
    
    func commonInit() {
        
        self.delegate = self
        self.minimumZoomScale = 1.0
        self.maximumZoomScale = 3.0
        self.showsVerticalScrollIndicator = false
        self.showsHorizontalScrollIndicator = false
        self.bounces = false
        
        let doubleTap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(DTZoomableView.doubleTapped(_:)))
        doubleTap.numberOfTapsRequired = 2
        self.addGestureRecognizer(doubleTap)
        
        let singleTap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(DTZoomableView.singleTapped(_:)))
        singleTap.numberOfTapsRequired = 1
        self.addGestureRecognizer(singleTap)
    }
    
    // MARK: layout
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if (self.imageView == nil) {
            // init imageView for the first time
            self.imageView = UIImageView(frame: self.bounds)
            self.imageView!.contentMode = UIViewContentMode.ScaleAspectFit
            //self.imageView!.autoresizingMask = .FlexibleWidth | .FlexibleHeight
            self.imageView!.autoresizingMask = UIViewAutoresizing.FlexibleWidth
            
            //self.imageView!.setTranslatesAutoresizingMaskIntoConstraints(true)
            
            self.addSubview(self.imageView!)
            
            if let unwrappedImage = self.image {
                self.imageView!.image = unwrappedImage
            }
        }
    }
    
    
    
    // MARK: touch handling
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if let unwrappedDelegate = self.zoomableDelegate {
            if unwrappedDelegate.respondsToSelector(#selector(DTZoomableViewDelegate.didDoubleTapZoomableView(_:))) {
                unwrappedDelegate.didDoubleTapZoomableView!(self)
            }
        }
    }
    
    // MARK: recognizer
    func doubleTapped(recognizer: UITapGestureRecognizer) {
        if self.zoomScale > 1.0 {
            self.setZoomScale(1.0, animated: true)
        }
        else {
            let point = recognizer.locationInView(self)
            self.zoomToRect(CGRectMake(point.x, point.y, 0, 0), animated: true)
        }
    }
    
    func singleTapped(recognizer: UITapGestureRecognizer) {
        if let unwrappedDelegate = self.zoomableDelegate {
            if unwrappedDelegate.respondsToSelector(#selector(DTZoomableViewDelegate.didSingleTapZoomableView(_:))) {
                unwrappedDelegate.didSingleTapZoomableView!(self)
            }
        }
    }
    
    // MARK: UIScrollView
    func scrollViewDidEndZooming(scrollView: UIScrollView, withView view: UIView?, atScale scale: CGFloat) {
        
    }
    
    func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
        return self.imageView!
    }
    
    
    // MARK: Enables or not the zoom capability.
    func setZoomEnabled(enabled: Bool) {
        if enabled {
            self.maximumZoomScale = 3.0
        }
        else {
            self.maximumZoomScale = 1.0
        }
    }
    
    // MARK: Returns 'true' if the zoom is enabled
    func isZoomEnabled() -> Bool {
        return self.maximumZoomScale > 1.0
    }
}
