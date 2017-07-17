//
//  UINotificationEaseOutEaseInPresenter.swift
//  Coyote
//
//  Created by Antoine van der Lee on 19/05/2017.
//  Copyright © 2017 WeTransfer. All rights reserved.
//
//  danger:disable final_class

import Foundation
import UIKit

/// Presents the Notification with an EaseOut in animation, EaseIn out animation.
public final class UINotificationEaseOutEaseInPresenter: UINotificationPresenter {
    
    public let presentationContext: UINotificationPresentationContext
    public var dismissTrigger: UINotificationDismissTrigger
    
    private let animateInDuration: TimeInterval = 0.2
    private let animateOutDuration: TimeInterval = 0.2
    
    public required init(presentationContext: UINotificationPresentationContext, dismissTrigger: UINotificationDismissTrigger?) {
        self.presentationContext = presentationContext
        self.dismissTrigger = dismissTrigger ?? UINotificationDurationDismissTrigger(duration: 2.0)
    }
    
    public func present() {
        presentationContext.notificationView.topConstraint?.constant = 0
        
        UIView.animate(withDuration: animateInDuration, delay: 0.0, options: UIViewAnimationOptions.curveEaseOut, animations: {
            self.presentationContext.containerWindow.layoutIfNeeded()
        }) { (_) in
            self.dismissTrigger.target = self
            if let schedulableDismissTrigger = self.dismissTrigger as? UINotificationSchedulableDismissTrigger {
                schedulableDismissTrigger.schedule()
            }
        }
    }
    
    public func dismiss() {
        presentationContext.notificationView.topConstraint?.constant = -presentationContext.notification.style.height.value
        
        UIView.animate(withDuration: animateOutDuration, delay: 0, options: UIViewAnimationOptions.curveEaseIn, animations: {
            self.presentationContext.containerWindow.layoutIfNeeded()
        }) { (_) in
            self.presentationContext.completePresentation()
        }
    }
}
