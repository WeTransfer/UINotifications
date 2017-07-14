//
//  UINotificationRequest.swift
//  Coyote
//
//  Created by Antoine van der Lee on 18/05/2017.
//  Copyright © 2017 WeTransfer. All rights reserved.
//

import Foundation

protocol UINotificationRequestDelegate: class {
    
    /// Notifies of a change inside the passed `UINotificationRequest` state.
    ///
    /// - Parameters:
    ///   - request: The `UINotificationRequest` of which the state is changed.
    ///   - state: The new state of the passed `UINotificationRequest`.
    func notificationRequest(_ request: UINotificationRequest, didChangeStateTo state: UINotificationRequest.UINotificationRequestState)
}

/// Defines the request of a notification presentation.
/// Can be in idle, running or finished state. Can also be in a cancelled state if `cancel()` is called.
public final class UINotificationRequest: Equatable {
    
    struct WeakRequestDelegate {
        weak var target: UINotificationRequestDelegate?
    }
    
    public enum UINotificationRequestState {
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
    
    /// An internal intedifier used for comparing actions
    private let identifier: UUID
    
    /// The current state of the request.
    private(set) public var state: UINotificationRequestState = .idle {
        didSet {
            delegates.forEach { $0.target?.notificationRequest(self, didChangeStateTo: state) }
        }
    }
    
    /// An array of listener to delegate callbacks.
    var delegates = [WeakRequestDelegate]()
    
    internal init(notification: UINotification, delegate: UINotificationRequestDelegate, dismissTrigger: UINotificationDismissTrigger? = nil) {
        self.notification = notification
        self.delegates.append(WeakRequestDelegate(target: delegate))
        self.dismissTrigger = dismissTrigger
        self.identifier = UUID()
    }
    
    internal func start() {
        state = .running
    }
    
    public func cancel() {
        state = .cancelled
    }
    
    internal func finish() {
        state = .finished
    }
    
    static public func == (lhs: UINotificationRequest, rhs: UINotificationRequest) -> Bool {
        return lhs.identifier == rhs.identifier
    }
}
