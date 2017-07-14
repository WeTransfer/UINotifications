//
//  UINotificationCallbackAction.swift
//  Coyote
//
//  Created by Antoine van der Lee on 19/05/2017.
//  Copyright © 2017 WeTransfer. All rights reserved.
//

/// Defines a notification action which can be instantiated with a callback to execute.
public struct UINotificationCallbackAction: UINotificationAction {
    
    /// The callback to trigger on the tap of a notification.
    public let callback: () -> Void
    
    public init(callback: @escaping () -> Void) {
        self.callback = callback
    }
    
    public func execute() {
        callback()
    }
}
