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
public protocol UINotificationStyle: Sendable {
    var titleFont: UIFont { get }
    var subtitleFont: UIFont { get }
    var titleTextColor: UIColor { get }
    var subtitleTextColor: UIColor { get }
    var backgroundColor: UIColor { get }
    
    /// The height of the notification which applies on the notification view.
    var height: UINotification.Height { get }

    /// The max width of the notification which applies on the notification view. Defaults to current screen width if set to `nil`.
    var maxWidth: CGFloat? { get }
    
    /// When `true`, the notification is swipeable and tappable.
    var interactive: Bool { get }
    
    /// The chevron image which is shown when a notification has an action attached.
    var chevronImage: UIImage? { get }
    
    /// The size to use for the thumbnail view.
    var thumbnailSize: CGSize { get }
}

/// Handles changes in UINotification
@MainActor
protocol UINotificationDelegate: AnyObject {
    // Called when Notification is updated.
    func didUpdateContent(in notificaiton: UINotification)
    
    /// Called when the button is set.
    func didUpdateButton(in notificaiton: UINotification)
}

/// An UINotification which can be showed on top of the `UINavigationBar` and `UIStatusBar`
/// `@unchecked Sendable` as we synchronize access using a lock queue.
public final class UINotification: Equatable, @unchecked Sendable {

    static let lockQueue = DispatchQueue(
        label: "wetransfer.uinotification.lock.queue",
        qos: .userInitiated,
        target: .global(qos: .userInitiated)
    )

    /// Defines the height which will be applied on the notification view.
    public enum Height: Sendable {
        case statusBar
        case navigationBar
        case custom(height:   CGFloat)

        @MainActor
        internal var value: CGFloat {
            switch self {
            case .statusBar:
                return UIApplication.statusBarHeight
            case .navigationBar:
                return UIApplication.statusBarHeight + 44
            case .custom(let height):
                return height
            }
        }
    }

    /// The content of the notification.
    public var content: UINotificationContent {
        Self.lockQueue.sync { notificationContent }
    }

    /// A private backup property to synchronize access using a lock queue.
    private var notificationContent: UINotificationContent

    /// The style of the notification which applies on the notification view.
    public let style: UINotificationStyle
    
    /// The button to display on the right side of the notification, if any.
    /// Setting this property will add the button, even if the notification is already visible.
    public var button: UIButton? {
        didSet {
            Task { @MainActor in
                delegate?.didUpdateButton(in: self)
            }
        }
    }
    
    /// The action which will be triggered on tap.
    public let action: UINotificationAction?

    weak var delegate: UINotificationDelegate?
    
    public init(content: UINotificationContent, style: UINotificationStyle = UINotificationSystemStyle(), action: UINotificationAction? = nil) {
        self.notificationContent = content
        self.style = style
        self.action = action
    }

    /// Updates the content of the notification
    public func update(_ content: UINotificationContent) {
        Self.lockQueue.sync {
            self.notificationContent = content
        }
        Task { @MainActor in
            delegate?.didUpdateContent(in: self)
        }
    }
    
    public static func == (lhs: UINotification, rhs: UINotification) -> Bool {
        return lhs.content == rhs.content
    }
}

public struct UINotificationContent: Equatable, Sendable {
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
    
    public static func == (lhs: UINotificationContent, rhs: UINotificationContent) -> Bool {
        return lhs.title == rhs.title
    }
}
