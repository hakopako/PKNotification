/*********************************************************************
  PKNotification.swift
  PKNotification

  Created by hakopako on 2014/12/24.
  Copyright (c) 2014 hakopako.
  Source:https://github.com/hakopako/PKNotification
    
    Permission is hereby granted, free of charge, to any person obtaining a
    copy of this software and associated documentation files (the
    "Software"), to deal in the Software without restriction, including
    without limitation the rights to use, copy, modify, merge, publish,
    distribute, sublicense, and/or sell copies of the Software, and to
    permit persons to whom the Software is furnished to do so, subject to
    the following conditions:

    The above copyright notice and this permission notice shall be included
    in all copies or substantial portions of the Software.

    THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
    OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
    MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
    IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
    CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
    TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
    SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

*********************************************************************/

import UIKit

enum PKNotifications {
    case Error, Success, Warning, Info
}

enum PKProgressType {
    case Loading, Success, Failed
}

extension String {
    var floatValue: Float {
        return (self as NSString).floatValue
    }
}

typealias PKButtonActionBlock = () -> Void

let kOnVersion:Float = (UIDevice.currentDevice().systemVersion).floatValue

let _PKNotificationSingleton:PKNotificationSingleton = PKNotificationSingleton()
let PKNotification:PKNotificationClass = PKNotificationClass()

// MARK: - @CLASS PKNotificationSingleton
class PKNotificationSingleton  {
    //PKToast custom
    let kToastMargin:CGFloat = 8
    let kToastHeight:CGFloat = 50
    let kToastAlpha:CGFloat = 0.8
    let kToastRadious:CGFloat = 1
    let toastBackgroundColor:UIColor = UIColor.blackColor()
    let toastFontColor:UIColor = UIColor.whiteColor()
    let toastFontStyle:UIFont = UIFont.systemFontOfSize(15)
    
    //PKProgress custom
    let kProgressHeight:CGFloat = 110
    let kProgressWidth:CGFloat = 110
    let kProgressAlpha:CGFloat = 0.6
    let kProgressRadious:CGFloat = 12
    let kProgressLabelHeight:CGFloat = 40
    let progressFontColor:UIColor = UIColor.whiteColor()
    let progressFontStyle:UIFont = UIFont.boldSystemFontOfSize(14)
    
      //--- loading
    let backgroundColorLoading:UIColor = UIColor.blackColor()
    let loadingActiveIndicatorStyle:UIActivityIndicatorViewStyle = UIActivityIndicatorViewStyle.WhiteLarge
    
      //--- success
    let backgroundColorSuccess:UIColor = UIColor.blackColor()
    let successImage:UIImage? = nil //if it's nil, set default image automatically
    
      //--- failed
    let backgroundColorFailed:UIColor = UIColor.blackColor()
    let failedImage:UIImage? = nil //if it's nil, set default image automatically
    
    //PKAlert custom
    let kAlertWidth:CGFloat = 260
    let kAlertMargin:CGFloat = 8
    let alertTitleFontColor:UIColor = UIColor.darkGrayColor()
    let alertTitleFontStyle:UIFont = UIFont.boldSystemFontOfSize(17)
    let alertMessageFontColor:UIColor = UIColor.grayColor()
    let alertMEssageFontStyle:UIFont = UIFont.systemFontOfSize(13)
    let alertButtonFontColor:UIColor = UIColor.grayColor()
    let alertBackgroundColor:UIColor = UIColor.whiteColor()
    let alertCornerRadius:CGFloat = 8
    
    var vcCache:NSCache = NSCache()
    var progressVC:PKNotificationClass.PKProgress? = nil
    var loadingBackgroundView:UIView? = nil
    var alertBackgroundView:UIView? = nil

}

// MARK: - @CLASS PKNotification
class PKNotificationClass: UIViewController {
    
