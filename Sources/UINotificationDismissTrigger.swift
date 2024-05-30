//
//  UINotificationDismissTrigger.swift
//  Coyote
//
//  Created by Antoine van der Lee on 26/05/2017.
//  Copyright © 2017 WeTransfer. All rights reserved.
//

import Foundation

/// Defines a dismissable view.
@MainActor
public protocol Dismissable: AnyObject, Sendable {
    /// Dismisses the view.
    func dismiss()
}

/// A trigger which can be used to dismiss an `UINotificationView`.
@MainActor
public protocol UINotificationDismissTrigger: AnyObject, Sendable {
    /// The target to dismiss.
    var target: Dismissable? { get set }
}

/// A trigger which is schedulable and therefor cancelable.
@MainActor
public protocol UINotificationSchedulableDismissTrigger: UINotificationDismissTrigger {
    /// Schedules the dismiss trigger to let the notification animate out after the `displayDuration`.
    func schedule()
    
    /// Cancels the possibly scheduled dismiss trigger. Can be used for interactive gestures like a pan.
    func cancel()
}
