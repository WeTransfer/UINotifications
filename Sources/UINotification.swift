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
    var titleFont: UIFont { get }
    var subtitleFont: UIFont { get }
    var titleTextColor: UIColor { get }
    var subtitleTextColor: UIColor { get }
    var backgroundColor: UIColor { get }
    
    /// The height of the notification which applies on the notification view.
    var height: UINotificationHeight { get }
    
    /// When `true`, the notification is swipeable and tappable.
    var interactive: Bool { get }
    
    /// The chevron image which is shown when a notification has an action attached.
    var chevronImage: UIImage? { get }
}

/// Defines the height which will be applied on the notification view.
public enum UINotificationHeight {
    case statusBar
    case navigationBar
    case custom(height: CGFloat)
    
    internal var value: CGFloat {
        switch self {
        case .statusBar:
            return UIApplication.shared.statusBarFrame.height
        case .navigationBar:
            return UIApplication.shared.statusBarFrame.height + 44
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
public final class UINotification: Equatable {
    
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
    
    static public func == (lhs: UINotification, rhs: UINotification) -> Bool {
        return lhs.content == rhs.content
    }
}

public struct UINotificationContent: Equatable {
    /// The title which will be showed inside the notification.
    public let title: String
    
    /// The subtitle which will be showed under the main title. Will be hidden if `nil`.
    public let subtitle: String?
    
    /// The image which will be shown inside the notification. Will be hidden if `nil`.
    public let image: UIImage?
    
    public init(title: String, subtitle: String? = nil, image: UIImage? = nil) {
        self.title = title
        self.subtitle = subtitle
        self.image = image
    }
    
    static public func == (lhs: UINotificationContent, rhs: UINotificationContent) -> Bool {
        return lhs.title == rhs.title
    }
}
