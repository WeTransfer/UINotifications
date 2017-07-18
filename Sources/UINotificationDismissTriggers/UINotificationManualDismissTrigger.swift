//
//  UINotificationManualDismissTrigger.swift
//  Coyote
//
//  Created by Antoine van der Lee on 26/05/2017.
//  Copyright © 2017 WeTransfer. All rights reserved.
//

/// A manual `UINotificationDismissTrigger`. Use `trigger()` to trigger the dismiss.
public final class UINotificationManualDismissTrigger: UINotificationDismissTrigger {
    
    public weak var target: Dismissable?
    
    public init() { }
    
    /// Triggers the dismiss of the attached `UINotificationView` if presented.
    public func trigger() {
        target?.dismiss()
    }
}
