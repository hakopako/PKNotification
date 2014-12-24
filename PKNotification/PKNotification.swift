//
//  PKNotification.swift
//  PKNotification
//
//  Created by hakopako on 2014/12/24.
//  Copyright (c) 2014年 hakopako.
//

import UIKit

enum PKNotifications {
    case Error, Success, Warning, Info
}

extension String {
    var floatValue: Float {
        return (self as NSString).floatValue
    }
}

let kOnVersion:Float = (UIDevice.currentDevice().systemVersion).floatValue

// MARK: - @CLASS PKNotification
class PKNotification: UIViewController {
    
    var vcCache:NSCache = NSCache()
    
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
    func alert() {
        
    }

    func toast(message m:String!, style s:PKNotifications?) {
        let bgView = generateBackground(color: UIColor.clearColor(), uiEnabled:false)
        let toastVC = PKToast(message:m, style:s)
        vcCache.setObject(toastVC, forKey: toastVC)

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
                                                    self.vcCache.removeObjectForKey(toastVC)
                                             })
                        })
        
    }
    
    func loading(flag:Bool) {
        
    }
    
    func success() {
        
    }
    
    func failed() {
        
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
        if(UIDeviceOrientationIsLandscape(UIDevice.currentDevice().orientation))
        {
//            let vc:UIViewController = vcCache.objectForKey(<#key: AnyObject#>)
//            
//            if(vc.isKindOfClass(PKToast)){
//                
//            }
            
            println("landscape")
        }
        
        if(UIDeviceOrientationIsPortrait(UIDevice.currentDevice().orientation))
        {
            println("portraight")
        }
        
    }
}

// MARK: - @CLASS PKAlert
class PKAlert: UIViewController {
    // MARK: - Lifecycle
    required override init() {
        super.init()
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

// MARK: - @CLASS PKToast
class PKToast: UIViewController {
    
    let kMargin:CGFloat = 8
    let kHeight:CGFloat = 50
    let kAlpha:CGFloat = 0.8
    let kRadious:CGFloat = 1
    let fontColor:UIColor = UIColor.whiteColor()
    let fontStyle:UIFont = UIFont.systemFontOfSize(15)
    let rectBounds:CGRect = UIScreen.mainScreen().bounds
    
    //toast Rect
    var posX:CGFloat = 0
    var posY:CGFloat = 0
    var width:CGFloat = 0
    var height:CGFloat = 0
    
    // MARK: - Lifecycle
    init(message m:String, style s:PKNotifications?) {
        super.init()
        generate(message: m, style: s)
    }
    
    required override init() {
        super.init()
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    required override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        NSLog("########### \(NSStringFromClass(self.dynamicType)) is initialized. ###########")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    deinit {
        NSLog("########### \(NSStringFromClass(self.dynamicType)) is deinitialized. ###########")
    }
    
    // MARK: - generate
    func generate(message m:String, style s:PKNotifications?) {
        let toastView:UIView = UIView()
        let messageLabel:UILabel = UILabel()
        posX = kMargin
        posY = rectBounds.size.height - kMargin - kHeight
        width = rectBounds.size.width - kMargin * 2
        height = kHeight
        let rectToast:CGRect = CGRectMake(posX, posY, width, height)
        toastView.frame = rectToast
        messageLabel.frame = CGRectMake(0, 0, rectToast.width, rectToast.height)
        
        toastView.backgroundColor = UIColor.blackColor()
        toastView.alpha = kAlpha
        toastView.layer.cornerRadius = kRadious
        messageLabel.font = fontStyle
        messageLabel.textColor = fontColor
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
                posX = kMargin
                posY = kMargin + kHeight
                width = rectBounds.size.width - kMargin * 2
                height = kHeight
                v.frame = CGRectMake(posX, posY, width, height)
                break
            case .LandscapeLeft:
                v.layer.transform = CATransform3DMakeRotation(90.0 / 180.0 * (-1) * CGFloat(M_PI), 0.0, 0.0, 1.0)
                posX = rectBounds.size.width - kMargin - kHeight
                posY = kMargin
                width = kHeight
                height = rectBounds.size.height - kMargin * 2
                v.frame = CGRectMake(posX, posY, width, height)
                break
            case .LandscapeRight:
                v.layer.transform = CATransform3DMakeRotation(90.0 / 180.0 * CGFloat(M_PI), 0.0, 0.0, 1.0)
                posX = kMargin
                posY = kMargin
                width = kHeight
                height = rectBounds.size.height - kMargin * 2
                v.frame = CGRectMake(posX, posY, width, height)
                break
            case .Unknown: break
        }
        
        return v
    }
}

// MARK: - @CLASS PKProgress
class PKProgress: UIViewController {
    // MARK: - Lifecycle
    required override init() {
        super.init()
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}


