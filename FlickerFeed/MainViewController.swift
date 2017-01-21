//
//  ViewController.swift
//  FlickerFeed
//
//  Created by yangjehpark on 2017. 1. 21..
//  Copyright © 2017년 yangjehpark. All rights reserved.
//

import UIKit
import PagingView

class MainViewController: FlickerFeedViewController, PagingViewDataSource, PagingViewDelegate, UIScrollViewDelegate, ModalViewControllerDelegate {
    
    /*
     MARK: UIViewController
     */
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initPagingView()
        self.performSelector(#selector(MainViewController.showModalViewController), withObject: nil, afterDelay: 0.0)
    }
    
    /*
     MARK: ModalViewController
     */
    func showModalViewController() {
        let modalViewController: ModalViewController = self.mainStoryboard.instantiateViewControllerWithIdentifier(ModalViewController.identifier) as! ModalViewController
        modalViewController.delegate = self
        self.presentViewController(modalViewController, animated: true, completion: nil)
    }

    /*
     MARK: ModalViewControllerDelegate
     */
    func start(interval: NSTimeInterval) {
        self.animatingInterval = interval
        self.getFeed()
    }
    
    /*
     MARK: UI
     */
    private func initPagingView() {
        self.pagingView.infinite = true
        self.pagingView.dataSource = self
        self.pagingView.delegate = self
        self.pagingView.showsHorizontalScrollIndicator = false
        self.pagingView.pagingMargin = UInt(pagingViewMargin)
        self.pagingViewMarginLeft?.constant = -pagingViewMargin
        self.pagingViewMarginRight?.constant = -pagingViewMargin
        self.pagingView.registerNib(UINib(nibName: "PagingImageViewCell", bundle: nil), forCellWithReuseIdentifier: PagingImageViewCell.reuseIdentifier)
    }
    
    private func getFeed() {
        FeedManager.sharedInstance.getFeed { (complete, error) in
            if (error == nil) {
                if (complete) {
                    self.showFeed()
                } else {
                    self.showPopup(title: "Sorry", message: "No more feed now", completionHandler: { (complete) in
                        
                    })
                }
            } else {
                
                self.showRetryPopup(title: (error != nil ? String(error!.code) : "Sorry"), message: "Fail to get more feed", completionHandler: { (retry) in
                    if (retry) {
                        self.getFeed()
                    } else {
                        self.showModalViewController()
                    }
                })
            }
        }
    }
    
    private func showFeed() {
        self.pagingView.reloadData()
        self.startAnimating(self.animatingInterval)
    }
    
    /*
     MARK: PagingViewDelegate, PagingViewDataSource
     */
    @IBOutlet private weak var pagingView: PagingView!
    private let pagingViewMargin: CGFloat = 10
    @IBOutlet private weak var pagingViewMarginLeft: NSLayoutConstraint?
    @IBOutlet private weak var pagingViewMarginRight: NSLayoutConstraint?
    private var currentIndex:Int = 0
    
    func numberOfSectionsInPagingView(pagingView: PagingView) -> Int {
        return 1
    }
    
    func pagingView(pagingView: PagingView, numberOfItemsInSection section: Int) -> Int {
        return FeedManager.sharedInstance.items.count
    }
    
    func pagingView(pagingView: PagingView, cellForItemAtIndexPath indexPath: NSIndexPath) -> PagingViewCell {
        let cell = pagingView.dequeueReusableCellWithReuseIdentifier(PagingImageViewCell.reuseIdentifier) as! PagingImageViewCell
        cell.numberLabel.text = String(indexPath.item+1)+"/"+String(FeedManager.sharedInstance.items.count)
        cell.titleLabel.text = FeedManager.sharedInstance.items[indexPath.item].title
        cell.zoomableView.image = nil
        ImageParser.getImage(indexPath.row, completionHandler: { (image) in
            cell.zoomableView.image = image
            ImageParser.preloadImages(indexPath.row)
        })
        return cell
    }
    
    func pagingView(pagingView: PagingView, willDisplayCell cell: PagingViewCell, forItemAtIndexPath indexPath: NSIndexPath) {
        let beforeLastItemIndex = FeedManager.sharedInstance.items.count-3
        if (self.currentIndex == beforeLastItemIndex) {
            self.getFeed()
        }
    }
    
    func pagingView(pagingView: PagingView, didEndDisplayingCell cell: PagingViewCell, forItemAtIndexPath indexPath: NSIndexPath) {
        if let zoomableView = (cell as? PagingImageViewCell)?.zoomableView {
            if let zoomScale: CGFloat = zoomableView.zoomScale where zoomScale > 1.0 {
                zoomableView.setZoomScale(1.0, animated: false)
            }
        }
        self.startAnimating(self.animatingInterval)
    }
    
    func indexPathOfStartingInPagingView(pagingView: PagingView) -> NSIndexPath? {
        if (FeedManager.sharedInstance.items.count > 0) {
            return NSIndexPath(forItem: self.currentIndex, inSection: 0)
        } else {
            return nil
        }
    }
    
    /*
     MARK: UIScrollViewDelegate
     */
    func scrollViewDidScroll(scrollView: UIScrollView) {
        if (scrollView == self.pagingView) {
            if let centerCell = self.pagingView!.visibleCenterCell() as? PagingImageViewCell {
                self.currentIndex = centerCell.indexPath.item
            }
        }
    }
    
    /*
     MARK: Auto Scroll
     */
    var animatingTimer: NSTimer?
    var animatingInterval: NSTimeInterval = 5

    func startAnimating(interval: NSTimeInterval) {
        self.stopAnimating()
        if (self.animatingTimer == nil) {
            self.animatingTimer = NSTimer.scheduledTimerWithTimeInterval(interval, target: self, selector: #selector(MainViewController.doAnimate), userInfo: nil, repeats: false)
            self.animatingTimer?.valid
        }
    }
    
    func doAnimate() {
        if (FeedManager.sharedInstance.items.count > 1) {
            self.pagingView?.scrollToPosition(Position.Right, indexPath: nil, animated: true)
        } else {
            self.stopAnimating()
        }
    }
    
    func stopAnimating() {
        if (self.animatingTimer != nil) {
            self.animatingTimer!.invalidate()
            self.animatingTimer = nil
        }
    }
}