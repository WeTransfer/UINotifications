//
//  UINotificationCenter.swift
//  Coyote
//
//  Created by Antoine van der Lee on 17/05/2017.
//  Copyright © 2017 WeTransfer. All rights reserved.
//

import UIKit

public struct UINotificationCenterConfiguration {
    /// The type of presenter to use for presenting notifications. Change this to change the way notifications need to be presented.
    let presenterType: UINotificationPresenter.Type

    /// The type of view which will be used to present the notifications if not overriden by the `show` method.
    let defaultNotificationViewType: UINotificationView.Type

    /// The window level that notification should appear at. The default level is over the status bar.
    /// Changing the window level while a notification is displayed might give some issues.
    let windowLevel: UIWindow.Level

    /// If `true`, the same notifications can be queued. This can result in duplicate notifications being presented after each other.
    let isDuplicateQueueingAllowed: Bool

    /// Creates a new notification center configuration.
    /// - Parameters:
    ///   - presenterType: The type of presenter to use for presenting notifications. 
    ///   Change this to change the way notifications need to be presented.
    ///   - defaultNotificationViewType: The type of view which will be used to present the notifications if not 
    ///   overriden by the `show` method.
    ///   - windowLevel: The window level that notification should appear at. The default level is over the status bar.
    ///   Changing the window level while a notification is displayed might give some issues.
    ///   - isDuplicateQueueingAllowed: If `true`, the same notifications can be queued. This can result in duplicate notifications
    ///   being presented after each other.
    public init(
        presenterType: UINotificationPresenter.Type = UINotificationEaseOutEaseInPresenter.self,
        defaultNotificationViewType: UINotificationView.Type = UINotificationView.self,
        windowLevel: UIWindow.Level = UIWindow.Level.statusBar,
        isDuplicateQueueingAllowed: Bool = false
    ) {
        self.presenterType = presenterType
        self.defaultNotificationViewType = defaultNotificationViewType
        self.windowLevel = windowLevel
        self.isDuplicateQueueingAllowed = isDuplicateQueueingAllowed
    }
}

/// Handles the queueing and presenting of `UINotification`s
public final class UINotificationCenter {

    // MARK: Public properties

    /// The `UINotificationCenter` for the current application
    public static let current = UINotificationCenter()

    /// The configuration to use for presenting notifications.
    public var configuration = UINotificationCenterConfiguration()

    // MARK: Private properties
    
    /// The window which will be placed on top of the application window.
    /// This window is used to present the notifications on and will be hidden when notifications are dismissed.
    internal lazy var window: UIWindow = {
        let window: UIWindow
        
        if let windowScene = UIApplication.shared.connectedScenes.first(
            where: { $0.activationState == .foregroundActive }
        ) as? UIWindowScene {
            window = UINotificationPresentationWindow(windowScene: windowScene)
        } else {
            window = UINotificationPresentationWindow()
        }
        
        window.clipsToBounds = true
        window.isUserInteractionEnabled = true
        window.backgroundColor = UIColor.clear
        window.windowLevel = UIWindow.Level.normal - 1
        return window
    }()
    
    /// Handles queueing of all notifications. Contains a queue of `UINotificationRequest` objects.
    internal lazy var queue: UINotificationQueue = UINotificationQueue(delegate: self)
    
    /// Defines the current running presenter.
    internal weak var currentPresenter: UINotificationPresenter?

    /// Request to present the given notification.
    ///
    /// - Parameter notification: The notification to be presented.
    /// - Parameter notificationViewType: Optional notification view type which overrides the default notification view type.
    /// - Parameter dismissTrigger: Optional dismiss trigger to use for the animation. If `nil` the default trigger will be used.
    /// - Returns: An `UINotificationRequest` for the requested notification presentation. Can be cancelled using `cancel()`.
    @discardableResult public func show(
        notification: UINotification,
        notificationViewType: UINotificationView.Type? = nil,
        dismissTrigger: UINotificationDismissTrigger? = nil
    ) -> UINotificationRequest {
        return queue.add(
            notification,
            notificationViewType: notificationViewType ?? configuration.defaultNotificationViewType,
            dismissTrigger: dismissTrigger,
            allowDuplicates: configuration.isDuplicateQueueingAllowed
        )
    }
    
}

extension UINotificationCenter: UINotificationQueueDelegate {
    /// Handles the request which is ready to be presented. Links the presenter to the `UINotification` and `UINotificationView`.
    internal func handle(_ request: UINotificationRequest) {
        Task { @MainActor in
            let notificationView = request.notificationViewType.init(notification: request.notification)
            let presentationContext = UINotificationPresentationContext(
                request: request,
                containerWindow: window,
                windowLevel: configuration.windowLevel,
                notificationView: notificationView
            )
            let presenter = configuration.presenterType.init(presentationContext: presentationContext, dismissTrigger: request.dismissTrigger)
            notificationView.presenter = presenter
            currentPresenter = presenter
            presenter.present()
        }
    }
}

/// A custom `UIWindow` to use for the presentatation of the notifications. 
/// Will make sure the UI touches are only forwarded when inside any presented notification.
internal final class UINotificationPresentationWindow: UIWindow {
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        guard 
            let rootViewController = self.rootViewController,
            let notificationView = rootViewController.view.subviews.first(where: { $0 is UINotificationView }) else {
            return false
        }
        return notificationView.frame.contains(point)
    }
}

extension UIApplication {
    /// Returns the status bar height of the current active application if not an app extension.
    static var statusBarHeight: CGFloat {
        shared.windows.first(where: \.isKeyWindow)?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0
    }
}
