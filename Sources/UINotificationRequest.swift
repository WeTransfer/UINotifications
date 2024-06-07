//
//  UINotificationRequest.swift
//  Coyote
//
//  Created by Antoine van der Lee on 18/05/2017.
//  Copyright © 2017 WeTransfer. All rights reserved.
//

import Foundation

protocol UINotificationRequestDelegate: AnyObject {
    
    /// Notifies of a change inside the passed `UINotificationRequest` state.
    ///
    /// - Parameters:
    ///   - request: The `UINotificationRequest` of which the state is changed.
    ///   - state: The new state of the passed `UINotificationRequest`.
    func notificationRequest(_ request: UINotificationRequest, didChangeStateTo state: UINotificationRequest.State)
}

/// Defines the request of a notification presentation.
/// Can be in idle, running or finished state. Can also be in a cancelled state if `cancel()` is called.
public final class UINotificationRequest: Equatable, @unchecked Sendable {
    /// The queue which is used to make sure the requests array is only modified serially.
    private static let lockQueue = DispatchQueue(label: "com.uinotifications.request.LockQueue")

    public enum State {
        /// Waiting to run
        case idle
        
        /// Currently running
        case running
        
        /// Finished
        case finished
        
        /// Cancelled
        case cancelled
    }
    
    /// The notification which is requested for presentation.
    public let notification: UINotification
    
    /// Optional dismiss trigger to use for the animation. If `nil` the default trigger will be used.
    public let dismissTrigger: UINotificationDismissTrigger?

    /// The type of view to use for this notification.
    public let notificationViewType: UINotificationView.Type
    
    /// An internal identifier used for comparing actions
    private let identifier: UUID
    
    /// The current state of the request.
    private(set) var state: UINotificationRequest.State {
        get {
            Self.lockQueue.sync { _state }
        }
        set {
            Self.lockQueue.sync { _state = newValue }
            delegate.notificationRequest(self, didChangeStateTo: newValue)
        }
    }
    private var _state: UINotificationRequest.State = .idle

    /// An array of listener to delegate callbacks.
    /// Note: we're not referencing this weakly to make this type `Sendable`. We can do this
    /// since the delegate will always exist since it's the `UINotificationQueue`.
    private let delegate: UINotificationRequestDelegate

    internal init(notification: UINotification, delegate: UINotificationRequestDelegate, notificationViewType: UINotificationView.Type, dismissTrigger: UINotificationDismissTrigger? = nil) {
        self.notification = notification
        self.delegate = delegate
        self.notificationViewType = notificationViewType
        self.dismissTrigger = dismissTrigger
        self.identifier = UUID()
    }
    
    internal func start() {
        state = .running
    }
    
    /// Set's the state of the request to cancelled, which will trigger a cancel.
    public func cancel() {
        guard state == .idle else {
            // The notification is already being presented or cancelled.
            return
        }
        state = .cancelled
    }
    
    internal func finish() {
        state = .finished
    }
    
    nonisolated public static func == (lhs: UINotificationRequest, rhs: UINotificationRequest) -> Bool {
        return lhs.identifier == rhs.identifier
    }
}
