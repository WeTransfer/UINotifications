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
    public var state: UINotificationPresenterState = .idle
    
    private let inDuration: TimeInterval = 0.2
    private let outDuration: TimeInterval = 0.2
    
    public required init(presentationContext: UINotificationPresentationContext, dismissTrigger: UINotificationDismissTrigger?) {
        self.presentationContext = presentationContext
        self.dismissTrigger = dismissTrigger ?? UINotificationDurationDismissTrigger(duration: 2.0)
    }
    
    public func present() {
        guard state == .idle else { return }
        state = .presenting
        
        if #available(iOS 11.0, *) {
            presentationContext.notificationView.topConstraint?.constant = 0
        } else {
            presentationContext.notificationView.topConstraint?.constant = presentationContext.notificationView.layoutMargins.top + UIApplication.shared.statusBarFrame.size.height
        }

        UIView.animate(withDuration: inDuration, delay: 0.0, options: UIViewAnimationOptions.curveEaseOut, animations: {
            self.presentationContext.containerWindow.layoutIfNeeded()
        }, completion: { (_) in
            self.state = .presented
            
            self.dismissTrigger.target = self
            if let schedulableDismissTrigger = self.dismissTrigger as? UINotificationSchedulableDismissTrigger {
                schedulableDismissTrigger.schedule()
            }
        })
    }
    
    public func dismiss() {
        guard state == .presented else { return }
        state = .dismissing
        
        presentationContext.notificationView.topConstraint?.constant = -presentationContext.notification.style.height.value
        
        UIView.animate(withDuration: outDuration, delay: 0, options: UIViewAnimationOptions.curveEaseIn, animations: {
            self.presentationContext.containerWindow.layoutIfNeeded()
        }, completion: { (_) in
            self.state = .idle
            self.presentationContext.completePresentation()
        })
    }
}
