<img src="https://img.shields.io/badge/version-v1.0-green.svg"> <img src="https://img.shields.io/badge/license-MIT-lightgray.svg"> <img src="https://img.shields.io/badge/Target-iOS8%20or%20later-blue.svg">  
  
PKNotification
==============
Simple and customizable notification functions in Swift.

- Alert
- ActionSheet
- Toast
- Loading
- Success
- Failed

Feel free to send me your feedback and PR.  

# UI
<img src="https://raw.githubusercontent.com/hakopako/PKNotification/master/Demo/Images/PKNotification.gif">
<img src="https://raw.githubusercontent.com/hakopako/PKNotification/master/Demo/Images/PKNotification.png">

# How to use

## Manually
Add `PKNotification/PKNotification.swift` into your project.  


## Carthage
`github "hakopako/PKNotification"`  


## CocoaPods
```
platform :ios, '8.0'
use_frameworks!
pod 'PKNotification', '~> 1.0'
```  
  
There is a global variable named `PKNotification`. Use the variable and call methods.  
For more details, see [http://hakopako.github.io/PKNotification/](http://hakopako.github.io/PKNotification/)  


# History

### v1.0

- update to Xcode7.x
- update target to iOS8 or later
- add actionsheet function.
- adapt to CocoaPods and Carthage.

### v0.2.0
- fixed alert with textfield   
- will be  added default images (not yet..  

### v0.1.1
- fixed error with Xcode6.3

### v0.1.0
- fixed device rotate for ios8
- able to add UITextField on Alert
- fixed dismiss action of alert.

### v0.0.3
- fix architecture to customize UI easier

### v0.0.1
- Toast message
- Progress(Success, Failed, Loading)

