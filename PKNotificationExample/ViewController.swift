//
//  ViewController.swift
//  PKNotification
//
//  Created by hakopako on 2014/12/24.
//  Copyright (c) 2014年 hakopako. All rights reserved.
//


import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var alertButton: UIButton!
    @IBOutlet weak var alertButton2Options: UIButton!
    @IBOutlet weak var alertButton3OrMore: UIButton!
    @IBOutlet weak var alertWithTextField: UIButton!
    @IBOutlet weak var toastButton: UIButton!
    @IBOutlet weak var loadingButton: UIButton!
    @IBOutlet weak var successButton: UIButton!
    @IBOutlet weak var failedButton: UIButton!
    
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
        let foo:PKButton = PKButton(title: "Foo",
                                    action: { (messageLabel, items) -> Bool in
                                                NSLog("Foo is clicked.")
                                                return true
                                    },
                                    fontColor: UIColor(red: 0, green: 0.55, blue: 0.9, alpha: 1.0),
                                    backgroundColor: nil)
        
        PKNotification.alert(
            title: "Notice",
            message: "Foooooooooooooo\nDisplay this default style pop up view.\nBaaaaaar",
            items: [foo],
            cancelButtonTitle: "Cancel",
            tintColor: nil)
    }
    
    @IBAction func alertButton3OrMoreDown(sender: AnyObject) {
        let foo:PKButton = PKButton(title: "Foo",
                                    action: { (messageLabel, items) -> Bool in
                                            NSLog("Foo is clicked.")
                                            return true
                                    },
                                    fontColor: UIColor.purpleColor(),
                                    backgroundColor: nil)
        
        let bar:PKButton = PKButton(title: "Not Dismiss",
                                    action: { (messageLabel, items) -> Bool in
                                            NSLog("Not Dismiss is clicked.")
                                            messageLabel?.text = "not dismiss button is clicked.\nresize message label automatically."
                                            return false
                                    },
                                    fontColor: nil,
                                    backgroundColor: nil)
        
        PKNotification.alert(
            title: "Done",
            message: "Foooooooooooooo\nDisplay this default style pop up view.\nBaaaaaar",
            items: [foo, bar],
            cancelButtonTitle: nil,
            tintColor: UIColor(red: 0.8, green: 0.8, blue: 0.8, alpha: 1.0))
    }
    
    @IBAction func alertWithTextFieldDown(sender: AnyObject) {

        let email:UITextField = UITextField()
        email.placeholder = "email@host.com"
        email.backgroundColor = UIColor(red: 0.95, green: 0.96, blue: 1.0, alpha: 1.0)
        email.textColor = UIColor.darkGrayColor()
        
        
        let passwd:UITextField = UITextField()
        passwd.placeholder = "password"
        passwd.backgroundColor = UIColor(red: 0.95, green: 0.96, blue: 1.0, alpha: 1.0)
        passwd.textColor = UIColor.darkGrayColor()
        
        let foo:PKButton = PKButton(title: "Login",
            action: { (messageLabel, items) -> Bool in
                NSLog("Login is clicked.")
                let tmpEmail: UITextField = items[0] as! UITextField //items index number
                let tmpPassed: UITextField = items[1] as! UITextField //items index number
                NSLog("email = \(tmpEmail.text)")
                NSLog("passwd = \(tmpPassed.text)")
                
                if (tmpEmail.text == "" || tmpPassed.text == ""){
                    messageLabel?.text = "please check email and password again."
                    tmpEmail.backgroundColor = UIColor(red: 0.95, green: 0.8, blue: 0.8, alpha: 1.0)
                    tmpPassed.backgroundColor = UIColor(red: 0.95, green: 0.8, blue: 0.8, alpha: 1.0)
                    return false
                }
                return true
            },
            fontColor: UIColor(red: 0, green: 0.55, blue: 0.9, alpha: 1.0),
            backgroundColor: nil)
        
        
        PKNotification.alert(
            title: "Login",
            message: "Welcome to example.\nThis is a simple login form.",
            items: [email, passwd, foo],
            cancelButtonTitle: "Cancel",
            tintColor: nil)

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
        PKNotification.successBackgroundColor = UIColor(red: 0, green: 0.55, blue: 0.9, alpha: 1.0)
        PKNotification.success(nil)
    }
    
    @IBAction func failedButtonDown(sender: AnyObject) {
        PKNotification.failed("Failed ...")
    }

}

