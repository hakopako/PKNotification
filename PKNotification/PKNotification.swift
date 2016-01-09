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
    var alertMessageFontStyle:UIFont = UIFont.systemFontOfSize(13)
    var alertButtonFontColor:UIColor = UIColor.grayColor()
    var alertBackgroundColor:UIColor = UIColor.whiteColor()
    var alertCornerRadius:CGFloat = 8
    
    //PKActionSheet custom
    var actionSheetMargin:CGFloat = 8
    var actionSheetTitleFontColor:UIColor = UIColor.darkGrayColor()
    var actionSheetTitleFontStyle:UIFont = UIFont.boldSystemFontOfSize(17)
    var actionSheetButtonFontColor:UIColor = UIColor.grayColor()
    var actionSheetBackgroundColor:UIColor = UIColor.whiteColor()
    var actionSheetCornerRadius:CGFloat = 8
    
    // MARK: - Lifecycle
    required init?(coder aDecoder: NSCoder) {
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

    func actionSheet(title t:String?, items i:Array<PKButton>?, cancelButtonTitle c:String?, tintColor tint:UIColor?) {
        let actionSheetVC:PKActionSheet = PKActionSheet(title:t, items:i, cancelButtonTitle:c, tintColor:tint, parent: self)
        _PKNotificationSingleton.vcCollection.append(actionSheetVC)
        actionSheetVC.view.center = UIApplication.sharedApplication().windows[0].center
        UIApplication.sharedApplication().windows[0].addSubview(actionSheetVC.view)
        
        let w:CGFloat = actionSheetVC.rectBounds.size.width
        let h:CGFloat = actionSheetVC.rectBounds.size.height
        var actual_h:CGFloat = 0
        if(UIDeviceOrientationIsLandscape(UIDevice.currentDevice().orientation))
        {
            actual_h = (w < h) ? w : h
        }
        
        if(UIDeviceOrientationIsPortrait(UIDevice.currentDevice().orientation))
        {
            actual_h = (h < w) ? w : h
        }
        
        actionSheetVC.actionSheetView.frame = CGRectMake(
            actionSheetVC.actionSheetView.frame.origin.x,
            actual_h,
            actionSheetVC.actionSheetView.frame.width,
            actionSheetVC.actionSheetView.frame.height)
        
        UIView.animateWithDuration(0.2,
            delay: 0,
            options: UIViewAnimationOptions.CurveLinear,
            animations: { () -> Void in
                actionSheetVC.actionSheetView.frame = CGRectMake(
                    self.actionSheetMargin,
                    actual_h - actionSheetVC.actionSheetView.frame.height,
                    actionSheetVC.actionSheetView.frame.width,
                    actionSheetVC.actionSheetView.frame.height)
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
            let cnt:Int = 0
            for anyObject in _PKNotificationSingleton.vcCollection {
                if (anyObject.isKindOfClass(PKProgress)) {
                    if (anyObject as! PKProgress).type == PKProgressType.Loading {
                        (anyObject as! PKProgress).view.removeFromSuperview()
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
    private func generateBackground(color color:UIColor, uiEnabled:Bool) -> UIView {
        let backgroundView = UIView()
        let mainScreenFrame:CGRect = UIScreen.mainScreen().bounds
        let length:CGFloat = (mainScreenFrame.width < mainScreenFrame.height) ? mainScreenFrame.height : mainScreenFrame.width
        backgroundView.frame = CGRectMake(0, 0, length, length)
        backgroundView.backgroundColor = color
        backgroundView.userInteractionEnabled = uiEnabled
        return backgroundView
    }

    func rotated()
    {
        for anyObject in _PKNotificationSingleton.vcCollection {
            if (anyObject.isKindOfClass(PKAlert)) {
                (anyObject as! PKAlert).rotate()
            }
            
            if (anyObject.isKindOfClass(PKActionSheet)) {
                (anyObject as! PKActionSheet).rotate()
            }
            
            if (anyObject.isKindOfClass(PKToast)) {
                (anyObject as! PKToast).rotate()
            }
            
            if (anyObject.isKindOfClass(PKProgress)) {
                (anyObject as! PKProgress).rotate()
            }
        }
        
    }
    
    private func removeVCCollectionByObject(target:UIViewController) -> Void {
        let cnt:Int = 0;
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
        var titleLabel:UILabel? = nil
        var items:Array<AnyObject> = []
        var messageLabel:UILabel? = nil
        var cancelButton:PKButton! = PKButton()
        
        // MARK: - Lifecycle
        convenience init(title t:String?, message m:String?, items i:Array<AnyObject>?, cancelButtonTitle c:String?, tintColor tint:UIColor?, parent p:PKNotificationClass) {
            /* initialize alert parts, resize them and set colors */
            self.init()
            parent = p
            let tintColor:UIColor! = (tint == nil) ? parent.alertButtonFontColor : tint
            
            titleLabel = (t == nil) ? nil : UILabel()
            titleLabel?.text = t
            
            messageLabel = (m == nil) ? nil : UILabel()
            messageLabel?.text = m

            
            if let tmpItems = i {
                for b:AnyObject in tmpItems {
                    if (b is PKButton){
                        //TODO: Precise color choise
                        let titleColor:UIColor? = ((b as! PKButton).titleLabel?.textColor == UIColor.whiteColor()) ? nil : (b as! PKButton).titleLabel?.textColor
                        (b as! PKButton).setTitleColor((titleColor == nil) ? tintColor : titleColor, forState: UIControlState.Normal)
                        (b as! PKButton).backgroundColor = ((b as! PKButton).backgroundColor == nil) ? self.parent.alertBackgroundColor : b.backgroundColor
                        (b as! PKButton).addTarget(self, action:"buttonDown:", forControlEvents: UIControlEvents.TouchUpInside)
                        items.append((b as! PKButton))
                    } else if (b.isKindOfClass(UITextField) || b is UIButton){
                        let theLast:AnyObject? = items.last
                        if (theLast != nil) {
                            if(!theLast!.isKindOfClass(UITextField) && !(theLast! is UIButton)){
                                continue
                            }
                        }
                        if(b.isKindOfClass(UITextField)){
                            items.append(b as! UITextField)
                        } else if (b is UIButton){
                            items.append(b as! UIButton)
                        }
                    }
                }
            }

            let cancelButtonTitle:String! = (c == nil) ? "Dissmiss" : c
            cancelButton = PKButton(title: cancelButtonTitle!, action: {(items) -> Bool in return true}, fontColor: tintColor, backgroundColor: parent.alertBackgroundColor)
            cancelButton.addTarget(self, action:"buttonDown:", forControlEvents: UIControlEvents.TouchUpInside)
            
            /* put parts on an alertview and add it as subview on self.view */
            resizeParts()
            let alertBackgroundView = parent.generateBackground(color: UIColor.blackColor(), uiEnabled: true)
            alertBackgroundView.alpha = 0.3
            if(titleLabel != nil){ alertView.addSubview(titleLabel!)}
            if(messageLabel != nil){ alertView.addSubview(messageLabel!)}
            for b:AnyObject in items {
                alertView.addSubview((b as! UIView))
            }
            alertView.addSubview(cancelButton)
            self.view.addSubview(alertBackgroundView)
            self.view.addSubview(alertView)
        }
       
        required init?(coder aDecoder: NSCoder) {
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
        func resizeParts() -> Void {
            /* set layout and adjust button shape */
            let margin:CGFloat = parent.alertMargin
            let messageLabelWidth:CGFloat = parent.alertWidth - margin*2
            let lineColor:UIColor = UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1.0)
            let titlePosY:CGFloat = margin
            titleLabel?.frame = CGRectMake(margin, titlePosY, messageLabelWidth, 40)
            titleLabel?.textColor = parent.alertTitleFontColor
            titleLabel?.font = parent.alertTitleFontStyle
            titleLabel?.textAlignment = NSTextAlignment.Center
            
            let messagePosY:CGFloat = (titleLabel == nil) ? titlePosY + margin*2 : titlePosY + titleLabel!.frame.height + margin
            messageLabel?.textColor = parent.alertMessageFontColor
            messageLabel?.font = parent.alertMessageFontStyle
            messageLabel?.textAlignment = NSTextAlignment.Center
            messageLabel?.numberOfLines = 0
            messageLabel?.frame = CGRectMake(margin, messagePosY, messageLabelWidth, 44)
            messageLabel?.sizeToFit()
            messageLabel?.frame = CGRectMake((parent.alertWidth - messageLabel!.frame.width)/2, messagePosY, messageLabel!.frame.width, messageLabel!.frame.height)
            
            var buttonPosY:CGFloat = (messageLabel == nil) ? messagePosY + margin*2 : messagePosY + messageLabel!.frame.height + margin*2
            
            for b:AnyObject in items {
                if (b.isKindOfClass(UITextField)){
                    (b as! UITextField).frame = CGRectMake(parent.alertMargin, buttonPosY, self.parent.alertWidth - 2 * parent.alertMargin, 44)
                    (b as! UITextField).layer.sublayerTransform = CATransform3DMakeTranslation(5, 0, 0);
                    (b as! UITextField).font = parent.alertMessageFontStyle
                    buttonPosY += b.frame.height + margin
                } else if (b.isKindOfClass(PKButton)){
                    (b as! PKButton).frame = CGRectMake(0, buttonPosY, self.parent.alertWidth, 44)
                    let rectButton:CGRect = b.bounds
                    let rectButtonMask:CGRect = CGRectMake(1, 0, rectButton.width-2, rectButton.height-1)
                    let maskPath:UIBezierPath = UIBezierPath(rect:rectButtonMask)
                    let maskLayer:CAShapeLayer = CAShapeLayer()
                    maskLayer.frame = b.bounds
                    maskLayer.path = maskPath.CGPath
                    b.layer.mask = maskLayer
                    b.layer.borderWidth = 1.0
                    b.layer.borderColor = lineColor.CGColor
                    buttonPosY += b.frame.height
                } else if (b is UIButton){
                    (b as! UIButton).frame = CGRectMake(0, buttonPosY, self.parent.alertWidth - 2 * parent.alertMargin, 44)
                    buttonPosY += b.frame.height + margin
                }
            }
            
            cancelButton.frame = CGRectMake(0, buttonPosY, parent.alertWidth, 44)
            let rectCancelButton:CGRect = cancelButton.bounds
            let rectCancelButtonMask:CGRect = CGRectMake(1, 0, rectCancelButton.width-2, rectCancelButton.height-1)
            
            let maskPath:UIBezierPath = UIBezierPath(roundedRect: rectCancelButtonMask, byRoundingCorners: [UIRectCorner.BottomLeft, UIRectCorner.BottomRight], cornerRadii: CGSizeMake(parent.alertCornerRadius, parent.alertCornerRadius))
            let maskLayer:CAShapeLayer = CAShapeLayer()
            maskLayer.frame = cancelButton.bounds
            maskLayer.path = maskPath.CGPath
            cancelButton.layer.mask = maskLayer
            cancelButton.layer.borderWidth = 1.0
            cancelButton.layer.borderColor = lineColor.CGColor
            
            let kAlertHeight:CGFloat = cancelButton.frame.origin.y + cancelButton.frame.height
            alertView.frame.size = CGSizeMake(parent.alertWidth, kAlertHeight)
            alertView.backgroundColor = parent.alertBackgroundColor
            alertView.layer.cornerRadius = parent.alertCornerRadius
            alertView.center = UIApplication.sharedApplication().windows[0].center
            
        }
        
        func handleSingleTap(recognizer: UITapGestureRecognizer) {
            self.view.endEditing(true)
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

        // MARK: - button action
        func buttonDown(sender: PKButton!) -> Void {
            if (sender.actionBlock(messageLabel: messageLabel, items: items)) {
                //Dissmiss alert
                UIView.animateWithDuration(0.1,
                    delay: 0,
                    options: UIViewAnimationOptions.CurveLinear,
                    animations: { () -> Void in
                        self.view.alpha = 0
                    },
                    completion: { (finished:Bool) -> Void in
                        self.view.removeFromSuperview()
                        let cnt:Int = 0;
                        for vc:UIViewController in _PKNotificationSingleton.vcCollection {
                            if (vc == self){
                                _PKNotificationSingleton.vcCollection.removeAtIndex(cnt)
                                break;
                            }
                            
                        }
                })
            }
            resizeParts()
        }
    }
    
    
    // MARK: - @CLASS PKActionSheet
    class PKActionSheet: UIViewController {
        var parent:PKNotificationClass!
        let rectBounds:CGRect = UIScreen.mainScreen().bounds
        let actionSheetView:UIView = UIView(frame: CGRectMake(0, 0, 100, 100))
        var titleLabel:UILabel? = nil
        var items:Array<PKButton> = []
        var cancelButton:PKButton! = PKButton()
        
        // MARK: - Lifecycle
        convenience init(title t:String?, items i:Array<PKButton>?, cancelButtonTitle c:String?, tintColor tint:UIColor?, parent p:PKNotificationClass) {
            /* initialize alert parts, resize them and set colors */
            self.init()
            parent = p
            let tintColor:UIColor! = (tint == nil) ? parent.actionSheetButtonFontColor : tint
            
            titleLabel = (t == nil) ? nil : UILabel()
            titleLabel?.text = t
            
            if let tmpItems = i {
                for b:PKButton in tmpItems {
                    //TODO: Precise color choise
                    let titleColor:UIColor? = (b.titleLabel?.textColor == UIColor.whiteColor()) ? nil : b.titleLabel?.textColor
                    b.setTitleColor((titleColor == nil) ? tintColor : titleColor, forState: UIControlState.Normal)
                    b.backgroundColor = (b.backgroundColor == nil) ? self.parent.actionSheetBackgroundColor : b.backgroundColor
                    b.addTarget(self, action:"buttonDown:", forControlEvents: UIControlEvents.TouchUpInside)
                    items.append(b)
                }
            }
            
            let cancelButtonTitle:String! = (c == nil) ? "Dissmiss" : c
            cancelButton = PKButton(title: cancelButtonTitle!, action: {(items) -> Bool in return true}, fontColor: tintColor, backgroundColor: parent.actionSheetBackgroundColor)
            cancelButton.addTarget(self, action:"buttonDown:", forControlEvents: UIControlEvents.TouchUpInside)
            
            /* put parts on an alertview and add it as subview on self.view */
            resizeParts()
            let actionSheetBackgroundView = parent.generateBackground(color: UIColor.blackColor(), uiEnabled: true)
            actionSheetBackgroundView.alpha = 0.3
            if(titleLabel != nil){ actionSheetView.addSubview(titleLabel!)}
            for b:AnyObject in items {
                actionSheetView.addSubview((b as! UIView))
            }
            actionSheetView.addSubview(cancelButton)
            self.view.addSubview(actionSheetBackgroundView)
            self.view.addSubview(actionSheetView)
        }
        
        required init?(coder aDecoder: NSCoder) {
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
        func resizeParts() -> Void {
            /* set layout and adjust button shape */
            let margin:CGFloat = parent.actionSheetMargin
            let lineColor:UIColor = UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1.0)
            let titlePosY:CGFloat = margin
            let w:CGFloat = UIScreen.mainScreen().bounds.width
            //let w:CGFloat = (UIScreen.mainScreen().bounds.width < UIScreen.mainScreen().bounds.height) ? UIScreen.mainScreen().bounds.width : UIScreen.mainScreen().bounds.height
            let actionSheetWidth:CGFloat = w - margin*2
            titleLabel?.frame = CGRectMake(0, titlePosY, actionSheetWidth, 40)
            titleLabel?.textColor = parent.actionSheetTitleFontColor
            titleLabel?.font = parent.actionSheetTitleFontStyle
            titleLabel?.textAlignment = NSTextAlignment.Center
            
            var buttonPosY:CGFloat = (titleLabel == nil) ? 0:  titlePosY + titleLabel!.frame.height + margin
            
            for b:PKButton in items {
                b.frame = CGRectMake(0, buttonPosY, actionSheetWidth, 44)
                let rectButton:CGRect = b.bounds
                
                if(b.isEqual(items.first) && titleLabel == nil){
                    let rectButtonMaskr:CGRect = CGRectMake(1, 1, rectButton.width-2, rectButton.height-2)
                    let maskPathr:UIBezierPath = UIBezierPath(roundedRect: rectButtonMaskr, byRoundingCorners: [UIRectCorner.TopLeft, UIRectCorner.TopRight], cornerRadii: CGSizeMake(parent.actionSheetCornerRadius, parent.actionSheetCornerRadius))
                    let maskLayerr:CAShapeLayer = CAShapeLayer()
                    maskLayerr.frame = b.bounds
                    maskLayerr.path = maskPathr.CGPath
                    b.layer.mask = maskLayerr
                    b.layer.borderWidth = 1.0
                    b.layer.borderColor = lineColor.CGColor

                } else {
                    let rectButtonMask:CGRect = CGRectMake(1, 0, rectButton.width-2, rectButton.height-1)
                    let maskPath:UIBezierPath = UIBezierPath(rect:rectButtonMask)
                    let maskLayer:CAShapeLayer = CAShapeLayer()
                    maskLayer.frame = b.bounds
                    maskLayer.path = maskPath.CGPath
                    b.layer.mask = maskLayer
                    b.layer.borderWidth = 1.0
                    b.layer.borderColor = lineColor.CGColor
                }
                buttonPosY += b.frame.height
            }
            
            cancelButton.frame = CGRectMake(0, buttonPosY, actionSheetWidth, 44)
            let rectCancelButton:CGRect = cancelButton.bounds
            let rectCancelButtonMask:CGRect = CGRectMake(1, 0, rectCancelButton.width-2, rectCancelButton.height-1)
            
            let maskPath:UIBezierPath = UIBezierPath(roundedRect: rectCancelButtonMask, byRoundingCorners: [UIRectCorner.BottomLeft, UIRectCorner.BottomRight], cornerRadii: CGSizeMake(parent.actionSheetCornerRadius, parent.actionSheetCornerRadius))
            let maskLayer:CAShapeLayer = CAShapeLayer()
            maskLayer.frame = cancelButton.bounds
            maskLayer.path = maskPath.CGPath
            cancelButton.layer.mask = maskLayer
            cancelButton.layer.borderWidth = 1.0
            cancelButton.layer.borderColor = lineColor.CGColor
            
            let kActionSheetHeight:CGFloat = cancelButton.frame.origin.y + cancelButton.frame.height
            actionSheetView.frame.size = CGSizeMake(actionSheetWidth, kActionSheetHeight)
            actionSheetView.backgroundColor = parent.actionSheetBackgroundColor
            actionSheetView.layer.cornerRadius = parent.actionSheetCornerRadius
            //actionSheetView.center = UIApplication.sharedApplication().windows[0].center
            
        }
        
        func handleSingleTap(recognizer: UITapGestureRecognizer) {
            self.view.endEditing(true)
        }
        
        func rotate() -> Void {
            let w:CGFloat = rectBounds.size.width
            let h:CGFloat = rectBounds.size.height
            var actual_h:CGFloat = 0
            if(UIDeviceOrientationIsLandscape(UIDevice.currentDevice().orientation))
            {
                actual_h = (w < h) ? w : h
            }
            
            if(UIDeviceOrientationIsPortrait(UIDevice.currentDevice().orientation))
            {
                actual_h = (h < w) ? w : h
            }
            resizeParts()
            actionSheetView.frame = CGRectMake(
                parent.actionSheetMargin,
                actual_h - actionSheetView.frame.height,
                actionSheetView.frame.width,
                actionSheetView.frame.height)
            
        }
        
        // MARK: - button action
        func buttonDown(sender: PKButton!) -> Void {
            //Dissmiss alert
            UIView.animateWithDuration(0.1,
                delay: 0,
                options: UIViewAnimationOptions.CurveLinear,
                animations: { () -> Void in
                    self.view.alpha = 0
                },
                completion: { (finished:Bool) -> Void in
                    self.view.removeFromSuperview()
                    let cnt:Int = 0;
                    for vc:UIViewController in _PKNotificationSingleton.vcCollection {
                        if (vc == self){
                            _PKNotificationSingleton.vcCollection.removeAtIndex(cnt)
                            break;
                        }
                        
                    }
            })
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
        convenience init(message m:String, parent p:PKNotificationClass) {
            self.init()
            parent = p
            generate(message: m)
        }

        required init?(coder aDecoder: NSCoder) {
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
            self.view.addSubview(toastView)
        }
        
        func rotate() -> Void {
            let w:CGFloat = rectBounds.size.width
            let h:CGFloat = rectBounds.size.height
            if(UIDeviceOrientationIsLandscape(UIDevice.currentDevice().orientation))
            {
                posY = (h < w) ? h - parent.toastMargin - parent.toastHeight : w - parent.toastMargin - parent.toastHeight
                width = (h < w) ? w - parent.toastMargin * 2 : h - parent.toastMargin * 2
            }
            
            if(UIDeviceOrientationIsPortrait(UIDevice.currentDevice().orientation))
            {
                posY = (w < h) ? h - parent.toastMargin - parent.toastHeight : w - parent.toastMargin - parent.toastHeight
                width = (w < h) ? w - parent.toastMargin * 2 : h - parent.toastMargin * 2
            }
            toastView.frame = CGRectMake(posX, posY, width, height)
            messageLabel.frame = CGRectMake(0, 0, toastView.frame.width, toastView.frame.height)
        }
    }

    // MARK: - @CLASS PKProgress
    class PKProgress: UIViewController {
        
        var parent:PKNotificationClass!
        let kMargin:CGFloat = 30
        let rectBounds:CGRect = UIScreen.mainScreen().bounds
        let progressView:UIView = UIView()
        var type:PKProgressType = .Loading
        
        // MARK: - Lifecycle
        convenience init(_ t:PKProgressType, _ m:String?, _ p:PKNotificationClass) {
            self.init()
            parent = p
            type = t
            switch(t){
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
        
        required init?(coder aDecoder: NSCoder) {
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
            ai.frame = CGRectMake(
                (progressView.frame.width - ai.frame.width)/2,
                (progressView.frame.height - ai.frame.height)/2,
                ai.frame.width,
                ai.frame.height)
            ai.activityIndicatorViewStyle = parent.loadingActiveIndicatorStyle
            ai.hidesWhenStopped = true
            ai.startAnimating()
            progressView.addSubview(ai)
            self.view.addSubview(progressView)
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
            self.view.addSubview(progressView)
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
            self.view.addSubview(progressView)
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
    
    convenience init(title t:String, action a:PKButtonActionBlock, fontColor f:UIColor?, backgroundColor b:UIColor?) {
        self.init()
        actionBlock = a
        self.setTitle(t, forState: UIControlState.Normal)
        self.setTitleColor(f, forState: UIControlState.Normal)
        self.backgroundColor = b
        self.titleLabel?.textAlignment = NSTextAlignment.Center
    }
    
    required init?(coder aDecoder: NSCoder) {
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

