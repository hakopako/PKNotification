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

let kOnVersion:Float = (UIDevice.currentDevice().systemVersion).floatValue

let _PKNotificationCache = PKNotificationSingleton()

// MARK: - @CLASS PKNotificationSingleton
class PKNotificationSingleton  {
    
    var vcCache:NSCache = NSCache()
    var progressVC:PKProgress? = nil
    var loadingBackgroundView:UIView? = nil

}

// MARK: - @CLASS PKNotification
class PKNotification: UIViewController {
    
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
        //TODO: Implement
    }

    func toast(message m:String!) {
        let bgView = generateBackground(color: UIColor.clearColor(), uiEnabled:false)
        let toastVC = PKToast(message:m)
        _PKNotificationCache.vcCache.setObject(toastVC, forKey: toastVC)

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
                                                    _PKNotificationCache.vcCache.removeObjectForKey(toastVC)
                                             })
                        })
        
    }
    
    func loading(flag:Bool) {
        let isLoading:Bool = !(_PKNotificationCache.progressVC == nil)
        if(flag && !isLoading){
            let bgView:UIView = generateBackground(color: UIColor.clearColor(), uiEnabled:true)
            let progressVC:PKProgress = PKProgress(PKProgressType.Loading, nil)
            _PKNotificationCache.progressVC = progressVC
            
            bgView.addSubview(_PKNotificationCache.progressVC!.view)
            _PKNotificationCache.loadingBackgroundView = bgView
            UIApplication.sharedApplication().windows[0].addSubview(_PKNotificationCache.loadingBackgroundView!)
        } else if(!flag && isLoading) {
            _PKNotificationCache.loadingBackgroundView?.removeFromSuperview()
            _PKNotificationCache.progressVC = nil
            _PKNotificationCache.loadingBackgroundView = nil
        }
    }
    
    func success(message:String?) {
        let isShowing:Bool = !(_PKNotificationCache.progressVC == nil)
        if(!isShowing){
            let bgView:UIView = generateBackground(color: UIColor.clearColor(), uiEnabled:true)
            let progressVC:PKProgress = PKProgress(PKProgressType.Success, message)
            _PKNotificationCache.progressVC = progressVC
            
            bgView.addSubview(_PKNotificationCache.progressVC!.view)
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
                            _PKNotificationCache.progressVC = nil
                    })
            })
        }
    }
    
    func failed(message:String?) {
        let isShowing:Bool = !(_PKNotificationCache.progressVC == nil)
        if(!isShowing){
            let bgView:UIView = generateBackground(color: UIColor.clearColor(), uiEnabled:true)
            let progressVC:PKProgress = PKProgress(PKProgressType.Failed, message)
            _PKNotificationCache.progressVC = progressVC
            
            bgView.addSubview(_PKNotificationCache.progressVC!.view)
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
                            _PKNotificationCache.progressVC = nil
                    })
            })
        }
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
}

// MARK: - @CLASS PKAlert
class PKAlert: UIViewController {
    //TODO: Implement
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
        posX = kMargin
        posY = rectBounds.size.height - kMargin - kHeight
        width = rectBounds.size.width - kMargin * 2
        height = kHeight
        let rectToast:CGRect = CGRectMake(posX, posY, width, height)
        toastView.frame = rectToast
        messageLabel.frame = CGRectMake(0, 0, rectToast.width, rectToast.height)
        
        toastView.backgroundColor = UIColor.darkGrayColor()
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
    
    let kMargin:CGFloat = 5
    let kHeight:CGFloat = 110
    let kWidth:CGFloat = 110
    let kAlpha:CGFloat = 0.8
    let kRadious:CGFloat = 12
    let kLabelHeight:CGFloat = 40
    let backgroundColorLoading:UIColor = UIColor.darkGrayColor()
    let backgroundColorSuccess:UIColor = UIColor.darkGrayColor()
    let backgroundColorFailed:UIColor = UIColor.darkGrayColor()
    let fontColor:UIColor = UIColor.whiteColor()
    let fontStyle:UIFont = UIFont.boldSystemFontOfSize(14)
    let rectBounds:CGRect = UIScreen.mainScreen().bounds
    
