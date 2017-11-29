<p align="center">
    <img width="900px" src="Assets/artwork.jpg">
</p>

<p align="center">
<img src="https://travis-ci.com/WeTransfer/UINotifications.svg?token=Ur5V2zzKmBJLmMYHKJTF&branch=master"/>
<img src="https://img.shields.io/cocoapods/v/UINotifications.svg?style=flat"/>
<img src="https://img.shields.io/cocoapods/l/UINotifications.svg?style=flat"/>
<img src="https://img.shields.io/cocoapods/p/UINotifications.svg?style=flat"/>
<img src="https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat"/>
<img src="https://img.shields.io/badge/License-MIT-yellow.svg?style=flat"/>
</p>

- [Features](#features)
- [Example](#example)
- [Requirements](#requirements)
- [Usage](#usage)
    - [Making a Notification](#making-a-notification)
    - [Create a custom style](#create-a-custom-style)
    - [Use a custom dismiss trigger](#use-a-custom-dismiss-trigger)
    - [Create a custom UINotificationView](#create-a-custom-uinotificationview)
    - [Create a custom presenter](#create-a-custom-presenter)
- [Communication](#communication)
- [Installation](#installation)
- [Release Notes](#release-notes)
- [License](#license)

## Features
- [x] Present your own custom view easily as an in-app Notification
- [x] Create custom presentation styles
- [x] Update content during presentation

## Example

To run the example project, clone the repo, and open `UINotifications-Example.xcodeproj` from the Example directory.

| Success styling        | Failure styling       |
| ------------- |:-------------:|
| ![Success](Assets/success_notification.jpg?) | ![Failure](Assets/fail_notification.jpg?) |

## Requirements
- Swift 3.0, 3.1, 3.2
- iOS 8.0+
- Xcode 8.1, 8.2, 8.3

## Usage

### Making a Notification

```swift
import UINotifications

let content = UINotificationContent(title: "My Custom Text", subtitle: "My subtitle", image: UIImage(named: "MyImage"))
let notification = UINotification(content: content, action: UINotificationCallbackAction(callback: {
    print("Tapped the notification!")
}))

let dismissTrigger = UINotificationDurationDismissTrigger(duration: 2.0)
UINotificationCenter.current.show(notification: notification, dismissTrigger: dismissTrigger)
```

### Create a custom style
```swift
import UINotifications

enum CustomNotificationStyle: UINotificationStyle {
    case success
    case failure
    
    var titleFont: UIFont {
        switch self {
        case .success:
            return .systemFont(ofSize: 15, weight: .semibold)
        case .failure:
            return .systemFont(ofSize: 13, weight: .regular)
        }
    }
    
    var subtitleFont: UIFont {
        return .systemFont(ofSize: 13, weight: .regular)
    }
    
    var titleTextColor: UIColor {
        switch self {
        case .success:
            return .black
        case .failure:
            return .white
        }
    }
    
    var subtitleTextColor: UIColor {
        return .darkGray
    }
    
    var backgroundColor: UIColor {
        switch self {
        case .success:
            return #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        case .failure:
            return #colorLiteral(red: 1, green: 0.431372549, blue: 0.431372549, alpha: 1)
        }
    }
    
    /// The height of the notification which applies on the notification view.
    var height: UINotificationHeight {
        switch self {
        case .success:
            return UINotificationHeight.navigationBar
        case .failure:
            return UINotificationHeight.statusBar
        }
    }
    
    /// When `true`, the notification is swipeable and tappable.
    var interactive: Bool {
        return true
    }
    
    var chevronImage: UIImage? {
        return #imageLiteral(resourceName: "iconToastChevron")
    }
}
```

And use it:

```swift
let notification = UINotification(content: myContent, style: CustomNotificationStyle.success)
```

### Use a custom dismiss trigger

```swift
let manualDismissTrigger = UINotificationManualDismissTrigger()
UINotificationCenter.current.show(notification: notification, dismissTrigger: manualDismissTrigger)

/// Do other stuff..

manualDismissTrigger.trigger() // Dismiss
```

### Create a custom UINotificationView
- Create a custom view and inherit from `UINotificationView`
- Set your custom view on the `UINotificationCenter`:

```swift
UINotificationCenter.current.notificationViewType = MyCustomNotificationView.self
```

### Create a custom presenter
Create a custom presenter to manage presentation and dismiss animations.

- Create a custom class which inherits from `UINotificationPresenter`.
- Set your custom presenter on the `UINotificationCenter`:

```swift
UINotificationCenter.current.presenterType = MyCustomPresenter.self
```

*Checkout `UINotificationEaseOutEaseInPresenter` for an example.*

### Allow duplicate requests
By default, notifications which are already queued will not be queued again. This is to prevent an endless loop of notifications being presented if they occur quickly after each other.

To disable this setting:

```swift
UINotificationCenter.current.isDuplicateQueueingAllowed = true
```

## Communication

- If you **found a bug**, open an issue.
- If you **have a feature request**, open an issue.
- If you **want to contribute**, submit a pull request.

## Installation

### CocoaPods

[CocoaPods](http://cocoapods.org) is a dependency manager for Cocoa projects. You can install it with the following command:

```bash
$ gem install cocoapods
```

To integrate UINotifications into your Xcode project using CocoaPods, specify it in your `Podfile`:

```ruby
source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '10.0'
use_frameworks!

target '<Your Target Name>' do
    pod 'UINotifications', '~> 1.0.0'
end
```

Then, run the following command:

```bash
$ pod install
```

### Carthage

[Carthage](https://github.com/Carthage/Carthage) is a decentralized dependency manager that builds your dependencies and provides you with binary frameworks.

You can install Carthage with [Homebrew](http://brew.sh/) using the following command:

```bash
$ brew update
$ brew install carthage
```

To integrate UINotifications into your Xcode project using Carthage, specify it in your `Cartfile`:

```ogdl
github "WeTransfer/UINotifications" ~> 1.00
```

Run `carthage update` to build the framework and drag the built `UINotifications.framework` into your Xcode project.

### Manually

If you prefer not to use any of the aforementioned dependency managers, you can integrate UINotifications into your project manually.

#### Embedded Framework

- Open up Terminal, `cd` into your top-level project directory, and run the following command "if" your project is not initialized as a git repository:

  ```bash
  $ git init
  ```

- Add UINotifications as a git [submodule](http://git-scm.com/docs/git-submodule) by running the following command:

  ```bash
  $ git submodule add https://github.com/WeTransfer/UINotifications.git
  ```

- Open the new `UINotifications ` folder, and drag the `UINotifications.xcodeproj` into the Project Navigator of your application's Xcode project.

    > It should appear nested underneath your application's blue project icon. Whether it is above or below all the other Xcode groups does not matter.

- Select the `UINotifications.xcodeproj` in the Project Navigator and verify the deployment target matches that of your application target.
- Next, select your application project in the Project Navigator (blue project icon) to navigate to the target configuration window and select the application target under the "Targets" heading in the sidebar.
- In the tab bar at the top of that window, open the "General" panel.
- Click on the `+` button under the "Embedded Binaries" section.
- Select `UINotifications.framework`.
- And that's it!

  > The `UINotifications.framework` is automagically added as a target dependency, linked framework and embedded framework in a copy files build phase which is all you need to build on the simulator and a device.

---

## Release Notes

See [CHANGELOG.md](https://github.com/WeTransfer/UINotifications/blob/master/Changelog.md) for a list of changes.

## License

UINotifications is available under the MIT license. See the LICENSE file for more info.
