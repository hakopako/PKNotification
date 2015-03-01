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

typealias PKButtonActionBlock = (messageLabel:UILabel?, items:Array<AnyObject>) -> Bool
let _PKNotificationSingleton:PKNotificationSingleton = PKNotificationSingleton()
let PKNotification:PKNotificationClass = PKNotificationClass()

// MARK: - @CLASS PKNotificationSingleton
class PKNotificationSingleton  {
    var vcCollection:Array<UIViewController> = Array()
    var isLoading:Bool = false
}

// MARK: - @CLASS PKNotification
class PKNotificationClass: UIViewController {
    
    enum PKProgressType {
        case Loading, Success, Failed
    }
    
    let onVersion:Float = (UIDevice.currentDevice().systemVersion).floatValue
    let defaultSuccessImage:UIImage = Images().success()
    let defaultFailedImage:UIImage = Images().failed()
    
    
    //PKToast custom
    var toastMargin:CGFloat = 8
    var toastHeight:CGFloat = 50
    var toastAlpha:CGFloat = 0.8
    var toastRadious:CGFloat = 1
    var toastBackgroundColor:UIColor = UIColor.blackColor()
    var toastFontColor:UIColor = UIColor.whiteColor()
    var toastFontStyle:UIFont = UIFont.systemFontOfSize(15)
    
    //PKProgress custom
    var progressHeight:CGFloat = 110
    var progressWidth:CGFloat = 110
    var progressAlpha:CGFloat = 0.6
    var progressRadious:CGFloat = 12
    var progressLabelHeight:CGFloat = 40
    var progressFontColor:UIColor = UIColor.whiteColor()
    var progressFontStyle:UIFont = UIFont.boldSystemFontOfSize(14)
    
    //--- loading
    var loadingBackgroundColor:UIColor = UIColor.blackColor()
    var loadingActiveIndicatorStyle:UIActivityIndicatorViewStyle = UIActivityIndicatorViewStyle.WhiteLarge
    
    //--- success
    var successBackgroundColor:UIColor = UIColor.blackColor()
    var successImage:UIImage? = nil //if it's nil, set default image automatically
    
    //--- failed
    var failedBackgroundColor:UIColor = UIColor.blackColor()
    var failedImage:UIImage? = nil //if it's nil, set default image automatically
    
