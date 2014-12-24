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

}

