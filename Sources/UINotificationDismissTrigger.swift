//
//  UINotificationDismissTrigger.swift
//  Coyote
//
//  Created by Antoine van der Lee on 26/05/2017.
//  Copyright © 2017 WeTransfer. All rights reserved.
//

import Foundation

/// Defines a dismissable view.
public protocol Dismissable: class {
    /// Dimisses the view.
    func dismiss()
}

/// A trigger which can be used to dismiss an `UINotificationView`.
public protocol UINotificationDismissTrigger {
    /// The target to dismiss.
    var target: Dismissable? { get set }
}

/// A trigger which is schedulable and therefor cancelable.
public protocol UINotificationSchedulableDismissTrigger: UINotificationDismissTrigger {
    /// Schedules the dismiss trigger to let the notification animate out after the `displayDuration`.
    func schedule()
    
    /// Cancels the possibly scheduled dismiss trigger. Can be used for interactive gestures like a pan.
    func cancel()
}
