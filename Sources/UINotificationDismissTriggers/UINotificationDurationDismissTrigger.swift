//
//  UINotificationDurationDismissTrigger.swift
//  Coyote
//
//  Created by Antoine van der Lee on 26/05/2017.
//  Copyright © 2017 WeTransfer. All rights reserved.
//

import Foundation

/// A duration `UINotificationDismissTrigger` which will automatically dismiss the target `UINotificationView` after the given duration.
public final class UINotificationDurationDismissTrigger: UINotificationSchedulableDismissTrigger {
    
    public weak var target: Dismissable?
    
    /// The duration of how long the notification is shown.
    private let duration: TimeInterval
    
    /// The trigger which will make the target dismiss. Cancellable.
    internal var dismissWorkItem: DispatchWorkItem?
    
    public init(duration: TimeInterval) {
        self.duration = duration
    }
    
    public func schedule() {
        let dismissWorkItem = DispatchWorkItem {
            self.target?.dismiss()
            self.dismissWorkItem = nil
        }
        self.dismissWorkItem = dismissWorkItem
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + duration, execute: dismissWorkItem)
    }
    
    public func cancel() {
        dismissWorkItem?.cancel()
        dismissWorkItem = nil
    }
}
