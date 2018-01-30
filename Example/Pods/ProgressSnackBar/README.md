ProgressSnackBar
=======================
Simple and clean snackbar with progress bar.

## Demo
![Example App](https://github.com/BambooCode/ProgressSnackBar/blob/master/screenshots/screenshot.png "ProgressSnackBar")

## Installation

### Cocoapods

Install Cocoapods

```bash
$ gem install cocoapods
```

Add `ProgressSnackBar` in your `Podfile`.

```ruby
use_frameworks!

pod 'ProgressSnackBar'
```

Install the pod

```bash
$ pod install
```

### Manually

Copy `ProgressSnackBar` folder to your project. Enjoy.


## Usage

### Code
- Create a new `ProgressSnackBar`
```swift

let psb = ProgressSnackBar()
psb.showWithAction("Snackbar with progress bar",
        actionTitle: "Close",
           duration: 8,
             action: {
                    print("Button is push")
                })
```
- Set the values as you like
```swift
psb.progressHeight = 30
psb.backgroundColor = .darkGray
psb.progressColor =  .lightGray
psb.buttonColor = .red
psb.textColor = .red
psb.position = .top

```
   
   That's it!

## LICENSE

ProgressSnackBar is available under the MIT license. See the LICENSE file for details.
