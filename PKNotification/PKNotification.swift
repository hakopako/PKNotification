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
        
    }

    func toast(message m:String!, style s:PKNotifications?) {
        let bgView = generateBackground(color: UIColor.clearColor(), uiEnabled:false)
        let toastVC = PKToast(message:m, style:s)
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
            let progressVC:PKProgress = PKProgress(PKProgressType.Loading)
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
    
    func success() {
        let isShowing:Bool = !(_PKNotificationCache.progressVC == nil)
        if(!isShowing){
            let bgView:UIView = generateBackground(color: UIColor.clearColor(), uiEnabled:true)
            let progressVC:PKProgress = PKProgress(PKProgressType.Success)
            _PKNotificationCache.progressVC = progressVC
            
            bgView.addSubview(_PKNotificationCache.progressVC!.view)
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
                            _PKNotificationCache.progressVC = nil
                    })
            })
        }
    }
    
    func failed() {
        let isShowing:Bool = !(_PKNotificationCache.progressVC == nil)
        if(!isShowing){
            let bgView:UIView = generateBackground(color: UIColor.clearColor(), uiEnabled:true)
            let progressVC:PKProgress = PKProgress(PKProgressType.Failed)
            _PKNotificationCache.progressVC = progressVC
            
            bgView.addSubview(_PKNotificationCache.progressVC!.view)
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
    
    let kMargin:CGFloat = 20
    let kHeight:CGFloat = 90
    let kWidth:CGFloat = 90
    let kAlpha:CGFloat = 0.6
    let kRadious:CGFloat = 12
    let backgroundColor:UIColor = UIColor.blackColor()
    let fontColor:UIColor = UIColor.whiteColor()
    let fontStyle:UIFont = UIFont.systemFontOfSize(15)
    let rectBounds:CGRect = UIScreen.mainScreen().bounds
    
    let activeIndicatorStyle:UIActivityIndicatorViewStyle = UIActivityIndicatorViewStyle.WhiteLarge
    let successImage:UIImage? = nil //if it's nil, set default image automatically
    let failedImage:UIImage? = nil //if it's nil, set default image automatically
    
    // MARK: - Lifecycle
    init(_ type:PKProgressType) {
        super.init()
        switch(type){
            case .Loading:
                generateLoading()
                break
            case .Success:
                generateSuccess()
                break
            case .Failed:
                generateFailed()
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
    func generateLoading(){
        let loadingView:UIView = UIView(frame: CGRectMake((rectBounds.width - kWidth)/2, (rectBounds.height - kHeight)/2 - kMargin, kWidth, kHeight))
        var ai:UIActivityIndicatorView = UIActivityIndicatorView() as UIActivityIndicatorView
        ai.center = loadingView.center
        ai.activityIndicatorViewStyle = activeIndicatorStyle
        ai.hidesWhenStopped = true
        ai.startAnimating()
        loadingView.backgroundColor = backgroundColor
        loadingView.alpha = kAlpha
        loadingView.layer.cornerRadius = kRadious
        self.view.addSubview((kOnVersion < 8.0) ? rotate(loadingView) : loadingView)
        self.view.addSubview((kOnVersion < 8.0) ? rotate(ai) : ai)
    }
    
    func generateSuccess(){
        let successView:UIView = UIView(frame: CGRectMake((rectBounds.width - kWidth)/2, (rectBounds.height - kHeight)/2 - kMargin, kWidth, kHeight))
        let imageView:UIImageView = UIImageView(image: (successImage == nil ? generateImageDefaultSuccess() : successImage))
        imageView.center = successView.center
        successView.backgroundColor = UIColor.blackColor()
        successView.alpha = kAlpha
        successView.layer.cornerRadius = kRadious
        self.view.addSubview((kOnVersion < 8.0) ? rotate(successView) : successView)
        self.view.addSubview((kOnVersion < 8.0) ? rotate(imageView) : imageView)
    }
    
    func generateFailed(){
        let failedView:UIView = UIView(frame: CGRectMake((rectBounds.width - kWidth)/2, (rectBounds.height - kHeight)/2 - kMargin, kWidth, kHeight))
        let imageView:UIImageView = UIImageView(image: (successImage == nil ? generateImageDefaultFailed() : successImage))
        imageView.center = failedView.center
        failedView.backgroundColor = UIColor.blackColor()
        failedView.alpha = kAlpha
        failedView.layer.cornerRadius = kRadious
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
        let base64Str:String = "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"
        let imgData:NSData = NSData(base64EncodedString: base64Str, options: NSDataBase64DecodingOptions.IgnoreUnknownCharacters)!
        let image:UIImage = UIImage(data: imgData)!
        
        return image
    }
    
    func generateImageDefaultFailed() -> UIImage {
        let base64Str:String = "iVBORw0KGgoAAAANSUhEUgAAACgAAAApCAYAAABHomvIAAAKQWlDQ1BJQ0MgUHJvZmlsZQAASA2dlndUU9kWh8+9N73QEiIgJfQaegkg0jtIFQRRiUmAUAKGhCZ2RAVGFBEpVmRUwAFHhyJjRRQLg4Ji1wnyEFDGwVFEReXdjGsJ7601896a/cdZ39nnt9fZZ+9917oAUPyCBMJ0WAGANKFYFO7rwVwSE8vE9wIYEAEOWAHA4WZmBEf4RALU/L09mZmoSMaz9u4ugGS72yy/UCZz1v9/kSI3QyQGAApF1TY8fiYX5QKUU7PFGTL/BMr0lSkyhjEyFqEJoqwi48SvbPan5iu7yZiXJuShGlnOGbw0noy7UN6aJeGjjAShXJgl4GejfAdlvVRJmgDl9yjT0/icTAAwFJlfzOcmoWyJMkUUGe6J8gIACJTEObxyDov5OWieAHimZ+SKBIlJYqYR15hp5ejIZvrxs1P5YjErlMNN4Yh4TM/0tAyOMBeAr2+WRQElWW2ZaJHtrRzt7VnW5mj5v9nfHn5T/T3IevtV8Sbsz55BjJ5Z32zsrC+9FgD2JFqbHbO+lVUAtG0GQOXhrE/vIADyBQC03pzzHoZsXpLE4gwnC4vs7GxzAZ9rLivoN/ufgm/Kv4Y595nL7vtWO6YXP4EjSRUzZUXlpqemS0TMzAwOl89k/fcQ/+PAOWnNycMsnJ/AF/GF6FVR6JQJhIlou4U8gViQLmQKhH/V4X8YNicHGX6daxRodV8AfYU5ULhJB8hvPQBDIwMkbj96An3rWxAxCsi+vGitka9zjzJ6/uf6Hwtcim7hTEEiU+b2DI9kciWiLBmj34RswQISkAd0oAo0gS4wAixgDRyAM3AD3iAAhIBIEAOWAy5IAmlABLJBPtgACkEx2AF2g2pwANSBetAEToI2cAZcBFfADXALDIBHQAqGwUswAd6BaQiC8BAVokGqkBakD5lC1hAbWgh5Q0FQOBQDxUOJkBCSQPnQJqgYKoOqoUNQPfQjdBq6CF2D+qAH0CA0Bv0BfYQRmALTYQ3YALaA2bA7HAhHwsvgRHgVnAcXwNvhSrgWPg63whfhG/AALIVfwpMIQMgIA9FGWAgb8URCkFgkAREha5EipAKpRZqQDqQbuY1IkXHkAwaHoWGYGBbGGeOHWYzhYlZh1mJKMNWYY5hWTBfmNmYQM4H5gqVi1bGmWCesP3YJNhGbjS3EVmCPYFuwl7ED2GHsOxwOx8AZ4hxwfrgYXDJuNa4Etw/XjLuA68MN4SbxeLwq3hTvgg/Bc/BifCG+Cn8cfx7fjx/GvyeQCVoEa4IPIZYgJGwkVBAaCOcI/YQRwjRRgahPdCKGEHnEXGIpsY7YQbxJHCZOkxRJhiQXUiQpmbSBVElqIl0mPSa9IZPJOmRHchhZQF5PriSfIF8lD5I/UJQoJhRPShxFQtlOOUq5QHlAeUOlUg2obtRYqpi6nVpPvUR9Sn0vR5Mzl/OX48mtk6uRa5Xrl3slT5TXl3eXXy6fJ18hf0r+pvy4AlHBQMFTgaOwVqFG4bTCPYVJRZqilWKIYppiiWKD4jXFUSW8koGStxJPqUDpsNIlpSEaQtOledK4tE20Otpl2jAdRzek+9OT6cX0H+i99AllJWVb5SjlHOUa5bPKUgbCMGD4M1IZpYyTjLuMj/M05rnP48/bNq9pXv+8KZX5Km4qfJUilWaVAZWPqkxVb9UU1Z2qbapP1DBqJmphatlq+9Uuq43Pp893ns+dXzT/5PyH6rC6iXq4+mr1w+o96pMamhq+GhkaVRqXNMY1GZpumsma5ZrnNMe0aFoLtQRa5VrntV4wlZnuzFRmJbOLOaGtru2nLdE+pN2rPa1jqLNYZ6NOs84TXZIuWzdBt1y3U3dCT0svWC9fr1HvoT5Rn62fpL9Hv1t/ysDQINpgi0GbwaihiqG/YZ5ho+FjI6qRq9Eqo1qjO8Y4Y7ZxivE+41smsImdSZJJjclNU9jU3lRgus+0zwxr5mgmNKs1u8eisNxZWaxG1qA5wzzIfKN5m/krCz2LWIudFt0WXyztLFMt6ywfWSlZBVhttOqw+sPaxJprXWN9x4Zq42Ozzqbd5rWtqS3fdr/tfTuaXbDdFrtOu8/2DvYi+yb7MQc9h3iHvQ732HR2KLuEfdUR6+jhuM7xjOMHJ3snsdNJp9+dWc4pzg3OowsMF/AX1C0YctFx4bgccpEuZC6MX3hwodRV25XjWuv6zE3Xjed2xG3E3dg92f24+ysPSw+RR4vHlKeT5xrPC16Il69XkVevt5L3Yu9q76c+Oj6JPo0+E752vqt9L/hh/QL9dvrd89fw5/rX+08EOASsCegKpARGBFYHPgsyCRIFdQTDwQHBu4IfL9JfJFzUFgJC/EN2hTwJNQxdFfpzGC4sNKwm7Hm4VXh+eHcELWJFREPEu0iPyNLIR4uNFksWd0bJR8VF1UdNRXtFl0VLl1gsWbPkRoxajCCmPRYfGxV7JHZyqffS3UuH4+ziCuPuLjNclrPs2nK15anLz66QX8FZcSoeGx8d3xD/iRPCqeVMrvRfuXflBNeTu4f7kufGK+eN8V34ZfyRBJeEsoTRRJfEXYljSa5JFUnjAk9BteB1sl/ygeSplJCUoykzqdGpzWmEtPi000IlYYqwK10zPSe9L8M0ozBDuspp1e5VE6JA0ZFMKHNZZruYjv5M9UiMJJslg1kLs2qy3mdHZZ/KUcwR5vTkmuRuyx3J88n7fjVmNXd1Z752/ob8wTXuaw6thdauXNu5Tnddwbrh9b7rj20gbUjZ8MtGy41lG99uit7UUaBRsL5gaLPv5sZCuUJR4b0tzlsObMVsFWzt3WazrWrblyJe0fViy+KK4k8l3JLr31l9V/ndzPaE7b2l9qX7d+B2CHfc3em681iZYlle2dCu4F2t5czyovK3u1fsvlZhW3FgD2mPZI+0MqiyvUqvakfVp+qk6oEaj5rmvep7t+2d2sfb17/fbX/TAY0DxQc+HhQcvH/I91BrrUFtxWHc4azDz+ui6rq/Z39ff0TtSPGRz0eFR6XHwo911TvU1zeoN5Q2wo2SxrHjccdv/eD1Q3sTq+lQM6O5+AQ4ITnx4sf4H++eDDzZeYp9qukn/Z/2ttBailqh1tzWibakNml7THvf6YDTnR3OHS0/m/989Iz2mZqzymdLz5HOFZybOZ93fvJCxoXxi4kXhzpXdD66tOTSna6wrt7LgZevXvG5cqnbvfv8VZerZ645XTt9nX297Yb9jdYeu56WX+x+aem172296XCz/ZbjrY6+BX3n+l37L972un3ljv+dGwOLBvruLr57/17cPel93v3RB6kPXj/Mejj9aP1j7OOiJwpPKp6qP6391fjXZqm99Oyg12DPs4hnj4a4Qy//lfmvT8MFz6nPK0a0RupHrUfPjPmM3Xqx9MXwy4yX0+OFvyn+tveV0auffnf7vWdiycTwa9HrmT9K3qi+OfrW9m3nZOjk03dp76anit6rvj/2gf2h+2P0x5Hp7E/4T5WfjT93fAn88ngmbWbm3/eE8/syOll+AAAACXBIWXMAAAsTAAALEwEAmpwYAAAB1WlUWHRYTUw6Y29tLmFkb2JlLnhtcAAAAAAAPHg6eG1wbWV0YSB4bWxuczp4PSJhZG9iZTpuczptZXRhLyIgeDp4bXB0az0iWE1QIENvcmUgNS40LjAiPgogICA8cmRmOlJERiB4bWxuczpyZGY9Imh0dHA6Ly93d3cudzMub3JnLzE5OTkvMDIvMjItcmRmLXN5bnRheC1ucyMiPgogICAgICA8cmRmOkRlc2NyaXB0aW9uIHJkZjphYm91dD0iIgogICAgICAgICAgICB4bWxuczp0aWZmPSJodHRwOi8vbnMuYWRvYmUuY29tL3RpZmYvMS4wLyI+CiAgICAgICAgIDx0aWZmOkNvbXByZXNzaW9uPjE8L3RpZmY6Q29tcHJlc3Npb24+CiAgICAgICAgIDx0aWZmOlBob3RvbWV0cmljSW50ZXJwcmV0YXRpb24+MjwvdGlmZjpQaG90b21ldHJpY0ludGVycHJldGF0aW9uPgogICAgICAgICA8dGlmZjpPcmllbnRhdGlvbj4xPC90aWZmOk9yaWVudGF0aW9uPgogICAgICA8L3JkZjpEZXNjcmlwdGlvbj4KICAgPC9yZGY6UkRGPgo8L3g6eG1wbWV0YT4KOXS2agAABAZJREFUWAnNmT9rFEEYxnPRBAQ5IZJCjCkUAmKICioYY5pU5gMY8wHENmCTLqXW+QRnKWgqO9sQ04gSsEghHEG4SlEbjcGsv2d33rvZf3e7m1y8B56bd95/8+7Nzs7sXW2oIoIgqBM6A+fgrJMv0AotuAO34KbkWq32k7a/oKgRuAi3YVkoRrEjx14lSYfhEvSxS2cdLsMZOAZPOUqWTjb5yNeHcg0fS6EkmoJNL3sD+X7Z5IqBijUo51TZPDF/Evjf2gb96zGHCh3lgMplWKqQZmiI6FXLQPukUpIuQcrp5V/t4po2EWjFtZBLT2c6Y7ZGuaHGEIoViaNNqwKPPKXZpXW0GgNakd2nG0ctCEPfvrlOeZHEgPomDdkLB6seJVpZwrHfc8mikn2NGY4c1ZB+BGG0qd1IBp9UnxpsdcenGoN2CEPf7zu7YAasmayWvu5HQ2fHQaMtSGj4AXkyfjWYnoacAOcfKybHVUU2oLDY9qFje2uhhYH/BLwFL7WT5Aj4nIE34VXYs0h8bMFshylR1KGwmzNGTI3fY/hdAeAHfB5z8DrY7sE9KPyBHzxzroif7d11faVzUFjPjXAGfK6EnkFw6Fpr7iDEvh36o/AzPIA+XhcYRwcMYU73kc5zwruo6fr51FljxaC7zXkvsEgSK+9lOAFPm572EGqqRz1dlmi1hAXqsCl8ipqun3s51m8JvYr9BfcTenV/w4MMva+yWmY1xU0ojPkeeTJ+dk/9DaOC4Cvt+Sx/9C+dj3zttniQ5evr8NV5UmiqwP1Q5LDpO2XJ+Gm3OQtfwY/wLbyY4xveBtifwfdwEy5k+UqHrX3bIOvgK+yXKjAveZ6eAdqD5vlk6YlrF6ibueWczmU5l9FZQdb6C6dMHnytlpYK1NuXoBV3JFhB1pZJZhflYqyWHRWoV0PhWtT8n8/ERVktWypQ763C3agp98mVa+EswBfwi6Nk6ZS/CqyWTS2SUludPxqxk7AXJv2YIjIJO1udAlCUPSyME7MGhTdQh00dlXSxomTpZBPW4HjB4uKHBVdg4eMWA81DQc/CG70GlY/zpQnmC/g35Ahix61CB1aCpsPQIFjpNVDSTtyKi51O2qyPPfvAKgeMPY/8+DyE+sGoEhSrHHnB2DagED/yKwClVmNTVpB6aUJXdUWm6snKpTGhoBqyx8IwuK+ddpkUaVPdQu77C5TGgBpLSE+tFea3OA7uTx9WqFekrix1T5pf1VY5ldih2O8yycEItulWHq2wI0+5crhcNCGKTWuyOOuTYnB/wPSK1CPoUXTB7U/tl3r7WoZ6vumYroOmKFk62eRjeytiCM1M9qPEBq3SkvTEf0SvdCTXxVFsnUa7il5bB+NvCAo5cfwDFN/r7B1CW5sAAAAASUVORK5CYII="
        let imgData:NSData = NSData(base64EncodedString: base64Str, options: NSDataBase64DecodingOptions.IgnoreUnknownCharacters)!
        let image:UIImage = UIImage(data: imgData)!
        
        return image
    }

}