    // MARK: - Lifecycle
    required override init() {
        super.init()
    }

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    required override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "rotated", name: UIDeviceOrientationDidChangeNotification, object: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - Call methods
    func alert(title t:String?, message m:String?, items i:Array<PKButton>?, cancelButtonTitle c:String?, tintColor tint:UIColor?) {
        let bgView:UIView = generateBackground(color: UIColor.clearColor(), uiEnabled: true)
        let bgColoredView:UIView = UIView(frame: self.view.frame)
        bgColoredView.backgroundColor = UIColor.blackColor()
        bgColoredView.alpha = 0.3
        let alertVC:PKAlert = PKAlert(title:t, message:m, items:i, cancelButtonTitle:c, tintColor:tint)
        _PKNotificationSingleton.vcCache.setObject(alertVC, forKey: alertVC)
        
        bgView.addSubview(bgColoredView)
        bgView.addSubview(alertVC.view)
        bgView.alpha = 0
        _PKNotificationSingleton.alertBackgroundView = bgView
        UIApplication.sharedApplication().windows[0].addSubview(_PKNotificationSingleton.alertBackgroundView!)
        
        bgView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.1, 1.1);
        UIView.animateWithDuration(0.1,
            delay: 0,
            options: UIViewAnimationOptions.CurveLinear,
            animations: { () -> Void in
                _PKNotificationSingleton.alertBackgroundView!.alpha = 1
                _PKNotificationSingleton.alertBackgroundView!.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1, 1);
            },
            completion: { (finished:Bool) -> Void in

        })
    }
    
    
    func generatePKButton(title t:String!, action a:PKButtonActionBlock!, fontColor f:UIColor?, backgroundColor b:UIColor?) -> PKButton {
        let button:PKButton = PKButton(title: t, action: a, fontColor: f, backgroundColor: b)
        return button
    }

    func toast(message m:String!) {
        let bgView:UIView = generateBackground(color: UIColor.clearColor(), uiEnabled:false)
        let toastVC:PKToast = PKToast(message:m)
        _PKNotificationSingleton.vcCache.setObject(toastVC, forKey: toastVC)

        bgView.addSubview(toastVC.view)
        bgView.alpha = 0
        UIApplication.sharedApplication().windows[0].addSubview(bgView)

        UIView.animateWithDuration(0.3,
                              delay: 0,
                            options: UIViewAnimationOptions.CurveLinear,
                         animations: { () -> Void in
                                    bgView.alpha = 1
                         },
                         completion: { (finished:Bool) -> Void in
                            UIView.animateWithDuration(0.3,
                                                  delay: 2,
                                                options: UIViewAnimationOptions.CurveLinear,
                                             animations: { () -> Void in
                                                    bgView.alpha = 0
                                             },
                                             completion: { (finished:Bool) -> Void in
                                                    bgView.removeFromSuperview()
                                                    _PKNotificationSingleton.vcCache.removeObjectForKey(toastVC)
                                             })
                        })
        
    }
    
    func loading(flag:Bool) {
        let isLoading:Bool = !(_PKNotificationSingleton.progressVC == nil)
        if(flag && !isLoading){
            let bgView:UIView = generateBackground(color: UIColor.clearColor(), uiEnabled:true)
            let progressVC:PKProgress = PKProgress(PKProgressType.Loading, nil)
            _PKNotificationSingleton.progressVC = progressVC
            
            bgView.addSubview(_PKNotificationSingleton.progressVC!.view)
            _PKNotificationSingleton.loadingBackgroundView = bgView
            UIApplication.sharedApplication().windows[0].addSubview(_PKNotificationSingleton.loadingBackgroundView!)
        } else if(!flag && isLoading) {
            _PKNotificationSingleton.loadingBackgroundView?.removeFromSuperview()
            _PKNotificationSingleton.progressVC = nil
            _PKNotificationSingleton.loadingBackgroundView = nil
        }
    }
    
    func success(message:String?) {
//        let isShowing:Bool = !(_PKNotificationSingleton.progressVC == nil)
//        if(!isShowing){
            let bgView:UIView = generateBackground(color: UIColor.clearColor(), uiEnabled:false)
            let progressVC:PKProgress = PKProgress(PKProgressType.Success, message)
            _PKNotificationSingleton.progressVC = progressVC
            
            bgView.addSubview(_PKNotificationSingleton.progressVC!.view)
            bgView.alpha = 0
            UIApplication.sharedApplication().windows[0].addSubview(bgView)
            
            bgView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.1, 1.1);
            UIView.animateWithDuration(0.1,
                delay: 0,
                options: UIViewAnimationOptions.CurveLinear,
                animations: { () -> Void in
                    bgView.alpha = 1
                    bgView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1, 1);
                },
                completion: { (finished:Bool) -> Void in
                    UIView.animateWithDuration(0.1,
                        delay: 2,
                        options: UIViewAnimationOptions.CurveLinear,
                        animations: { () -> Void in
                            bgView.alpha = 0
                        },
                        completion: { (finished:Bool) -> Void in
                            bgView.removeFromSuperview()
                            _PKNotificationSingleton.progressVC = nil
                    })
            })
//        }
    }
    
    func failed(message:String?) {
//        let isShowing:Bool = !(_PKNotificationSingleton.progressVC == nil)
//        if(!isShowing){
            let bgView:UIView = generateBackground(color: UIColor.clearColor(), uiEnabled:false)
            let progressVC:PKProgress = PKProgress(PKProgressType.Failed, message)
            _PKNotificationSingleton.progressVC = progressVC
            
            bgView.addSubview(_PKNotificationSingleton.progressVC!.view)
            bgView.alpha = 0
            UIApplication.sharedApplication().windows[0].addSubview(bgView)

            bgView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.1, 1.1);
            UIView.animateWithDuration(0.1,
                delay: 0,
                options: UIViewAnimationOptions.CurveLinear,
                animations: { () -> Void in
                    bgView.alpha = 1
                    bgView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1, 1);
                },
                completion: { (finished:Bool) -> Void in
                    UIView.animateWithDuration(0.1,
                        delay: 2,
                        options: UIViewAnimationOptions.CurveLinear,
                        animations: { () -> Void in
                            bgView.alpha = 0
                        },
                        completion: { (finished:Bool) -> Void in
                            bgView.removeFromSuperview()
                            _PKNotificationSingleton.progressVC = nil
                    })
            })
