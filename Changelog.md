### 1.7.3
- Remove all traces of cocoapods. ([#68](https://github.com/WeTransfer/UINotifications/issues/68)) via [@kairadiagne](https://github.com/kairadiagne)
- Example app crashes when you present a notification ([#65](https://github.com/WeTransfer/UINotifications/issues/65)) via [@AvdLee](https://github.com/AvdLee)
- False warning "SwiftLint not installed" ([#66](https://github.com/WeTransfer/UINotifications/issues/66)) via [@AvdLee](https://github.com/AvdLee)

### 1.7.0
- Fix build errors for Xcode 13 beta 3 ([#58](https://github.com/WeTransfer/UINotifications/pull/58)) via [@AvdLee](https://github.com/AvdLee)
- Merge release 1.6.0 into master ([#57](https://github.com/WeTransfer/UINotifications/pull/57)) via [@wetransferplatform](https://github.com/wetransferplatform)

### 1.6.0
- Add support for presenting on window scenes ([#56](https://github.com/WeTransfer/UINotifications/pull/56)) via [@AvdLee](https://github.com/AvdLee)
- Merge release 1.5.1 into master ([#55](https://github.com/WeTransfer/UINotifications/pull/55)) via [@wetransferplatform](https://github.com/wetransferplatform)

### 1.5.1
- Fix some warnings related to `class` keyword. ([#54](https://github.com/WeTransfer/UINotifications/pull/54)) via [@kairadiagne](https://github.com/kairadiagne)
- Merge release 1.5.0 into master ([#53](https://github.com/WeTransfer/UINotifications/pull/53)) via [@wetransferplatform](https://github.com/wetransferplatform)

### 1.5.0
- Allow customizing the order of views and the image size ([#52](https://github.com/WeTransfer/UINotifications/pull/52)) via [@AvdLee](https://github.com/AvdLee)
- Merge release 1.4.1 into master ([#51](https://github.com/WeTransfer/UINotifications/pull/51)) via [@wetransferplatform](https://github.com/wetransferplatform)

### 1.4.1
- Don't make notification window key as it could conflict with the main window ([#50](https://github.com/WeTransfer/UINotifications/pull/50)) via [@kairadiagne](https://github.com/kairadiagne)

### 1.3.0
- Add Support for Button ([#48](https://github.com/WeTransfer/UINotifications/pull/48)) via @Boris-Em
- Merge release 1.2.0 into master ([#47](https://github.com/WeTransfer/UINotifications/pull/47)) via @WeTransferBot
- Migrate to Bitrise & Danger-Swift ([#46](https://github.com/WeTransfer/UINotifications/pull/46)) via @AvdLee

### 1.2.0

- Update SwiftLint, update CI, update to Swift 5.0 ([#45](https://github.com/WeTransfer/UINotifications/pull/45)) via @AvdLee
- Make sure the window frame is correct for the traitcollection ([#44](https://github.com/WeTransfer/UINotifications/pull/44)) via @AvdLee
- Use of undeclared type 'UINotificationHeight' in Example project ([#41](https://github.com/WeTransfer/UINotifications/issues/41)) via @AvdLee
- Updated to Swift 5.0 ([#42](https://github.com/WeTransfer/UINotifications/pull/42)) via @AvdLee

### 1.1
- File size of images in the repo are much smaller now.
- Tapping an action now triggers a dismiss of the notification. This also fixes the issue where actions would be called multiple times.
- Chevron image is now having a max size of 20x20.
- Some small memory fixes
- Chevron image is now set inside the style, which is more logic.
- The chevron image is now hidden when there's no action attached.
- It's possible to override the default notification view.
- Cancellation is now only possible when the notification request is not yet running.
- Better state representation for `UINotificationPresenter`.
- Support for showing an image.
- Support for showing a subtitle.
- Support for iPhone X
- Update to Swift 4.2

### 1.0

- First public release! 🎉