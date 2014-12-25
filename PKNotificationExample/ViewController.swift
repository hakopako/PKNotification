//
//  ViewController.swift
//  PKNotification
//
//  Created by hakopako on 2014/12/24.
//  Copyright (c) 2014年 hakopako. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var toastButton: UIButton!
    @IBOutlet weak var loadingButton: UIButton!
    @IBOutlet weak var successButton: UIButton!
    @IBOutlet weak var failedButton: UIButton!
    let pkNotification:PKNotification = PKNotification()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
/*
        //alert
        PKNotification().alert()
        
        
        //toast
        PKNotification().toast(message:"hogehogehogehoge", style:nil)
        
        //progress
        PKNotification().loading(true)
        PKNotification().loading(false)
        PKNotification().success()
        PKNotification().failed()

*/
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    @IBAction func toastButtonDown(sender: AnyObject) {
        pkNotification.toast(message:"hogehogehogehoge", style:nil)
    }
    
    @IBAction func loadingButtonDown(sender: AnyObject) {
        pkNotification.loading(true)
        NSLog("ロード開始")
        NSTimer.scheduledTimerWithTimeInterval(2.0, target: self, selector:"onUpdate:", userInfo: nil, repeats: false)
    }
    
    func onUpdate(timer: NSTimer) {
        NSLog("ロード終わり")
        self.pkNotification.loading(false)
    }
    
    @IBAction func successButtonDown(sender: AnyObject) {
        pkNotification.success()
    }
    
    @IBAction func failedButtonDown(sender: AnyObject) {
        pkNotification.failed()
    }

}

