//
//  UINotification.swift
//  Coyote
//
//  Created by Antoine van der Lee on 17/05/2017.
//  Copyright © 2017 WeTransfer. All rights reserved.
//

import UIKit

/// Defines an action which can be executed with a notification on tap.
public protocol UINotificationAction {
    /// Executes the action
    func execute()
}

/// Defines a style which will be applied on the notification view.
public protocol UINotificationStyle {
    var font: UIFont { get }
    var backgroundColor: UIColor { get }
    var textColor: UIColor { get }
    
    /// The height of the notification which applies on the notification view.
    var height: UINotificationHeight { get }
    
    /// When `true`, the notification is swipeable and tappable.
    var interactive: Bool { get }
}

/// Defines the height which will be applied on the notification view.
public enum UINotificationHeight {
    case statusBar
    case navigationBar
    case custom(height: CGFloat)
    
    internal var value: CGFloat {
        switch self {
        case .statusBar:
            return 20
        case .navigationBar:
            return 64
        case .custom(let height):
            return height
        }
    }
}

/// Handles changes in UINotification
protocol UINotificationDelegate: class {
    // Called when Notification is updated
    func didUpdateContent(in notificaiton: UINotification)
}

/// An UINotification which can be showed on top of the `UINavigationBar` and `UIStatusBar`
public final class UINotification {
    
    /// The content of the notification.
    public var content: UINotificationContent
    
    /// The style of the notification which applies on the notification view.
    public let style: UINotificationStyle
    
    /// The action which will be triggered on tap.
    public let action: UINotificationAction?

    weak var delegate: UINotificationDelegate?
    
    public init(content: UINotificationContent, style: UINotificationStyle = UINotificationSystemStyle(), action: UINotificationAction? = nil) {
        self.content = content
        self.style = style
        self.action = action
    }

    /// Updates the content of the notification
    public func update(_ content: UINotificationContent) {
        self.content = content
        delegate?.didUpdateContent(in: self)
    }
}

public struct UINotificationContent {
    /// The title which will be showed inside the notification.
    public let title: String
    
    /// The chevron image which will be showed when a notification has an action.
    public let chevronImage: UIImage?
    
    public init(title: String, chevronImage: UIImage? = nil) {
        self.title = title
        self.chevronImage = chevronImage
    }
}
