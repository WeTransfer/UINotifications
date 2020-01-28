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