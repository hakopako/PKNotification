//
//  ViewController.swift
//  PKNotification
//
//  Created by hakopako on 2014/12/24.
//  Copyright (c) 2014年 hakopako. All rights reserved.
//

/*
//-- How to use PKNotification ----------------------------------------------
//alert - not implemented yet :(
//PKNotification().alert()

//toast
PKNotification().toast(message:"hogehogehogehoge")

//progress
PKNotification().loading(true)
PKNotification().loading(false)
PKNotification().success(nil)
PKNotification().failed("Foo")
//-------------------------------------------------------------
*/

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var toastButton: UIButton!
    @IBOutlet weak var loadingButton: UIButton!
    @IBOutlet weak var successButton: UIButton!
    @IBOutlet weak var failedButton: UIButton!
    let pkNotification:PKNotification = PKNotification()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    @IBAction func toastButtonDown(sender: AnyObject) {
        pkNotification.toast(message:"hogehogehogehoge")
    }
    
    @IBAction func loadingButtonDown(sender: AnyObject) {
        pkNotification.loading(true)
        NSLog("start loading...")
        NSTimer.scheduledTimerWithTimeInterval(2.0, target: self, selector:"onUpdate:", userInfo: nil, repeats: false)
    }
    
    func onUpdate(timer: NSTimer) {
        NSLog("finish loading...")
        self.pkNotification.loading(false)
    }
    
    @IBAction func successButtonDown(sender: AnyObject) {
        pkNotification.success(nil)
    }
    
    @IBAction func failedButtonDown(sender: AnyObject) {
        pkNotification.failed("Try again ...")
    }

}

