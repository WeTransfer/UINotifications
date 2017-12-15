//
//  UINotificationPresentationContext.swift
//  Coyote
//
//  Created by Antoine van der Lee on 18/05/2017.
//  Copyright © 2017 WeTransfer. All rights reserved.
//

import UIKit

/// Provides information about an in-progress notification presentation.
public final class UINotificationPresentationContext {
    
    /// The window in which the `UINotificationView` will be presented.
    public let containerWindow: UIWindow
    
    /// The level the container window should be on when presenting the notification
    private let windowLevel: UIWindowLevel
    
    /// The `UINotificationView` containing the visual representation of the `UINotification`.
    public let notificationView: UINotificationView
    
    /// The notification request currenly being handled.
    private let request: UINotificationRequest
    
    /// Public getter for the current notification which is handled.
    public var notification: UINotification {
        return request.notification
    }
    
    internal init(request: UINotificationRequest, containerWindow: UIWindow, windowLevel: UIWindowLevel, notificationView: UINotificationView) {
        self.request = request
        self.containerWindow = containerWindow
        self.notificationView = notificationView
        self.windowLevel = windowLevel
        
        prepareContainerWindow()
        prepareNotificationView()
    }
    
    /// Completes the presentation. Resets the container window and updates the state of the `UINotificationRequest`.
    public func completePresentation() {
        resetContainerWindow()
        notificationView.removeFromSuperview()
        request.finish()
        
        // This releases all objects.
        // We can't define the presenter weak inside the notificationView, because it's needed for dismissing after a pan gesture.
        notificationView.presenter = nil
    }
    
    private func prepareContainerWindow() {
        containerWindow.windowLevel = windowLevel
        containerWindow.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        #if !TEST
            containerWindow.makeKeyAndVisible()
        #endif
    }
    
    private func prepareNotificationView() {
        /// Create a container view controller to let it handle orientation changes.
        let containerViewController = UIViewController(nibName: nil, bundle: nil)
        containerViewController.view.addSubview(notificationView)
        containerWindow.rootViewController = containerViewController
        
        /// Set the top constraint.
        var notificationViewTopConstraint = notificationView.topAnchor.constraint(equalTo: containerViewController.view.topAnchor, constant: -notification.style.height.value)
        
        /// For iPhone X we need to use the safe area layout guide, which is only available in iOS 11 and up.
        if #available(iOS 11.0, *) {
            notificationViewTopConstraint = notificationView.topAnchor.constraint(equalTo: containerViewController.view.safeAreaLayoutGuide.topAnchor, constant: -notification.style.height.value)
        }
        
        notificationView.topConstraint = notificationViewTopConstraint
        
        let constraints = [
            notificationView.leftAnchor.constraint(equalTo: containerViewController.view.leftAnchor),
            notificationView.rightAnchor.constraint(equalTo: containerViewController.view.rightAnchor),
            notificationView.heightAnchor.constraint(equalToConstant: notification.style.height.value),
            notificationViewTopConstraint
        ]
        
        NSLayoutConstraint.activate(constraints)
        containerViewController.view.layoutIfNeeded()
    }
    
    private func resetContainerWindow() {
        /// Move the window behind the key application window.
        containerWindow.windowLevel = UIWindowLevelNormal - 1
        containerWindow.rootViewController = nil
        
        /// Make sure the key window of the app is visible again.
        guard let applicationWindow = UIApplication.shared.windows.first(where: { $0 != self.containerWindow }) else { return }
        applicationWindow.makeKeyAndVisible()
    }
}