    let activeIndicatorStyle:UIActivityIndicatorViewStyle = UIActivityIndicatorViewStyle.WhiteLarge
    let successImage:UIImage? = nil //if it's nil, set default image automatically
    let failedImage:UIImage? = nil //if it's nil, set default image automatically
    
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
        let loadingView:UIView = UIView(frame: CGRectMake((rectBounds.width - kWidth)/2, (rectBounds.height - kHeight)/2, kWidth, kHeight))
        var ai:UIActivityIndicatorView = UIActivityIndicatorView() as UIActivityIndicatorView
        ai.center = loadingView.center
        ai.activityIndicatorViewStyle = activeIndicatorStyle
        ai.hidesWhenStopped = true
        ai.startAnimating()
        loadingView.backgroundColor = backgroundColorLoading
        loadingView.alpha = kAlpha
        loadingView.layer.cornerRadius = kRadious
        self.view.addSubview((kOnVersion < 8.0) ? rotate(loadingView) : loadingView)
        self.view.addSubview((kOnVersion < 8.0) ? rotate(ai) : ai)
    }
    
    func generateSuccess(m:String?){
        let successView:UIView = UIView(frame: CGRectMake((rectBounds.width - kWidth)/2, (rectBounds.height - kHeight)/2, kWidth, kHeight))
        let imagePosY:CGFloat = (m == nil) ? (rectBounds.height - kHeight)/2 + kMargin : (rectBounds.height - kHeight)/2 - kMargin
        let imageView:UIImageView = UIImageView(frame: CGRectMake((rectBounds.width - kWidth)/2 + kMargin, imagePosY, successView.frame.width - kMargin*2, successView.frame.height - kMargin*2))
        let messageLabel:UILabel = UILabel()
        imageView.image = (successImage == nil ? generateImageDefaultSuccess() : successImage)
        imageView.contentMode = UIViewContentMode.ScaleAspectFit
        successView.backgroundColor = backgroundColorSuccess
        successView.alpha = kAlpha
        successView.layer.cornerRadius = kRadious
        messageLabel.frame = CGRectMake(0, successView.frame.height-kLabelHeight, successView.frame.width, kLabelHeight)
        messageLabel.font = fontStyle
        messageLabel.textColor = fontColor
        messageLabel.textAlignment = NSTextAlignment.Center
        messageLabel.text = m
        successView.addSubview(messageLabel)
        self.view.addSubview((kOnVersion < 8.0) ? rotate(successView) : successView)
        self.view.addSubview((kOnVersion < 8.0) ? rotate(imageView) : imageView)
    }
    
    func generateFailed(m:String?){
        let failedView:UIView = UIView(frame: CGRectMake((rectBounds.width - kWidth)/2, (rectBounds.height - kHeight)/2, kWidth, kHeight))
        let imagePosY:CGFloat = (m == nil) ? (rectBounds.height - kHeight)/2 + kMargin : (rectBounds.height - kHeight)/2 - kMargin
        let imageView:UIImageView = UIImageView(frame: CGRectMake((rectBounds.width - kWidth)/2 + kMargin, imagePosY, failedView.frame.width - kMargin*2, failedView.frame.height - kMargin*2))
        let messageLabel:UILabel = UILabel()
        imageView.image = (failedImage == nil ? generateImageDefaultFailed() : failedImage)
        failedView.backgroundColor = backgroundColorFailed
        failedView.alpha = kAlpha
        failedView.layer.cornerRadius = kRadious
        messageLabel.frame = CGRectMake(0, failedView.frame.height-kLabelHeight, failedView.frame.width, kLabelHeight)
        messageLabel.font = fontStyle
        messageLabel.textColor = fontColor
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
        let base64Str:String = "iVBORw0KGgoAAAANSUhEUgAAALQAAAC0CAYAAAA9zQYyAAAABmJLR0QAAAAAAAD5Q7t/AAAACXBIWXMAAAsTAAALEwEAmpwYAAAAB3RJTUUH3gwZCgg6D0P0hwAAAcxJREFUeNrt1zFKA2EUhdFf1+BKhPQWYpfSldimsHQt7sVCsBL3EQLCtYmQLhPT/LmeA+mmCG8+HvPGAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAADgP0tyl+TeJGiIeZ3kLclHkkcToSHmX6KmJmZRUxezqKmL+TDqikPx2mvvjXmM8TzGuF3w+G6M8W1qXPpmzv65takhZhAziBkxixkxg5hBzCBmxCxmxAxihsUxr5LsFsa8S7IyNWxmEDOIGTGLGQcg2MzMGcdVkhsx0xLzQ5LXS3jxYmZJzO8HAazETEPMh8fTesL/6wDk5Jin3G42M+fEPFUYYuZYIDf7A3D6QMRMTShi5i/B7GYMxgHIOeFMtQVtZmoCEjM1IYmZmqDETM2hKGZqDkUxU/P5IWZqohYzNVGLmZqoxUxN1GKmJmoxUxO1mGmK+mv/EzM1UYuZfxW1mKmJWszURC1mpo7684SYP8XM7FFvkmwXxLxNsjExLiHqlyNRb5O8mBQNUYuZmqjFTE3UYqYm6qckTyYBAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA1PsB8rC7dbwP0W4AAAAASUVORK5CYII="
        let imgData:NSData = NSData(base64EncodedString: base64Str, options: NSDataBase64DecodingOptions.IgnoreUnknownCharacters)!
        let image:UIImage = UIImage(data: imgData)!
        
        return image
    }
    
    func generateImageDefaultFailed() -> UIImage {
        let base64Str:String = "iVBORw0KGgoAAAANSUhEUgAAALQAAAC0CAYAAAA9zQYyAAAABmJLR0QAAAAAAAD5Q7t/AAAACXBIWXMAAAsTAAALEwEAmpwYAAAAB3RJTUUH3gwZCgguFZkg+gAAA9JJREFUeNrt3U2IVWUYB/D/qwVpUxLpFKUZRZtoEZlGpe5dtB+H0IVta2+2EEYCF7lwJ7RwEdaulbQW+kBo0SLaRNEYfaiFWSZB2dOi06KYGa/XvB9nfj+4m8M8M+f5uOe8970HJgEAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAABujaqaqaq9VXW6qi53r9PdsZke5ru2qrZX1YmqutC9TnTH1pqI6W7u3rq+vT3Kd/sA+W43GdPZ3IUa3EIP8t13A/nuMyH9uzL35ko94JV5VVypWx/XzEl+GTL8rtbalWlbMyf5Y8jw21pr1/rU/zU9fJO+MKbYcXlqTLEGekReHFPsuLw0plhLjhHdgi8nuXvI8J9baxumLN8LSTYNGX6xtTbrCg0GemTeH1PsuLw7plgDPSJvjSl2XN4cU6w19IjWlLbtBmfbbuLfoX8P5PwQofPTNsxdvteS7BgidEffhrnXfPXtq+8+DrWHkzyc1L81tcdHPT4KAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAPzPmhIMp6pakvVJ7k3yQJKHkmxN8nCSLd2xjUnu6X5uTZI/k1xNcinJD0m+TfJ1kq+SLCY51x37McnV1lqptIG+VcM7m+TxJM8n2ZPkuRH86Q+TvJfkgySfJblgyA30sEO8KcmzSeaSTNI/53w7yTtJPmqtXdQpVhriLVX1clWdr+lwvjvfLbrHP0M8U1VzVXWuptu5Lo8ZXV2dg7y5qo5VPx2rqs3W0KtjkLcmeT3J/E3+qvNJPk/yZbdD8U2S75Nc7HYxLif5NclvSX5PUl29b09yR5I7k2zodkE2Jbk/yYPdTskjSR5Lct9NnuOpJK+21hYNdP8G+Z4kh5O8MkT4F0nOJvk4ySdJPh3FB7Lug+kTSZ5M8nSSZ5I8OsSvOp7kcGvtkntzP4Z57gZv2d9V1cmq2tdd0SfqDtOd18nuPG/EnGmY7kGeraozAzZ7sareqKrdU5bj7u68FwfM80xVzZqO6RvmXQM2+FRV7elJznu6fAaxy5RMT2MPXKeZP1XVkb7u33b76Ue6PFdywLRMfjMPrdDAK1X1WlWtXyW1WN/le2WFmhwyNZPbwIMrNO54VW1cpXXZ2OW/nIOmZ/Katn+ZZp21XvzX54qzy9RpvwpNTqO2LdOko6qzZL2OLlOvbaoz/uasW6Ix16pqXnVWrNt8V6f/Wqc6423MwhJPoO1UmYFqt3OJJwsXVAYAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAIC++wszTf1Eb5pZVwAAAABJRU5ErkJggg=="
        let imgData:NSData = NSData(base64EncodedString: base64Str, options: NSDataBase64DecodingOptions.IgnoreUnknownCharacters)!
        let image:UIImage = UIImage(data: imgData)!
        
        return image
    }

}