    //PKAlert custom
    var alertWidth:CGFloat = 260
    var alertMargin:CGFloat = 8
    var alertTitleFontColor:UIColor = UIColor.darkGrayColor()
    var alertTitleFontStyle:UIFont = UIFont.boldSystemFontOfSize(17)
    var alertMessageFontColor:UIColor = UIColor.grayColor()
    var alertMEssageFontStyle:UIFont = UIFont.systemFontOfSize(13)
    var alertButtonFontColor:UIColor = UIColor.grayColor()
    var alertBackgroundColor:UIColor = UIColor.whiteColor()
    var alertCornerRadius:CGFloat = 8
    
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
    func alert(title t:String?, message m:String?, items i:Array<AnyObject>?, cancelButtonTitle c:String?, tintColor tint:UIColor?) {
        let alertVC:PKAlert = PKAlert(title:t, message:m, items:i, cancelButtonTitle:c, tintColor:tint, parent: self)
        alertVC.view.alpha = 0
        _PKNotificationSingleton.vcCollection.append(alertVC)
        alertVC.view.center = UIApplication.sharedApplication().windows[0].center
        UIApplication.sharedApplication().windows[0].addSubview(alertVC.view)
        
        alertVC.view.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.1, 1.1);
        UIView.animateWithDuration(0.1,
            delay: 0,
            options: UIViewAnimationOptions.CurveLinear,
            animations: { () -> Void in
                alertVC.view.alpha = 1
                alertVC.view.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1, 1);
            },
            completion: { (finished:Bool) -> Void in

        })
    }

    func toast(message:String!) {
        let toastVC:PKToast = PKToast(message: message, parent: self)
        _PKNotificationSingleton.vcCollection.append(toastVC)

        toastVC.view.alpha = 0
        UIApplication.sharedApplication().windows[0].addSubview(toastVC.view)

        UIView.animateWithDuration(0.3,
                              delay: 0,
                            options: UIViewAnimationOptions.CurveLinear,
                         animations: { () -> Void in
                                    toastVC.view.alpha = 1
                         },
                         completion: { (finished:Bool) -> Void in
                            UIView.animateWithDuration(0.3,
                                                  delay: 2,
                                                options: UIViewAnimationOptions.CurveLinear,
                                             animations: { () -> Void in
                                                    toastVC.view.alpha = 0
                                             },
                                             completion: { (finished:Bool) -> Void in
                                                self.view.removeFromSuperview()
                                                self.removeVCCollectionByObject(toastVC)
                                             })
                        })
    }
    
    func loading(flag:Bool) {
    
        if(flag && !_PKNotificationSingleton.isLoading){
            let progressVC:PKProgress = PKProgress(PKProgressType.Loading, nil, self)
            _PKNotificationSingleton.vcCollection.append(progressVC)
            UIApplication.sharedApplication().windows[0].addSubview(progressVC.view)
            _PKNotificationSingleton.isLoading = true
        } else if(!flag && _PKNotificationSingleton.isLoading) {
            var cnt:Int = 0
            for anyObject in _PKNotificationSingleton.vcCollection {
                if (anyObject.isKindOfClass(PKProgress)) {
                    if (anyObject as PKProgress).type == PKProgressType.Loading {
                        (anyObject as PKProgress).view.removeFromSuperview()
                        _PKNotificationSingleton.vcCollection.removeAtIndex(cnt)
                        _PKNotificationSingleton.isLoading = false
                    }
                }
            }
        }

    }
    
    func success(message:String?) {
        let progressVC:PKProgress = PKProgress(PKProgressType.Success, message, self)
        _PKNotificationSingleton.vcCollection.append(progressVC)
        progressVC.view.alpha = 0
        UIApplication.sharedApplication().windows[0].addSubview(progressVC.view)
        
        progressVC.view.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.1, 1.1);
        UIView.animateWithDuration(0.1,
            delay: 0,
            options: UIViewAnimationOptions.CurveLinear,
            animations: { () -> Void in
                progressVC.view.alpha = 1
                progressVC.view.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1, 1);
            },
            completion: { (finished:Bool) -> Void in
                UIView.animateWithDuration(0.1,
                    delay: 2,
                    options: UIViewAnimationOptions.CurveLinear,
                    animations: { () -> Void in
                        progressVC.view.alpha = 0
                    },
                    completion: { (finished:Bool) -> Void in
                        progressVC.view.removeFromSuperview()
                        self.removeVCCollectionByObject(progressVC)
                })
        })

    }
    
    func failed(message:String?) {
        let progressVC:PKProgress = PKProgress(PKProgressType.Failed, message, self)
        _PKNotificationSingleton.vcCollection.append(progressVC)
        progressVC.view.alpha = 0
        UIApplication.sharedApplication().windows[0].addSubview(progressVC.view)

        progressVC.view.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.1, 1.1);
        UIView.animateWithDuration(0.1,
            delay: 0,
            options: UIViewAnimationOptions.CurveLinear,
            animations: { () -> Void in
                progressVC.view.alpha = 1
                progressVC.view.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1, 1);
            },
            completion: { (finished:Bool) -> Void in
                UIView.animateWithDuration(0.1,
                    delay: 2,
                    options: UIViewAnimationOptions.CurveLinear,
                    animations: { () -> Void in
                        progressVC.view.alpha = 0
                    },
                    completion: { (finished:Bool) -> Void in
                        progressVC.view.removeFromSuperview()
                        self.removeVCCollectionByObject(progressVC)
                })
        })
    }
    
    // MARK: - Common methods
    private func generateBackground(#color:UIColor, uiEnabled:Bool) -> UIView {
        var backgroundView = UIView()
        let mainScreenFrame:CGRect = UIScreen.mainScreen().bounds
        let length:CGFloat = (mainScreenFrame.width < mainScreenFrame.height) ? mainScreenFrame.height : mainScreenFrame.width
        let diff:CGFloat = abs(mainScreenFrame.height - mainScreenFrame.width)
        backgroundView.frame = CGRectMake(0, 0, length, length)
        backgroundView.backgroundColor = color
        backgroundView.userInteractionEnabled = uiEnabled
        return backgroundView
    }

    func rotated()
    {
        var cnt:Int = 0
        for anyObject in _PKNotificationSingleton.vcCollection {
            if (anyObject.isKindOfClass(PKAlert)) {
                (anyObject as PKAlert).rotate()
            }
            
            if (anyObject.isKindOfClass(PKToast)) {
                (anyObject as PKToast).rotate()
            }

            if (anyObject.isKindOfClass(PKProgress)) {
                (anyObject as PKProgress).rotate()
            }
            
        }
        
    }
    
    private func removeVCCollectionByObject(target:UIViewController) -> Void {
        var cnt:Int = 0;
        for vc:UIViewController in _PKNotificationSingleton.vcCollection {
            if (vc == target){
                _PKNotificationSingleton.vcCollection.removeAtIndex(cnt)
                break;
            }
        }
    }

    // MARK: - @CLASS PKAlert
    class PKAlert: UIViewController {
        var parent:PKNotificationClass!
        let alertView:UIView = UIView(frame: CGRectMake(0, 0, 100, 100))
        var items:Array<AnyObject> = []
        var messageLabel:UILabel? = nil
        
        // MARK: - Lifecycle
        init(title t:String?, message m:String?, items i:Array<AnyObject>?, cancelButtonTitle c:String?, tintColor tint:UIColor?, parent p:PKNotificationClass) {
            /* initialize alert parts, resize them and set colors */
            super.init()
            parent = p
            let tintColor:UIColor! = (tint == nil) ? parent.alertButtonFontColor : tint
            
            let titleLabel:UILabel? = (t == nil) ? nil : UILabel(frame: CGRectMake(0, 0, parent.alertWidth - parent.alertMargin*2, 40))
            titleLabel?.text = t
            titleLabel?.textColor = parent.alertTitleFontColor
            titleLabel?.font = parent.alertTitleFontStyle
            titleLabel?.textAlignment = NSTextAlignment.Center
            
            let messageLabelWidth:CGFloat = parent.alertWidth - PKNotification.alertMargin*2
            messageLabel = (m == nil) ? nil : UILabel(frame: CGRectMake(0, 0, messageLabelWidth, 44))
            if(messageLabel != nil){
                messageLabel!.text = m
                messageLabel!.textColor = parent.alertMessageFontColor
                messageLabel!.font = parent.alertMEssageFontStyle
                messageLabel!.textAlignment = NSTextAlignment.Center
                messageLabel!.numberOfLines = 0
                messageLabel!.sizeToFit()
                messageLabel!.center = CGPointMake(messageLabelWidth/2, messageLabel!.frame.height/2)
            }

            
            if let tmpItems = i {
                for b:AnyObject in tmpItems {
                    if (b.isKindOfClass(UITextField)){
                        let theLast:AnyObject? = items.last
                        if (theLast != nil) {
                            if(!theLast!.isKindOfClass(UITextField)){
                                continue
                            }
                        }
                        (b as UITextField).frame = CGRectMake(parent.alertMargin, 0, self.parent.alertWidth - 2 * parent.alertMargin, 44)
                        (b as UITextField).layer.sublayerTransform = CATransform3DMakeTranslation(5, 0, 0);
                        (b as UITextField).font = parent.alertMEssageFontStyle
                        items.append((b as UITextField))
                        
                    } else if (b.isKindOfClass(PKButton)){
                        (b as PKButton).frame = CGRectMake(0, 0, self.parent.alertWidth, 44)
                        //TODO: Precise color choise
                        let titleColor:UIColor? = ((b as PKButton).titleLabel?.textColor == UIColor.whiteColor()) ? nil : (b as PKButton).titleLabel?.textColor
                        (b as PKButton).setTitleColor((titleColor == nil) ? tintColor : titleColor, forState: UIControlState.Normal)
                        (b as PKButton).backgroundColor = ((b as PKButton).backgroundColor == nil) ? self.parent.alertBackgroundColor : b.backgroundColor
                        (b as PKButton).addTarget(self, action:"buttonDown:", forControlEvents: UIControlEvents.TouchUpInside)
                        items.append((b as PKButton))
                    }
                }
            }

            let cancelButtonTitle:String! = (c == nil) ? "Dissmiss" : c
            let cancelButton:PKButton! = PKButton(title: cancelButtonTitle!, action: {(items) -> Bool in return true}, fontColor: tintColor, backgroundColor: parent.alertBackgroundColor)
            cancelButton.frame = CGRectMake(0, 0, parent.alertWidth, 44)
            cancelButton.addTarget(self, action:"buttonDown:", forControlEvents: UIControlEvents.TouchUpInside)
            
            /* put parts on an alertview and add it as subview on self.view */
            assembleDefaultStyle(titleLabel, cancelButton)
        }
       
        required init(coder aDecoder: NSCoder) {
            super.init(coder: aDecoder)
        }
        
        required override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
            super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
            //NSLog("########### \(NSStringFromClass(self.dynamicType)): \(self) is initialized. ###########")
        }
        
        override func viewDidLoad() {
            super.viewDidLoad()
            let tapRecognizer = UITapGestureRecognizer(target: self, action: "handleSingleTap:")
            tapRecognizer.numberOfTapsRequired = 1
            self.view.addGestureRecognizer(tapRecognizer)
        }
        
        override func didReceiveMemoryWarning() {
            super.didReceiveMemoryWarning()
        }
        
        deinit {
            //NSLog("########### \(NSStringFromClass(self.dynamicType)): \(self) is deinitialized. ###########")
        }
        
        // MARK: - UI
        func assembleDefaultStyle(titleLabel:UILabel?, _ cancelButton:PKButton!) -> Void {
            /* set layout and adjust button shape */
            let margin:CGFloat = parent.alertMargin
            let lineColor:UIColor = UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1.0)
            let titlePosY:CGFloat = margin
            let messagePosY:CGFloat = (titleLabel == nil) ? titlePosY + margin*2 : titlePosY + titleLabel!.frame.height + margin
            var buttonPosY:CGFloat = (messageLabel == nil) ? messagePosY + margin*2 : messagePosY + messageLabel!.frame.height + margin*2
            titleLabel?.frame.offset(dx:margin , dy: titlePosY)
            messageLabel?.frame.offset(dx:margin , dy: messagePosY)
            
            var k=0
            for ; k < items.count; k++ {
                let o:AnyObject = items[k]
                if !o.isKindOfClass(UITextField){
                    break
                }
                let textField:UITextField = (o as UITextField)
                textField.frame.offset(dx: 0, dy: buttonPosY)
                buttonPosY += textField.frame.height + margin
                alertView.addSubview(textField)
            }
            
            let buttonCnt = items.count - k
            buttonPosY += margin*2
            if(buttonCnt == 1) { //total button count is 2
                /* cancelbutton resize and adjust the shape */
                cancelButton.frame.size = CGSizeMake(parent.alertWidth/2+1, cancelButton.frame.height)
                let rectCancelButton:CGRect = cancelButton.bounds
                let rectCancelButtonMask:CGRect = CGRectMake(1, 0, rectCancelButton.width-2, rectCancelButton.height-1)
                
                let cancelMaskPath:UIBezierPath = UIBezierPath(roundedRect: rectCancelButtonMask, byRoundingCorners: UIRectCorner.BottomLeft, cornerRadii: CGSizeMake(parent.alertCornerRadius, parent.alertCornerRadius))
                let cancelMaskLayer:CAShapeLayer = CAShapeLayer()
                cancelMaskLayer.frame = cancelButton.bounds
                cancelMaskLayer.path = cancelMaskPath.CGPath
                cancelButton.layer.mask = cancelMaskLayer
                cancelButton.layer.borderWidth = 1.0
                cancelButton.layer.borderColor = lineColor.CGColor
                
                /* the other button resize and adjust the shape */
                let button = (items[k] as PKButton)
                button.frame = CGRectMake(parent.alertWidth/2 , buttonPosY, parent.alertWidth/2, cancelButton.frame.height)
                let rectButton:CGRect = button.bounds
                let rectButtonMask:CGRect = CGRectMake(0, 0, rectButton.width-1, rectButton.height-1)
                
                let maskPath:UIBezierPath = UIBezierPath(roundedRect: rectButtonMask, byRoundingCorners: UIRectCorner.BottomRight, cornerRadii: CGSizeMake(parent.alertCornerRadius, parent.alertCornerRadius))
                let maskLayer:CAShapeLayer = CAShapeLayer()
                maskLayer.frame = button.bounds
                maskLayer.path = maskPath.CGPath
                button.layer.mask = maskLayer
                button.layer.borderWidth = 1.0
                button.layer.borderColor = lineColor.CGColor
                
                alertView.addSubview(button)
                
                
            } else { //total button count is 1, 3 or more
                
                for ; k < items.count; k++  {
                    let o:AnyObject = items[k]
                    if !o.isKindOfClass(PKButton){
                        continue
                    }
                    let button:PKButton = (o as PKButton)
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
                
                let rectCancelButton:CGRect = cancelButton.bounds
                let rectCancelButtonMask:CGRect = CGRectMake(1, 0, rectCancelButton.width-2, rectCancelButton.height-1)
                
                let maskPath:UIBezierPath = UIBezierPath(roundedRect: rectCancelButtonMask, byRoundingCorners: UIRectCorner.BottomLeft | UIRectCorner.BottomRight, cornerRadii: CGSizeMake(parent.alertCornerRadius, parent.alertCornerRadius))
                let maskLayer:CAShapeLayer = CAShapeLayer()
                maskLayer.frame = cancelButton.bounds
                maskLayer.path = maskPath.CGPath
                cancelButton.layer.mask = maskLayer
                
                cancelButton.layer.borderWidth = 1.0
                cancelButton.layer.borderColor = lineColor.CGColor
            }
            
            cancelButton.frame.offset(dx: 0, dy: buttonPosY)
            
            let alertBackgroundView = parent.generateBackground(color: UIColor.blackColor(), uiEnabled: true)
            alertBackgroundView.alpha = 0.3
            
            let kAlertHeight:CGFloat = cancelButton.frame.origin.y + cancelButton.frame.height
            alertView.frame.size = CGSizeMake(parent.alertWidth, kAlertHeight)
            alertView.backgroundColor = parent.alertBackgroundColor
            alertView.layer.cornerRadius = parent.alertCornerRadius
            if(titleLabel != nil){ alertView.addSubview(titleLabel!)}
            if(messageLabel != nil){ alertView.addSubview(messageLabel!)}
            alertView.addSubview(cancelButton)
            self.view.addSubview(alertBackgroundView)
            alertView.center = UIApplication.sharedApplication().windows[0].center
            self.view.addSubview( (parent.onVersion < 8.0) ? rotate4os7(alertView) : alertView )
            
        }
        
        func handleSingleTap(recognizer: UITapGestureRecognizer) {
            
            self.view.endEditing(true)
            
        }

        // MARK: - button action
        func buttonDown(sender: PKButton!) -> Void {
            if (sender.actionBlock(messageLabel: messageLabel?, items: items)) {
                //Dissmiss alert
                UIView.animateWithDuration(0.1,
                    delay: 0,
                    options: UIViewAnimationOptions.CurveLinear,
                    animations: { () -> Void in
                        self.view.alpha = 0
                    },
                    completion: { (finished:Bool) -> Void in
                        self.view.removeFromSuperview()
                        var cnt:Int = 0;
                        for vc:UIViewController in _PKNotificationSingleton.vcCollection {
                            if (vc == self){
                                _PKNotificationSingleton.vcCollection.removeAtIndex(cnt)
                                break;
                            }
                            
                        }
                })
            }
        }
        
        func rotate() -> Void {
            let point:CGPoint = UIApplication.sharedApplication().windows[0].center
            if(UIDeviceOrientationIsLandscape(UIDevice.currentDevice().orientation))
            {
                alertView.center = point
            }
            
            if(UIDeviceOrientationIsPortrait(UIDevice.currentDevice().orientation))
            {
                alertView.center = point
            }
        }
        
        
        /**
        * For iOS7
        */
        func rotate4os7(v:UIView) -> UIView {
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
        
    }

    // MARK: - @CLASS PKToast
    class PKToast: UIViewController {
        var parent:PKNotificationClass!
        let rectBounds:CGRect = UIScreen.mainScreen().bounds
        let toastView:UIView = UIView()
        let messageLabel:UILabel = UILabel()
        
        //toast Rect
        var posX:CGFloat = 0
        var posY:CGFloat = 0
        var width:CGFloat = 0
        var height:CGFloat = 0
        
        // MARK: - Lifecycle
        init(message m:String, parent p:PKNotificationClass) {
            super.init()
            parent = p
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
            posX = parent.toastMargin
            posY = rectBounds.size.height - parent.toastMargin - parent.toastHeight
            width = rectBounds.size.width - parent.toastMargin * 2
            height = parent.toastHeight
            let rectToast:CGRect = CGRectMake(posX, posY, width, height)
            toastView.frame = rectToast
            messageLabel.frame = CGRectMake(0, 0, rectToast.width, rectToast.height)
            
            toastView.backgroundColor = parent.toastBackgroundColor
            toastView.alpha = parent.toastAlpha
            toastView.layer.cornerRadius = parent.toastRadious
            messageLabel.font = parent.toastFontStyle
            messageLabel.textColor = parent.toastFontColor
            messageLabel.textAlignment = NSTextAlignment.Center
            messageLabel.text = m
            toastView.addSubview(messageLabel)
            self.view.userInteractionEnabled = false
            self.view.addSubview( (parent.onVersion < 8.0) ? rotate4os7(toastView) : toastView )
            
            if(parent.onVersion < 8.0){
                if(UIApplication.sharedApplication().statusBarOrientation == .LandscapeLeft
                    || UIApplication.sharedApplication().statusBarOrientation == .LandscapeRight){
                    messageLabel.frame.size.width = height
                } else {
                    messageLabel.frame.size.width = width
                }
            }
            
        }
        
        func rotate() -> Void {
            let point:CGPoint = UIApplication.sharedApplication().windows[0].center
            if(UIDeviceOrientationIsLandscape(UIDevice.currentDevice().orientation))
            {
                //progressView.center = point
            }
            
            if(UIDeviceOrientationIsPortrait(UIDevice.currentDevice().orientation))
            {
                //progressView.center = point
            }
        }
        
        /**
         * For iOS7
         */
        func rotate4os7(v:UIView) -> UIView {
            switch(UIApplication.sharedApplication().statusBarOrientation){
                case .Portrait: break
                case .PortraitUpsideDown:
                    v.layer.transform = CATransform3DMakeRotation(CGFloat(M_PI), 0.0, 0.0, 1.0)
                    posX = parent.toastMargin
                    posY = parent.toastMargin + parent.toastHeight
                    width = rectBounds.size.width - parent.toastMargin * 2
                    height = parent.toastHeight
                    v.frame = CGRectMake(posX, posY, width, height)
                    break
                case .LandscapeLeft:
                    v.layer.transform = CATransform3DMakeRotation(90.0 / 180.0 * (-1) * CGFloat(M_PI), 0.0, 0.0, 1.0)
                    posX = rectBounds.size.width - parent.toastMargin - parent.toastHeight
                    posY = parent.toastMargin
                    width = parent.toastHeight
                    height = rectBounds.size.height - parent.toastMargin * 2
                    v.frame = CGRectMake(posX, posY, width, height)
                    break
                case .LandscapeRight:
                    v.layer.transform = CATransform3DMakeRotation(90.0 / 180.0 * CGFloat(M_PI), 0.0, 0.0, 1.0)
                    posX = parent.toastMargin
                    posY = parent.toastMargin
                    width = parent.toastHeight
                    height = rectBounds.size.height - parent.toastMargin * 2
                    v.frame = CGRectMake(posX, posY, width, height)
                    break
                case .Unknown: break
            }
            
            return v
        }
    }

    // MARK: - @CLASS PKProgress
    class PKProgress: UIViewController {
        
        var parent:PKNotificationClass!
        let kMargin:CGFloat = 30
        let rectBounds:CGRect = UIScreen.mainScreen().bounds
        let progressView:UIView = UIView()
        let type:PKProgressType = .Loading
        
        // MARK: - Lifecycle
        init(_ t:PKProgressType, _ m:String?, _ p:PKNotificationClass) {
            super.init()
            parent = p
            switch(t){
                case .Loading:
                    type = t
                    generateLoading()
                    break
                case .Success:
                    type = t
                    generateSuccess(m)
                    break
                case .Failed:
                    type = t
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
            progressView.frame = CGRectMake(0, 0, parent.progressWidth, parent.progressHeight)
            progressView.center = self.view.center
            progressView.backgroundColor = parent.loadingBackgroundColor
            progressView.alpha = parent.progressAlpha
            progressView.layer.cornerRadius = parent.progressRadious
            
            let ai:UIActivityIndicatorView = UIActivityIndicatorView() as UIActivityIndicatorView
            ai.center = progressView.center
            ai.activityIndicatorViewStyle = parent.loadingActiveIndicatorStyle
            ai.hidesWhenStopped = true
            ai.startAnimating()

            self.view.addSubview((parent.onVersion < 8.0) ? rotate4os7(progressView) : progressView)
            self.view.addSubview((parent.onVersion < 8.0) ? rotate4os7(ai) : ai)
            self.view.userInteractionEnabled = false
        }
        
        func generateSuccess(m:String?){
            progressView.frame = CGRectMake(0, 0, parent.progressWidth, parent.progressHeight)
            progressView.center = self.view.center
            progressView.backgroundColor = parent.successBackgroundColor
            progressView.alpha = parent.progressAlpha
            progressView.layer.cornerRadius = parent.progressRadious
            
            let imageSize:CGSize = CGSizeMake(parent.progressWidth - kMargin*2, parent.progressHeight - kMargin*2)
            let imageView:UIImageView = UIImageView(frame: CGRectMake(0, 0, imageSize.width, imageSize.height))
            imageView.image = parent.successImage == nil ? parent.defaultSuccessImage : parent.successImage
            imageView.frame.origin = CGPointMake(kMargin, kMargin)
            
            if(m != nil){
                let messageLabel:UILabel = UILabel()
                messageLabel.frame = CGRectMake(0, parent.progressHeight - parent.progressLabelHeight, parent.progressWidth, parent.progressLabelHeight)
                messageLabel.font = parent.progressFontStyle
                messageLabel.textColor = parent.progressFontColor
                messageLabel.textAlignment = NSTextAlignment.Center
                messageLabel.text = m
                imageView.frame.origin = CGPointMake(kMargin, kMargin - parent.progressLabelHeight/4)
                progressView.addSubview(messageLabel)
            }
            progressView.addSubview(imageView)
            self.view.userInteractionEnabled = false
            self.view.addSubview((parent.onVersion < 8.0) ? rotate4os7(progressView) : progressView)
        }
        
        func generateFailed(m:String?){
            progressView.frame = CGRectMake(0, 0, parent.progressWidth, parent.progressHeight)
            progressView.center = self.view.center
            progressView.backgroundColor = parent.failedBackgroundColor
            progressView.alpha = parent.progressAlpha
            progressView.layer.cornerRadius = parent.progressRadious
            
            let imageSize:CGSize = CGSizeMake(parent.progressWidth - kMargin*2, parent.progressHeight - kMargin*2)
            let imageView:UIImageView = UIImageView(frame: CGRectMake(0, 0, imageSize.width, imageSize.height))
            imageView.image = parent.failedImage == nil ? parent.defaultFailedImage : parent.failedImage
            imageView.frame.origin = CGPointMake(kMargin, kMargin)
            
            if(m != nil){
                let messageLabel:UILabel = UILabel()
                messageLabel.frame = CGRectMake(0, parent.progressHeight - parent.progressLabelHeight, parent.progressWidth, parent.progressLabelHeight)
                messageLabel.font = parent.progressFontStyle
                messageLabel.textColor = parent.progressFontColor
                messageLabel.textAlignment = NSTextAlignment.Center
                messageLabel.text = m
                imageView.frame.origin = CGPointMake(kMargin, kMargin - parent.progressLabelHeight/4)
                progressView.addSubview(messageLabel)
            }
            progressView.addSubview(imageView)
            self.view.userInteractionEnabled = false
            self.view.addSubview((parent.onVersion < 8.0) ? rotate4os7(progressView) : progressView)
        }

        func rotate() -> Void {
            let point:CGPoint = UIApplication.sharedApplication().windows[0].center
            if(UIDeviceOrientationIsLandscape(UIDevice.currentDevice().orientation))
            {
                progressView.center = point
            }
            
            if(UIDeviceOrientationIsPortrait(UIDevice.currentDevice().orientation))
            {
                progressView.center = point
            }
        }
        
        /**
        * For iOS7
        */
        func rotate4os7(v:UIView) -> UIView {
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

    }
    
    // MARK: - @CLASS Images
    class Images {
        func success() -> UIImage {
            let base64Str:String = "iVBORw0KGgoAAAANSUhEUgAAAGQAAABkCAYAAABw4pVUAAAABmJLR0QA/wD/AP+gvaeTAAAACXBIWXMAAAsTAAALEwEAmpwYAAAAB3RJTUUH3gwcEAgrQ5wC4QAAAXdJREFUeNrt2DFKA0EYhuHRM3gSIb2F2KX0JLYpLHMW72IhWIn3CAHhs1khlUYx8Yv7vJAuxc7/7DDMjiFJkiRJkiRJkiRJkiRJ2i3JVZJrk+jAWCZ5TPKc5NZEOjA+glKEAaUQA0ohxi7KXgf9ubH+HGOMcT/GuNzj79sxxpup/f3OyPS/panBgAEDBgwYMAQDhmDAEAwY+iWMRZLtnhjbJAtTszNgwIABA4YDXLPYGUnOklzA6MG4SfJwCg8+F4ynnQUsYHRg7B5+y8Ln/b8H+CcYlW/XXHdG5cL+/T0jycV0gNcvcDaXvlNY6Oxu4NOCt40Lnu0NfFp41Vs4+29TTQPwobBoEDCKBgKj6KCHUXTQwygaFIyigcEoQoFRhAKjCAVGEQqMIhQYXSiv0w9GEQqME0OBUYQCowgFxoFRXr6B8QLj8CirJJs9MDZJViZ2HJT1FyibJGuT6kCBUYQCowgFRhHKXZI7k5AkSZIkSZIkSZKO0Ds6sLt1lfeMOAAAAABJRU5ErkJggg=="
            let imgData:NSData = NSData(base64EncodedString: base64Str, options: NSDataBase64DecodingOptions.IgnoreUnknownCharacters)!
            let image:UIImage = UIImage(data: imgData)!
            
            return image
        }
        
        func failed() -> UIImage {
            let base64Str:String = "iVBORw0KGgoAAAANSUhEUgAAAGQAAABkCAYAAABw4pVUAAAABmJLR0QA/wD/AP+gvaeTAAAACXBIWXMAAAsTAAALEwEAmpwYAAAAB3RJTUUH3gwcEAgdjCaXeAAAAz9JREFUeNrt3D1sTWEcx/Hv4yWhioi2BFUhFjGIKvHS7h26t43UwMruZZBUJAYGWxODQbCZxCzxEonBIBYhWvHSllQpkVA/yzMI9173ntuee87p75Pc5aTPef4vec55+gwHzMzMzMzMzMzMzMzMzMzMzBYCSc2SBiTdljQdf7fjteYC5rtYUpekEUkT8TcSry1udHAD+r+BAjWjq4p8uxoV3LCqN1yAZgzVkO9QFldGYVZKlStjTlZKSPLOAL4kzG1lCGEmb+8M4GfC4UtCCLO1DFiUYJK+OvLry+EC2Z3m2CQNOVxHgIdz2JBjaY5N8siaBlYlDPBzCGF1zh5ZE0BrwuGTIYS2+V4hNo+SNOReHfPdy2GNbqU5NklDrtUR4LUcNuRKmmO97c37tjcWdDBBcIN5a0bMdxbYm2Do3lqb4aOTohyd1HiE4sPFlIP08XtWjt/NzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMbG6ErAYmKQBNwFpgA7AZ6AC2AO3xWguwJv7dIuAX8A2YAj4Ab4HXwCtgFBiL1z4C30IIckPKF78N2AEcBHqBAylM/QC4A9wHngETjW5SaGATWoH9QD+QpY8L3ABuAg9DCJOFfj5Kapd0XNK48mE8xttepCY0S+qXNKZ8G4t5NOe1EZskXVIxXZK0KRfvEEkdwHmSfcLpT+PAc+Bl3CG9Ad4Dk3EXNQ18Bb4DPwDFfJYCy4AVwOq4C2sF1gMb405tK7AdWFdnjNeBUyGE0cw1RNIa4CxwIsHwF8Aj4DHwBHiaxgs1bix2AruAPcA+YFuCW10GzoYQprLyeOqvccm/k3Q1foOqI2OP2o4Y19UYZy36Gx18m6S7VQY7KumipJ6cvQt7YtyjVeZ5V1JbIwLtrjLA65J6C7Jj7I35VKM7zcCO/ieYT5LOFWr//u//U+dinpUcTSOY0xUCmJF0RlLTQjgIlNQU852pUJPT8xnAyQoTX5bUshBPaCW1xPzLOTkfkx4pM9mjVJ+X2W5Md6xHKUfmcqLOMpNccBtK1utCmXp1zsXNl5e48aykQZe+Yt0GY53+trzeGw+XOAE95JJXVbtDJU62h10ZMzMzMzPLkt8vA/1E0dnMwQAAAABJRU5ErkJggg=="
            let imgData:NSData = NSData(base64EncodedString: base64Str, options: NSDataBase64DecodingOptions.IgnoreUnknownCharacters)!
            let image:UIImage = UIImage(data: imgData)!
            
            return image
        }
    }
}

// MARK: - @CLASS PKButton
class PKButton: UIButton {
    var actionBlock:PKButtonActionBlock = {(item) -> Bool in return true}
    
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

extension String {
    var floatValue: Float {
        return (self as NSString).floatValue
    }
}

