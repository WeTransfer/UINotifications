//
//  UINotificationTestCase.swift
//  UINotificationsTests
//
//  Created by Antoine van der Lee on 14/07/2017.
//  Copyright © 2017 WeTransfer. All rights reserved.
//
//  danger:disable final_class

import XCTest
@testable import UINotifications

class UINotificationTestCase: XCTestCase {
    internal let notification = UINotification(content: UINotificationContent(title: "", subtitle: "", image: nil))
    
    internal final class MockNotificationView: UINotificationView { }
    internal final class MockPresenter: UINotificationPresenter {
        
        var dismissTrigger: UINotificationDismissTrigger
        var presentationContext: UINotificationPresentationContext
        var state: UINotificationPresenterState = .idle
        
        private(set) var presented: Bool = false
        private(set) var dismissed: Bool = false
        
        init(presentationContext: UINotificationPresentationContext, dismissTrigger: UINotificationDismissTrigger?) {
            self.presentationContext = presentationContext
            self.dismissTrigger = dismissTrigger ?? UINotificationDurationDismissTrigger(duration: 0.0)
        }
        
        func present() {
            dismissTrigger.target = self
            (dismissTrigger as? UINotificationSchedulableDismissTrigger)?.schedule()
            state = .presented
            presented = true
        }
        
        func dismiss() {
            presentationContext.completePresentation()
            state = .idle
            dismissed = true
        }
    }
    
    internal final class MockPresenterCapturer: UINotificationPresenter {
        
        var dismissTrigger: UINotificationDismissTrigger
        var presentationContext: UINotificationPresentationContext
        var isDismissing: Bool = false
        var state: UINotificationPresenterState = .idle
        
        private(set) var presented: Bool = false
        private(set) var dismissed: Bool = false
        
        init(presentationContext: UINotificationPresentationContext, dismissTrigger: UINotificationDismissTrigger?) {
            self.presentationContext = presentationContext
            self.dismissTrigger = dismissTrigger ?? UINotificationDurationDismissTrigger(duration: 0.0)
        }
        
        func present() {
            dismissTrigger.target = self
            (dismissTrigger as? UINotificationSchedulableDismissTrigger)?.schedule()
            presented = true
        }
        
        func dismiss() {
            dismissed = true
        }
    }
    
    internal final class MockQueueDelegate: UINotificationQueueDelegate {
        private(set) var handledRequest: UINotificationRequest?
        
        func handle(_ request: UINotificationRequest) {
            handledRequest = request
        }
    }
    
    internal final class MockRequestDelegate: UINotificationRequestDelegate {
        func notificationRequest(_ request: UINotificationRequest, didChangeStateTo state: UINotificationRequest.UINotificationRequestState) { }
    }
    
}
