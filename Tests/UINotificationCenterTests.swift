//
//  UINotificationCenterTests.swift
//  UINotificationsTests
//
//  Created by Antoine van der Lee on 14/07/2017.
//  Copyright © 2017 WeTransfer. All rights reserved.
//

import XCTest
@testable import UINotifications

final class UINotificationCenterTests: UINotificationTestCase {
    
    /// When a notification is requested, it should be added to the queue.
    func testShowNotificationQueue() {
        let notificationCenter = UINotificationCenter()
        notificationCenter.show(notification: notification)
        XCTAssert(notificationCenter.queue.requests.isEmpty == false, "A notification request should be created")
    }
    
    /// When a notification is requested and the queue is empty, it should be presented directly.
    func testEmptyQueuePresentation() {
        let notificationCenter = UINotificationCenter()
        notificationCenter.show(notification: notification)
        XCTAssert(notificationCenter.queue.requests.first?.state == .running, "Notification should be presented directly")
    }
    
    /// When a custom default notification view is set, it should be used for presentation.
    func testCustomDefaultNotificationView() {
        let notificationCenter = UINotificationCenter()
        notificationCenter.defaultNotificationViewType = MockNotificationView.self
        notificationCenter.show(notification: notification)
        XCTAssert(notificationCenter.currentPresenter?.presentationContext.notificationView is MockNotificationView, "The custom view should be used")
    }
    
    /// When a custom notification view is passed inside the presentation method, it should be used for presentation.
    func testCustomNotificationView() {
        let notificationCenter = UINotificationCenter()
        notificationCenter.show(notification: notification, notificationViewType: MockNotificationView.self)
        XCTAssert(notificationCenter.currentPresenter?.presentationContext.notificationView is MockNotificationView, "The custom view should be used")
    }
    
    /// When a custom presenter is set, it should be used for presenting.
    func testCustomNotificationPresenter() {
        let notificationCenter = UINotificationCenter()
        notificationCenter.presenterType = MockPresenter.self
        
        notificationCenter.show(notification: notification)
        
        waitFor(notificationCenter.currentPresenter is MockPresenter, timeout: 5.0, description: "Custom presenter should be used for presenting")
    }
    
    /// When a presentation is finished, the presenter should be releasted.
    func testPresenterReleasing() {
        let notificationCenter = UINotificationCenter()
        notificationCenter.presenterType = MockPresenter.self
        notificationCenter.show(notification: notification)

        waitFor(notificationCenter.currentPresenter == nil, timeout: 5.0, description: "Current presenter should be released and nil")
    }
}
