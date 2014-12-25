PKNotification
==============
Simple and customizable notification functions(Toast, Progress, Loading and Alert) in Swift.  
Target: iOS7 or later
  
  
# v0.0.1
- Toast message
- Progress(Success, Failed, Loading)
  
# UI Screenshots
<img src="https://raw.githubusercontent.com/hakopako/PKNotification/master/PKNotificationExample/Toast.png">
<img src="https://raw.githubusercontent.com/hakopako/PKNotification/master/PKNotificationExample/Loading.png">
<img src="https://raw.githubusercontent.com/hakopako/PKNotification/master/PKNotificationExample/Success.png">
<img src="https://raw.githubusercontent.com/hakopako/PKNotification/master/PKNotificationExample/Failed.png">

# How to use
1. Add `PKNotification/PKNotification.swift` into your project.
2. Call methods like so
```swift
//alert - not implemented yet :(
//PKNotification().alert()

//toast
PKNotification().toast(message:"hogehogehogehoge")

//progress
PKNotification().loading(true)
PKNotification().loading(false)
PKNotification().success(nil)
PKNotification().failed("Foo")
```

* success(), failed() have default images in `PKNotification/PKNotification.swift`
  
  
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

