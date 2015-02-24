//
//  ViewController.swift
//  PKNotification
//
//  Created by hakopako on 2014/12/24.
//  Copyright (c) 2014年 hakopako. All rights reserved.
//

/*
//-- How to use PKNotification ----------------------------------------------
alert - not implemented yet :(
PKNotification.alert()

//toast
PKNotification.toast(message:"hogehogehogehoge")

//progress
PKNotification.loading(true)
PKNotification.loading(false)
PKNotification.success(nil)
PKNotification.failed("Foo")
//-------------------------------------------------------------
*/

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var alertButton: UIButton!
    @IBOutlet weak var alertButton2Options: UIButton!
    @IBOutlet weak var alertButton3OrMore: UIButton!
    @IBOutlet weak var toastButton: UIButton!
    @IBOutlet weak var loadingButton: UIButton!
    @IBOutlet weak var successButton: UIButton!
    @IBOutlet weak var failedButton: UIButton!
    //let pkNotification:PKNotification = PKNotification()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        PKNotification.alertCornerRadius = 1
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    @IBAction func alertButtonDown(sender: AnyObject) {
        PKNotification.alert(
            title: "Success !!",
            message: "Foooooooooooooo\nDisplay this default style pop up view.\nBaaaaaar",
            items: nil,
            cancelButtonTitle: "O K",
            tintColor: nil)
        
    }
    
    @IBAction func alertButton2OptionsDown(sender: AnyObject) {
        PKNotification.alert(
            title: "Notice",
            message: "Foooooooooooooo\nDisplay this default style pop up view.\nBaaaaaar",
            items: [
                PKNotification.generatePKButton(
                    title: "Foo",
                    action: { () -> Void in
                        NSLog("Foo is clicked.")
                    },
                    fontColor: UIColor(red: 0, green: 0.55, blue: 0.9, alpha: 1.0),
                    backgroundColor: nil)
            ],
            cancelButtonTitle: "Cancel",
            tintColor: nil)
    }
    
    @IBAction func alertButton3OrMoreDown(sender: AnyObject) {
        PKNotification.alert(
            title: "Done",
            message: "Foooooooooooooo\nDisplay this default style pop up view.\nBaaaaaar",
            items: [
                PKNotification.generatePKButton(
                    title: "Foo",
                    action: { () -> Void in
                        NSLog("Foo is clicked.")
                    },
                    fontColor: UIColor.purpleColor(),
                    backgroundColor: nil),
                PKNotification.generatePKButton(
                    title: "Bar",
                    action: { () -> Void in
                        NSLog("Bar is clicked.")
                    },
                    fontColor: nil,
                    backgroundColor: nil)
            ],
            cancelButtonTitle: nil,
            tintColor: UIColor(red: 0.8, green: 0.8, blue: 0.8, alpha: 1.0))
    }

    @IBAction func toastButtonDown(sender: AnyObject) {
        PKNotification.toastBackgroundColor = UIColor.purpleColor()
        PKNotification.toast("hogehogehogehoge")
    }
    
    @IBAction func loadingButtonDown(sender: AnyObject) {
        PKNotification.loading(true)
        NSLog("start loading...")
        NSTimer.scheduledTimerWithTimeInterval(2.0, target: self, selector:"onUpdate:", userInfo: nil, repeats: false)
    }
    
    func onUpdate(timer: NSTimer) {
        NSLog("finish loading...")
        PKNotification.loading(false)
    }
    
    @IBAction func successButtonDown(sender: AnyObject) {
        PKNotification.successBackgroundColor = UIColor.blueColor()
        PKNotification.success(nil)
    }
    
    @IBAction func failedButtonDown(sender: AnyObject) {
        PKNotification.failed("Failed ...")
    }

}

