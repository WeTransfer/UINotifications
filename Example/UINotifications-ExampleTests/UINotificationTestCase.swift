//
//  UINotificationTestCase.swift
//  UINotifications-Example
//
//  Created by Antoine van der Lee on 14/07/2017.
//  Copyright © 2017 WeTransfer. All rights reserved.
//

import XCTest
@testable import UINotifications_Example

class UINotificationTestCase: XCTestCase {
    internal let notification = UINotification(content: UINotificationContent(title: ""))
    
    internal final class MockNotificationView: UINotificationView { }
    internal final class MockPresenter: UINotificationPresenter {
        
        var dismissTrigger: UINotificationDismissTrigger
        var presentationContext: UINotificationPresentationContext
        
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
            presentationContext.completePresentation()
            dismissed = true
        }
    }
    
    internal final class MockPresenterCapturer: UINotificationPresenter {
        
        var dismissTrigger: UINotificationDismissTrigger
        var presentationContext: UINotificationPresentationContext
        
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
