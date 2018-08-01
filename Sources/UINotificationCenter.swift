//
//  UINotificationCenter.swift
//  Coyote
//
//  Created by Antoine van der Lee on 17/05/2017.
//  Copyright © 2017 WeTransfer. All rights reserved.
//

import UIKit

/// Handles the queueing and presenting of `UINotification`s
public final class UINotificationCenter {

    /// The `UINotificationCenter` for the current application
    public static let current = UINotificationCenter()
    
    // MARK: Public properties
    /// The type of presenter to use for presenting notifications. Change this to change the way notifications need to be presented.
    public var presenterType: UINotificationPresenter.Type = UINotificationEaseOutEaseInPresenter.self
    
    /// The type of view which will be used to present the notifications if not overriden by the `show` method.
    public var defaultNotificationViewType: UINotificationView.Type = UINotificationView.self
    
    /// The window level that notification should appear at. The default level is over the status bar.
    /// Changing the window level while a notification is displayed might give some issues.
    public var windowLevel: UIWindowLevel = UIWindowLevelStatusBar
    
    /// If `true`, the same notifications can be queued. This can result in duplicate notifications being presented after each other.
    public var isDuplicateQueueingAllowed: Bool = false
    
    // MARK: Private properties
    
    /// The window which will be placed on top of the application window.
    /// This window is used to present the notifications on and will be hided when all notifications are presented.
    internal let window: UIWindow
    
    /// Handles queueing of all notifications. Contains a queue of `UINotificationRequest` objects.
    internal lazy var queue: UINotificationQueue = UINotificationQueue(delegate: self)
    
    /// Defines the current running presenter.
    internal weak var currentPresenter: UINotificationPresenter?
    
    /// Creates a new notification center. Sets up the window for usage.
    internal init() {
        window = UINotificationPresentationWindow()
        window.clipsToBounds = true
        window.isUserInteractionEnabled = true
        window.backgroundColor = UIColor.clear
    }
    
    /// Request to present the given notification.
    ///
    /// - Parameter notification: The notification to be presented.
    /// - Parameter notificationViewType: Optional notification view type which overrides the default notification view type.
    /// - Parameter dismissTrigger: Optional dismiss trigger to use for the animation. If `nil` the default trigger will be used.
    /// - Returns: An `UINotificationRequest` for the requested notification presentation. Can be cancelled using `cancel()`.
    @discardableResult public func show(notification: UINotification, notificationViewType: UINotificationView.Type? = nil, dismissTrigger: UINotificationDismissTrigger? = nil) -> UINotificationRequest {
        return queue.add(notification, notificationViewType: notificationViewType ?? defaultNotificationViewType, dismissTrigger: dismissTrigger, allowDuplicates: isDuplicateQueueingAllowed)
    }
    
}

extension UINotificationCenter: UINotificationQueueDelegate {
    /// Handles the request which is ready to be presented. Links the presenter to the `UINotification` and `UINotificationView`.
    internal func handle(_ request: UINotificationRequest) {
        let notificationView = request.notificationViewType.init(notification: request.notification)
        let presentationContext = UINotificationPresentationContext(request: request, containerWindow: window, windowLevel: windowLevel, notificationView: notificationView)
        let presenter = presenterType.init(presentationContext: presentationContext, dismissTrigger: request.dismissTrigger)
        notificationView.presenter = presenter
        currentPresenter = presenter
        presenter.present()
    }
}

/// A custom `UIWindow` to use for the presentatation of the notifications. Will make sure the UI touches are only forwarded when inside any presented notification.
internal final class UINotificationPresentationWindow: UIWindow {
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        guard let rootViewController = self.rootViewController, let notificationView = rootViewController.view.subviews.first(where: { $0 is UINotificationView }) else { return false }
        return notificationView.frame.contains(point)
    }
}
