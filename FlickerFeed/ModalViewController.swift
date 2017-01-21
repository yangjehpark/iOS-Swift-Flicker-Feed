//
//  ModalViewController.swift
//  FlickerFeed
//
//  Created by yangjehpark on 2017. 1. 21..
//  Copyright © 2017년 yangjehpark. All rights reserved.
//

import UIKit

protocol ModalViewControllerDelegate {
    func start(interval: NSTimeInterval)
}

class ModalViewController: FlickerFeedViewController {
    static let identifier = "ModalViewController"
    var delegate = ModalViewControllerDelegate?()
    @IBOutlet weak var startButton:UIButton!
    @IBOutlet weak var intervalSilder:UISlider!
    @IBOutlet weak var intervalLabel:UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.intervalSilder.value = 7
        self.intervalSilder.minimumValue = 5
        self.intervalSilder.maximumValue = 10
        self.valueChanged(self.intervalSilder)
    }
    
    @IBAction func valueChanged(silder: UISlider) {
        self.intervalLabel.text = String(Float(Int(silder.value*10))/10)+" sec"
    }
    
    @IBAction func startButtonPressed(sender: UIButton) {
        let interval = NSTimeInterval(self.intervalSilder.value)
        self.dismissViewControllerAnimated(true) {
            self.delegate?.start(interval)
        }
    }
}