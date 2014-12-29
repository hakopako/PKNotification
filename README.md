PKNotification
==============
Simple and customizable notification functions(Toast, Progress, Loading and Alert) in Swift.  
Target: iOS7 or later
  
  
# v0.0.2
functions  
- Alert  
- Toast message  
- Progress(Success, Failed, Loading)  
   

# UI
<img src="https://raw.githubusercontent.com/hakopako/PKNotification/master/PKNotificationExample/images.png">

# How to use
1. Add `PKNotification/PKNotification.swift` into your project.
2. There is a global variable named `PKNotification`. Use the variable and call methods like so
```swift
//alert 
//-- simple 
PKNotification.alert(
    title: "Success !!",
    message: "Foooooooooooooo\nDisplay this default style pop up view.\nBaaaaaar",
    items: nil,
    cancelButtonTitle: "O K",
    tintColor: nil)

//-- optional
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
  
  
//toast
PKNotification.toast(message:"hogehogehogehoge")

//progress
PKNotification.loading(true)
PKNotification.loading(false)
PKNotification.success(nil)
PKNotification.failed("Foo")
```

* success(), failed() have default images in `PKNotification/PKNotification.swift`

# incoming improvements
- fix architecture to customize UI easily
- fix rotate
  
  
# MIT License

```
Copyright (c) 2014 hakopako.

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
```

History
=======
# v0.0.1
- Toast message
- Progress(Success, Failed, Loading)

