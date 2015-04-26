PKNotification
==============
Simple and customizable notification functions(Toast, Progress, Loading and Alert) in Swift.  
Target: iOS7 or later
  
Feel free to send me your feedback and PR.  

### v0.1.1
- fixed error with Xcode6.3
  

# UI
<img src="https://raw.githubusercontent.com/hakopako/PKNotification/master/PKNotificationExample/PKNotification.gif">
<img src="https://raw.githubusercontent.com/hakopako/PKNotification/master/PKNotificationExample/images.png">

# How to use
1. Add `PKNotification/PKNotification.swift` into your project.  
2. There is a global variable named `PKNotification`. Use the variable and call methods like so  

### alert

simple alert (title, message and dissmiss button)

```swift 
PKNotification.alert(
    title: "Success !!",
    message: "Foooooooooooooo\nDisplay this default style pop up view.\nBaaaaaar",
    items: nil,
    cancelButtonTitle: "O K",
    tintColor: nil)
```

optional alert (title, message, dissmiss button and other buttons with actions)

```swift
// create button 
let foo:PKButton = PKButton(title: "Foo",
                            action: { (messageLabel, items) -> Bool in
                                        NSLog("Foo is clicked.")
                                        return true
                            },
                            fontColor: UIColor(red: 0, green: 0.55, blue: 0.9, alpha: 1.0),
                            backgroundColor: nil)

// call alert
PKNotification.alert(
    title: "Notice",
    message: "Foooooooooooooo\nDisplay this default style pop up view.\nBaaaaaar",
    items: [foo],
    cancelButtonTitle: "Cancel",
    tintColor: nil)
```

with UITextField alert (ex. login form)

```swift
// init textfields
let email:UITextField = UITextField()
email.placeholder = "email@host.com"
let passwd:UITextField = UITextField()
passwd.placeholder = "password"

// create login button
let foo:PKButton = PKButton(title: "Login",
    action: { (messageLabel, items) -> Bool in
        let tmpEmail: UITextField = items[0] as UITextField //items index number
        let tmpPassed: UITextField = items[1] as UITextField //items index number
        
        if (tmpEmail.text == "" || tmpPassed.text == ""){
            messageLabel?.text = "sorry, please check email and pass again."
            return false
        }
        return true
    },
    fontColor: UIColor(red: 0, green: 0.55, blue: 0.9, alpha: 1.0),
    backgroundColor: nil)

// call alert
PKNotification.alert(
    title: "Login",
    message: "Welcome to example.\nThis is a simple login form.",
    items: [email, passwd, foo],
    cancelButtonTitle: "Cancel",
    tintColor: nil)

```



__custom__

```swift
PKNotification.alertWidth   //CGFloat 
PKNotification.alertMargin  //CGFloat
PKNotification.alertTitleFontColor    //UIColor
PKNotification.alertTitleFontStyle    //UIFont
PKNotification.alertMessageFontColor  //UIColor
PKNotification.alertMEssageFontStyle  //UIFont
PKNotification.alertButtonFontColor   //UIColor
PKNotification.alertBackgroundColor   //UIColor
PKNotification.alertCornerRadius      //CGFloat

```



### toast

```swift
PKNotification.toast("hogehogehogehoge")
```

__custom__

```swift
PKNotification.toastMargin   //CGFloat
PKNotification.toastHeight   //CGFloat
PKNotification.toastAlpha    //CGFloat
PKNotification.toastRadious  //CGFloat
PKNotification.toastBackgroundColor  //UIColor
PKNotification.toastFontColor  //UIColor
PKNotification.toastFontStyle  //UIFont

```

### progress

```swift
PKNotification.loading(true)  // show loading view.
PKNotification.loading(false) // hide loading view.
PKNotification.success(nil)   // show default success image.
PKNotification.failed("Foo")  // show default failed image with message.
```

* success(), failed() have default images in `PKNotification/PKNotification.swift`
  
  
__custom__

```swift
PKNotification.loadingBackgroundColor       //UIColor
PKNotification.loadingActiveIndicatorStyle  //UIActivityIndicatorViewStyle
PKNotification.successBackgroundColor       //UIColor
PKNotification.successImage  //UIImage *if it's nil, set default image automatically
PKNotification.failedBackgroundColor        //UIColor
PKNotification.failedImage   //UIImage *if it's nil, set default image automatically

```

# incoming improvements
- add more default images
- fix rotate for ios7
- fix texifield actions
  
  
# License

MIT


# History
### v0.1.0
- fixed device rotate for ios8
- able to add UITextField on Alert
- fixed dismiss action of alert.

### v0.0.3
- fix architecture to customize UI easier

### v0.0.1
- Toast message
- Progress(Success, Failed, Loading)

