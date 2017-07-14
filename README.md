<p align="center">
    <img width="900px" src="banner.png">
</p>

<p align="center">
<img src="http://img.shields.io/travis/Antoine van der Lee/UINotifications.svg?style=flat"/>
<img src="https://img.shields.io/cocoapods/v/UINotifications.svg?style=flat"/>
<img src="https://img.shields.io/cocoapods/l/UINotifications.svg?style=flat"/>
<img src="https://img.shields.io/cocoapods/p/UINotifications.svg?style=flat"/>
<img src="https://img.shields.io/badge/License-MIT-yellow.svg?style=flat"/>
</p>

- [Features](#features)
- [Example](#example)
- [Requirements](#requirements)
- [Communication](#communication)
- [Installation](#installation)
- [License](#license)

## Features
- [x] Present your own custom view easily as an in-app Notification
- [x] Create custom presentation styles
- [x] Update content during presentation

## Example

To run the example project, clone the repo, and open `UINotifications-Example.xcodeproj` from the Example directory.

![Albums list](Assets/succes_notification.png?raw=true)
![Camera Roll](Assets/failure_notification.png?raw=true)

## Requirements
- Swift 3.0, 3.1, 3.2
- iOS 8.0+
- Xcode 8.1, 8.2, 8.3

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

> CocoaPods 1.1.0+ is required to build Alamofire 4.0.0+.

To integrate Alamofire into your Xcode project using CocoaPods, specify it in your `Podfile`:

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

### Swift Package Manager

The [Swift Package Manager](https://swift.org/package-manager/) is a tool for automating the distribution of Swift code and is integrated into the `swift` compiler. It is in early development, but UINotifications does support its use on supported platforms. 

Once you have your Swift package set up, adding UINotifications as a dependency is as easy as adding it to the `dependencies` value of your `Package.swift`.

```swift
dependencies: [
    .Package(url: "https://github.com/WeTransfer/UINotifications.git", majorVersion: 1)
]
```

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

## License

UINotifications is available under the MIT license. See the LICENSE file for more info.