//        }
    }
    
    // MARK: - Common methods
    func generateBackground(#color:UIColor, uiEnabled:Bool) -> UIView {
        var backgroundView = UIView()
        backgroundView.frame = UIScreen.mainScreen().bounds
        backgroundView.backgroundColor = color
        backgroundView.userInteractionEnabled = uiEnabled
        return backgroundView
    }
    
    func rotated()
    {
        //TODO: Implement
        if(UIDeviceOrientationIsLandscape(UIDevice.currentDevice().orientation))
        {
            //println("landscape")
        }
        
        if(UIDeviceOrientationIsPortrait(UIDevice.currentDevice().orientation))
        {
            //println("portraight")
        }
        
    }

    // MARK: - @CLASS PKAlert
    class PKAlert: UIViewController {
        // MARK: - Lifecycle
        init(title t:String?, message m:String?, items i:Array<PKButton>?, cancelButtonTitle c:String?, tintColor tint:UIColor?) {
            /* initialize alert parts, resize them and set colors */
            super.init()
            let tintColor:UIColor! = (tint == nil) ? _PKNotificationSingleton.alertButtonFontColor : tint
            
            let titleLabel:UILabel? = (t == nil) ? nil : UILabel(frame: CGRectMake(0, 0, _PKNotificationSingleton.kAlertWidth - _PKNotificationSingleton.kAlertMargin*2, 40))
            titleLabel?.text = t
            titleLabel?.textColor = _PKNotificationSingleton.alertTitleFontColor
            titleLabel?.font = _PKNotificationSingleton.alertTitleFontStyle
            titleLabel?.textAlignment = NSTextAlignment.Center
            
            let messageLabelWidth:CGFloat = _PKNotificationSingleton.kAlertWidth - _PKNotificationSingleton.kAlertMargin*2
            let messageLabel:UILabel? = (m == nil) ? nil : UILabel(frame: CGRectMake(0, 0, messageLabelWidth, 40))
            if(messageLabel != nil){
                messageLabel!.text = m
                messageLabel!.textColor = _PKNotificationSingleton.alertMessageFontColor
                messageLabel!.font = _PKNotificationSingleton.alertMEssageFontStyle
                messageLabel!.textAlignment = NSTextAlignment.Center
                messageLabel!.numberOfLines = 0
                messageLabel!.sizeToFit()
                messageLabel!.center = CGPointMake(messageLabelWidth/2, messageLabel!.frame.height/2)
            }

            let items:Array<PKButton>? = (i == nil) ? nil : i!.map({(b:PKButton) -> PKButton in
                b.frame = CGRectMake(0, 0, _PKNotificationSingleton.kAlertWidth, 44)
                
                //TODO: Precise color choise
                let titleColor:UIColor? = (b.titleLabel?.textColor == UIColor.whiteColor()) ? nil : b.titleLabel?.textColor

                b.setTitleColor((titleColor == nil) ? tintColor : titleColor, forState: UIControlState.Normal)
                b.backgroundColor = (b.backgroundColor == nil) ? _PKNotificationSingleton.alertBackgroundColor : b.backgroundColor
                b.addTarget(self, action:"buttonDown:", forControlEvents: UIControlEvents.TouchUpInside)
                return b
            })

            let cancelButtonTitle:String! = (c == nil) ? "Dissmiss" : c
            let cancelButton:PKButton! = PKButton(title: cancelButtonTitle!, action: {() -> Void in}, fontColor: tintColor, backgroundColor: _PKNotificationSingleton.alertBackgroundColor)
            cancelButton.frame = CGRectMake(0, 0, _PKNotificationSingleton.kAlertWidth, 44)
            cancelButton.addTarget(self, action:"buttonDown:", forControlEvents: UIControlEvents.TouchUpInside)
            
            /* put parts on an alertview and add it as subview on self.view */
            assembleDefaultStyle(titleLabel, messageLabel, items, cancelButton)
        }
       
        required init(coder aDecoder: NSCoder) {
            super.init(coder: aDecoder)
        }
        
        required override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
            super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
            //NSLog("########### \(NSStringFromClass(self.dynamicType)) is initialized. ###########")
        }
        
        override func viewDidLoad() {
            super.viewDidLoad()
        }
        
        override func didReceiveMemoryWarning() {
            super.didReceiveMemoryWarning()
        }
        
        deinit {
            //NSLog("########### \(NSStringFromClass(self.dynamicType)) is deinitialized. ###########")
        }
        
        // MARK: - UI
        func assembleDefaultStyle(titleLabel:UILabel?, _ messageLabel:UILabel?, _ items:Array<PKButton>?, _ cancelButton:PKButton!) -> Void {
            /* set layout and adjust button shape */
            let margin:CGFloat = _PKNotificationSingleton.kAlertMargin
            let lineColor:UIColor = UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1.0)
            let alertView:UIView = UIView(frame: CGRectMake(0, 0, 100, 100))
            let titlePosY:CGFloat = margin
            let messagePosY:CGFloat = (titleLabel == nil) ? titlePosY + margin*2 : titlePosY + titleLabel!.frame.height + margin
            var buttonPosY:CGFloat = (messageLabel == nil) ? messagePosY + margin*2 : messagePosY + messageLabel!.frame.height + margin*2
            titleLabel?.frame.offset(dx:_PKNotificationSingleton.kAlertMargin , dy: titlePosY)
            messageLabel?.frame.offset(dx:_PKNotificationSingleton.kAlertMargin , dy: messagePosY)
            
            if(items?.count == 1) { //total button count is 2
                /* cancelbutton resize and adjust the shape */
                cancelButton.frame.size = CGSizeMake(_PKNotificationSingleton.kAlertWidth/2+1, cancelButton.frame.height)
                let rectCancelButton:CGRect = cancelButton.bounds
                let rectCancelButtonMask:CGRect = CGRectMake(1, 0, rectCancelButton.width-2, rectCancelButton.height-1)
                
                let cancelMaskPath:UIBezierPath = UIBezierPath(roundedRect: rectCancelButtonMask, byRoundingCorners: UIRectCorner.BottomLeft, cornerRadii: CGSizeMake(_PKNotificationSingleton.alertCornerRadius, _PKNotificationSingleton.alertCornerRadius))
                let cancelMaskLayer:CAShapeLayer = CAShapeLayer()
                cancelMaskLayer.frame = cancelButton.bounds
                cancelMaskLayer.path = cancelMaskPath.CGPath
                cancelButton.layer.mask = cancelMaskLayer
                cancelButton.layer.borderWidth = 1.0
                cancelButton.layer.borderColor = lineColor.CGColor
                
                /* the other button resize and adjust the shape */
                let button = items![0]
                button.frame = CGRectMake(_PKNotificationSingleton.kAlertWidth/2 , buttonPosY, _PKNotificationSingleton.kAlertWidth/2, cancelButton.frame.height)
                let rectButton:CGRect = button.bounds
                let rectButtonMask:CGRect = CGRectMake(0, 0, rectButton.width-1, rectButton.height-1)
                
                let maskPath:UIBezierPath = UIBezierPath(roundedRect: rectButtonMask, byRoundingCorners: UIRectCorner.BottomRight, cornerRadii: CGSizeMake(_PKNotificationSingleton.alertCornerRadius, _PKNotificationSingleton.alertCornerRadius))
                let maskLayer:CAShapeLayer = CAShapeLayer()
                maskLayer.frame = button.bounds
                maskLayer.path = maskPath.CGPath
                button.layer.mask = maskLayer
                button.layer.borderWidth = 1.0
                button.layer.borderColor = lineColor.CGColor
                
                alertView.addSubview(button)
                
                
            } else { //total button count is 1, 3 or more
                if(items != nil){
                    for button:PKButton in items! {
                        button.frame.offset(dx: 0, dy: buttonPosY)
                        let rectButton:CGRect = button.bounds
                        let rectButtonMask:CGRect = CGRectMake(1, 0, rectButton.width-2, rectButton.height-1)
                        
                        let maskPath:UIBezierPath = UIBezierPath(rect:rectButtonMask)
                        let maskLayer:CAShapeLayer = CAShapeLayer()
                        maskLayer.frame = button.bounds
                        maskLayer.path = maskPath.CGPath
                        button.layer.mask = maskLayer
                        button.layer.borderWidth = 1.0
                        button.layer.borderColor = lineColor.CGColor
                        
                        buttonPosY += button.frame.height
                        alertView.addSubview(button)
                    }
                }
                
                let rectCancelButton:CGRect = cancelButton.bounds
                let rectCancelButtonMask:CGRect = CGRectMake(1, 0, rectCancelButton.width-2, rectCancelButton.height-1)
                
                let maskPath:UIBezierPath = UIBezierPath(roundedRect: rectCancelButtonMask, byRoundingCorners: UIRectCorner.BottomLeft | UIRectCorner.BottomRight, cornerRadii: CGSizeMake(_PKNotificationSingleton.alertCornerRadius, _PKNotificationSingleton.alertCornerRadius))
                let maskLayer:CAShapeLayer = CAShapeLayer()
                maskLayer.frame = cancelButton.bounds
                maskLayer.path = maskPath.CGPath
                cancelButton.layer.mask = maskLayer
                
                cancelButton.layer.borderWidth = 1.0
                cancelButton.layer.borderColor = lineColor.CGColor
            }
            
            cancelButton.frame.offset(dx: 0, dy: buttonPosY)
            
            let kAlertHeight:CGFloat = cancelButton.frame.origin.y + cancelButton.frame.height
            alertView.frame.size = CGSizeMake(_PKNotificationSingleton.kAlertWidth, kAlertHeight)
            alertView.backgroundColor = _PKNotificationSingleton.alertBackgroundColor
            alertView.layer.cornerRadius = _PKNotificationSingleton.alertCornerRadius
            alertView.center = self.view.center
            if(titleLabel != nil){ alertView.addSubview(titleLabel!)}
            if(messageLabel != nil){ alertView.addSubview(messageLabel!)}
            alertView.addSubview(cancelButton)
            self.view.addSubview(alertView)
        }

        // MARK: - button action
        func buttonDown(sender: PKButton!) -> Void {
            sender.actionBlock()
            
            //Dissmiss alert
            UIView.animateWithDuration(0.1,
                delay: 0,
                options: UIViewAnimationOptions.CurveLinear,
                animations: { () -> Void in
                    _PKNotificationSingleton.alertBackgroundView!.alpha = 0
                },
                completion: { (finished:Bool) -> Void in
                    _PKNotificationSingleton.alertBackgroundView!.removeFromSuperview()
                    _PKNotificationSingleton.vcCache.removeObjectForKey(self)
            })
        }
    }
    
    // MARK: - @CLASS PKButton
    class PKButton: UIButton {
        var actionBlock:PKButtonActionBlock = {() -> Void in }
        
        init(title t:String, action a:PKButtonActionBlock, fontColor f:UIColor?, backgroundColor b:UIColor?) {
            super.init()
            actionBlock = a
            self.setTitle(t, forState: UIControlState.Normal)
            self.setTitleColor(f, forState: UIControlState.Normal)
            self.backgroundColor = b
            self.titleLabel?.textAlignment = NSTextAlignment.Center
        }
        
        required init(coder aDecoder: NSCoder) {
            super.init(coder: aDecoder)
        }
        
        override init(frame aFrame: CGRect) {
            super.init(frame: aFrame)
        }
        
    }

    // MARK: - @CLASS PKToast
    class PKToast: UIViewController {
        let rectBounds:CGRect = UIScreen.mainScreen().bounds
        
        //toast Rect
        var posX:CGFloat = 0
        var posY:CGFloat = 0
        var width:CGFloat = 0
        var height:CGFloat = 0
        
        // MARK: - Lifecycle
        init(message m:String) {
            super.init()
            generate(message: m)
        }
        
        required override init() {
            super.init()
        }
        
        required init(coder aDecoder: NSCoder) {
            super.init(coder: aDecoder)
        }
        
        required override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
            super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
            //NSLog("########### \(NSStringFromClass(self.dynamicType)) is initialized. ###########")
        }

        override func viewDidLoad() {
            super.viewDidLoad()
        }
        
        override func didReceiveMemoryWarning() {
            super.didReceiveMemoryWarning()
        }
        
        deinit {
            //NSLog("########### \(NSStringFromClass(self.dynamicType)) is deinitialized. ###########")
        }
        
        // MARK: - generate
        func generate(message m:String) {
            let toastView:UIView = UIView()
            let messageLabel:UILabel = UILabel()
            posX = _PKNotificationSingleton.kToastMargin
            posY = rectBounds.size.height - _PKNotificationSingleton.kToastMargin - _PKNotificationSingleton.kToastHeight
            width = rectBounds.size.width - _PKNotificationSingleton.kToastMargin * 2
            height = _PKNotificationSingleton.kToastHeight
            let rectToast:CGRect = CGRectMake(posX, posY, width, height)
            toastView.frame = rectToast
            messageLabel.frame = CGRectMake(0, 0, rectToast.width, rectToast.height)
            
            toastView.backgroundColor = _PKNotificationSingleton.toastBackgroundColor
            toastView.alpha = _PKNotificationSingleton.kToastAlpha
            toastView.layer.cornerRadius = _PKNotificationSingleton.kToastRadious
            messageLabel.font = _PKNotificationSingleton.toastFontStyle
            messageLabel.textColor = _PKNotificationSingleton.toastFontColor
            messageLabel.textAlignment = NSTextAlignment.Center
            messageLabel.text = m
            toastView.addSubview(messageLabel)
            self.view.addSubview( (kOnVersion < 8.0) ? rotate(toastView) : toastView )
        }
        
        /**
         * For iOS7
         */
        func rotate(v:UIView) -> UIView {
            switch(UIApplication.sharedApplication().statusBarOrientation){
                case .Portrait: break
                case .PortraitUpsideDown:
                    v.layer.transform = CATransform3DMakeRotation(CGFloat(M_PI), 0.0, 0.0, 1.0)
                    posX = _PKNotificationSingleton.kToastMargin
                    posY = _PKNotificationSingleton.kToastMargin + _PKNotificationSingleton.kToastHeight
                    width = rectBounds.size.width - _PKNotificationSingleton.kToastMargin * 2
                    height = _PKNotificationSingleton.kToastHeight
                    v.frame = CGRectMake(posX, posY, width, height)
                    break
                case .LandscapeLeft:
                    v.layer.transform = CATransform3DMakeRotation(90.0 / 180.0 * (-1) * CGFloat(M_PI), 0.0, 0.0, 1.0)
                    posX = rectBounds.size.width - _PKNotificationSingleton.kToastMargin - _PKNotificationSingleton.kToastHeight
                    posY = _PKNotificationSingleton.kToastMargin
                    width = _PKNotificationSingleton.kToastHeight
                    height = rectBounds.size.height - _PKNotificationSingleton.kToastMargin * 2
                    v.frame = CGRectMake(posX, posY, width, height)
                    break
                case .LandscapeRight:
                    v.layer.transform = CATransform3DMakeRotation(90.0 / 180.0 * CGFloat(M_PI), 0.0, 0.0, 1.0)
                    posX = _PKNotificationSingleton.kToastMargin
                    posY = _PKNotificationSingleton.kToastMargin
                    width = _PKNotificationSingleton.kToastHeight
                    height = rectBounds.size.height - _PKNotificationSingleton.kToastMargin * 2
                    v.frame = CGRectMake(posX, posY, width, height)
                    break
                case .Unknown: break
            }
            
            return v
        }
    }

    // MARK: - @CLASS PKProgress
    class PKProgress: UIViewController {
        
        let kMargin:CGFloat = 30
        let rectBounds:CGRect = UIScreen.mainScreen().bounds
        
        // MARK: - Lifecycle
        init(_ type:PKProgressType, _ m:String?) {
            super.init()
            switch(type){
                case .Loading:
                    generateLoading()
                    break
                case .Success:
                    generateSuccess(m)
                    break
                case .Failed:
                    generateFailed(m)
                    break
            }
        }
        
        required override init() {
            super.init()
        }
        
        required init(coder aDecoder: NSCoder) {
            super.init(coder: aDecoder)
        }
        
        required override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
            super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
            //NSLog("########### \(NSStringFromClass(self.dynamicType)) is initialized. ###########")
        }
        
        override func viewDidLoad() {
            super.viewDidLoad()
        }
        
        override func didReceiveMemoryWarning() {
            super.didReceiveMemoryWarning()
        }
        
        deinit {
            //NSLog("########### \(NSStringFromClass(self.dynamicType)) is deinitialized. ###########")
        }
        
        // MARK: - generate
        func generateLoading(){
            let loadingView:UIView = UIView(frame: CGRectMake((rectBounds.width - _PKNotificationSingleton.kProgressWidth)/2, (rectBounds.height - _PKNotificationSingleton.kProgressHeight)/2, _PKNotificationSingleton.kProgressWidth, _PKNotificationSingleton.kProgressHeight))
            var ai:UIActivityIndicatorView = UIActivityIndicatorView() as UIActivityIndicatorView
            ai.center = loadingView.center
            ai.activityIndicatorViewStyle = _PKNotificationSingleton.loadingActiveIndicatorStyle
            ai.hidesWhenStopped = true
            ai.startAnimating()
            loadingView.backgroundColor = _PKNotificationSingleton.backgroundColorLoading
            loadingView.alpha = _PKNotificationSingleton.kProgressAlpha
            loadingView.layer.cornerRadius = _PKNotificationSingleton.kProgressRadious
            self.view.addSubview((kOnVersion < 8.0) ? rotate(loadingView) : loadingView)
            self.view.addSubview((kOnVersion < 8.0) ? rotate(ai) : ai)
        }
        
        func generateSuccess(m:String?){
            let successView:UIView = UIView(frame: CGRectMake((rectBounds.width - _PKNotificationSingleton.kProgressWidth)/2, (rectBounds.height - _PKNotificationSingleton.kProgressHeight)/2, _PKNotificationSingleton.kProgressWidth, _PKNotificationSingleton.kProgressHeight))
            let imageSize:CGSize = CGSize(width: successView.frame.width - kMargin*2, height: successView.frame.height - kMargin*2)
            let imagePosY:CGFloat = (rectBounds.height - _PKNotificationSingleton.kProgressHeight + imageSize.height)/2
            let imageView:UIImageView = UIImageView(frame: CGRectMake((rectBounds.width - _PKNotificationSingleton.kProgressWidth)/2 + kMargin, (m == nil) ? imagePosY : imagePosY - 5 , imageSize.width, imageSize.height))
            let messageLabel:UILabel = UILabel()
            imageView.image = (_PKNotificationSingleton.successImage == nil ? generateImageDefaultSuccess() : _PKNotificationSingleton.successImage)
            imageView.contentMode = UIViewContentMode.ScaleAspectFit
            successView.backgroundColor = _PKNotificationSingleton.backgroundColorSuccess
            successView.alpha = _PKNotificationSingleton.kProgressAlpha
            successView.layer.cornerRadius = _PKNotificationSingleton.kProgressRadious
            messageLabel.frame = CGRectMake(0, successView.frame.height-_PKNotificationSingleton.kProgressLabelHeight, successView.frame.width, _PKNotificationSingleton.kProgressLabelHeight)
            messageLabel.font = _PKNotificationSingleton.progressFontStyle
            messageLabel.textColor = _PKNotificationSingleton.progressFontColor
            messageLabel.textAlignment = NSTextAlignment.Center
            messageLabel.text = m
            successView.addSubview(messageLabel)
            self.view.addSubview((kOnVersion < 8.0) ? rotate(successView) : successView)
            self.view.addSubview((kOnVersion < 8.0) ? rotate(imageView) : imageView)
        }
        
        func generateFailed(m:String?){
            let failedView:UIView = UIView(frame: CGRectMake((rectBounds.width - _PKNotificationSingleton.kProgressWidth)/2, (rectBounds.height - _PKNotificationSingleton.kProgressHeight)/2, _PKNotificationSingleton.kProgressWidth, _PKNotificationSingleton.kProgressHeight))
            let imageSize:CGSize = CGSize(width: failedView.frame.width - kMargin*2, height: failedView.frame.height - kMargin*2)
            let imagePosY:CGFloat = (rectBounds.height - _PKNotificationSingleton.kProgressHeight + imageSize.height)/2
            let imageView:UIImageView = UIImageView(frame: CGRectMake((rectBounds.width - _PKNotificationSingleton.kProgressWidth)/2 + kMargin, (m == nil) ? imagePosY : imagePosY - 5, imageSize.width, imageSize.height))
            let messageLabel:UILabel = UILabel()
            imageView.image = (_PKNotificationSingleton.failedImage == nil ? generateImageDefaultFailed() : _PKNotificationSingleton.failedImage)
            failedView.backgroundColor = _PKNotificationSingleton.backgroundColorFailed
            failedView.alpha = _PKNotificationSingleton.kProgressAlpha
            failedView.layer.cornerRadius = _PKNotificationSingleton.kProgressRadious
            messageLabel.frame = CGRectMake(0, failedView.frame.height-_PKNotificationSingleton.kProgressLabelHeight, failedView.frame.width, _PKNotificationSingleton.kProgressLabelHeight)
            messageLabel.font = _PKNotificationSingleton.progressFontStyle
            messageLabel.textColor = _PKNotificationSingleton.progressFontColor
            messageLabel.textAlignment = NSTextAlignment.Center
            messageLabel.text = m
            failedView.addSubview(messageLabel)
            self.view.addSubview((kOnVersion < 8.0) ? rotate(failedView) : failedView)
            self.view.addSubview((kOnVersion < 8.0) ? rotate(imageView) : imageView)
        }
        
        
        /**
        * For iOS7
        */
        func rotate(v:UIView) -> UIView {
            switch(UIApplication.sharedApplication().statusBarOrientation){
            case .Portrait: break
            case .PortraitUpsideDown:
                v.layer.transform = CATransform3DMakeRotation(CGFloat(M_PI), 0.0, 0.0, 1.0)
                break
            case .LandscapeLeft:
                v.layer.transform = CATransform3DMakeRotation(90.0 / 180.0 * (-1) * CGFloat(M_PI), 0.0, 0.0, 1.0)
                break
            case .LandscapeRight:
                v.layer.transform = CATransform3DMakeRotation(90.0 / 180.0 * CGFloat(M_PI), 0.0, 0.0, 1.0)
                break
            case .Unknown: break
            }
            
            return v
        }
        
        func generateImageDefaultSuccess() -> UIImage {
            let base64Str:String = "iVBORw0KGgoAAAANSUhEUgAAAGQAAABkCAYAAABw4pVUAAAABmJLR0QA/wD/AP+gvaeTAAAACXBIWXMAAAsTAAALEwEAmpwYAAAAB3RJTUUH3gwcEAgrQ5wC4QAAAXdJREFUeNrt2DFKA0EYhuHRM3gSIb2F2KX0JLYpLHMW72IhWIn3CAHhs1khlUYx8Yv7vJAuxc7/7DDMjiFJkiRJkiRJkiRJkiRJ2i3JVZJrk+jAWCZ5TPKc5NZEOjA+glKEAaUQA0ohxi7KXgf9ubH+HGOMcT/GuNzj79sxxpup/f3OyPS/panBgAEDBgwYMAQDhmDAEAwY+iWMRZLtnhjbJAtTszNgwIABA4YDXLPYGUnOklzA6MG4SfJwCg8+F4ynnQUsYHRg7B5+y8Ln/b8H+CcYlW/XXHdG5cL+/T0jycV0gNcvcDaXvlNY6Oxu4NOCt40Lnu0NfFp41Vs4+29TTQPwobBoEDCKBgKj6KCHUXTQwygaFIyigcEoQoFRhAKjCAVGEQqMIhQYXSiv0w9GEQqME0OBUYQCowgFxoFRXr6B8QLj8CirJJs9MDZJViZ2HJT1FyibJGuT6kCBUYQCowgFRhHKXZI7k5AkSZIkSZIkSZKO0Ds6sLt1lfeMOAAAAABJRU5ErkJggg=="
            let imgData:NSData = NSData(base64EncodedString: base64Str, options: NSDataBase64DecodingOptions.IgnoreUnknownCharacters)!
            let image:UIImage = UIImage(data: imgData)!
            
            return image
        }
        
        func generateImageDefaultFailed() -> UIImage {
            let base64Str:String = "iVBORw0KGgoAAAANSUhEUgAAAGQAAABkCAYAAABw4pVUAAAABmJLR0QA/wD/AP+gvaeTAAAACXBIWXMAAAsTAAALEwEAmpwYAAAAB3RJTUUH3gwcEAgdjCaXeAAAAz9JREFUeNrt3D1sTWEcx/Hv4yWhioi2BFUhFjGIKvHS7h26t43UwMruZZBUJAYGWxODQbCZxCzxEonBIBYhWvHSllQpkVA/yzMI9173ntuee87p75Pc5aTPef4vec55+gwHzMzMzMzMzMzMzMzMzMzMzBYCSc2SBiTdljQdf7fjteYC5rtYUpekEUkT8TcSry1udHAD+r+BAjWjq4p8uxoV3LCqN1yAZgzVkO9QFldGYVZKlStjTlZKSPLOAL4kzG1lCGEmb+8M4GfC4UtCCLO1DFiUYJK+OvLry+EC2Z3m2CQNOVxHgIdz2JBjaY5N8siaBlYlDPBzCGF1zh5ZE0BrwuGTIYS2+V4hNo+SNOReHfPdy2GNbqU5NklDrtUR4LUcNuRKmmO97c37tjcWdDBBcIN5a0bMdxbYm2Do3lqb4aOTohyd1HiE4sPFlIP08XtWjt/NzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMbG6ErAYmKQBNwFpgA7AZ6AC2AO3xWguwJv7dIuAX8A2YAj4Ab4HXwCtgFBiL1z4C30IIckPKF78N2AEcBHqBAylM/QC4A9wHngETjW5SaGATWoH9QD+QpY8L3ABuAg9DCJOFfj5Kapd0XNK48mE8xttepCY0S+qXNKZ8G4t5NOe1EZskXVIxXZK0KRfvEEkdwHmSfcLpT+PAc+Bl3CG9Ad4Dk3EXNQ18Bb4DPwDFfJYCy4AVwOq4C2sF1gMb405tK7AdWFdnjNeBUyGE0cw1RNIa4CxwIsHwF8Aj4DHwBHiaxgs1bix2AruAPcA+YFuCW10GzoYQprLyeOqvccm/k3Q1foOqI2OP2o4Y19UYZy36Gx18m6S7VQY7KumipJ6cvQt7YtyjVeZ5V1JbIwLtrjLA65J6C7Jj7I35VKM7zcCO/ieYT5LOFWr//u//U+dinpUcTSOY0xUCmJF0RlLTQjgIlNQU852pUJPT8xnAyQoTX5bUshBPaCW1xPzLOTkfkx4pM9mjVJ+X2W5Md6xHKUfmcqLOMpNccBtK1utCmXp1zsXNl5e48aykQZe+Yt0GY53+trzeGw+XOAE95JJXVbtDJU62h10ZMzMzMzPLkt8vA/1E0dnMwQAAAABJRU5ErkJggg=="
            let imgData:NSData = NSData(base64EncodedString: base64Str, options: NSDataBase64DecodingOptions.IgnoreUnknownCharacters)!
            let image:UIImage = UIImage(data: imgData)!
            
            return image
        }

    }
}


