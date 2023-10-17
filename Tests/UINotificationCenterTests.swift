//
//  UINotificationCenterTests.swift
//  UINotificationsTests
//
//  Created by Antoine van der Lee on 14/07/2017.
//  Copyright © 2017 WeTransfer. All rights reserved.
//

import XCTest
@testable import UINotifications
import ConcurrencyExtras

@MainActor
final class UINotificationCenterTests: UINotificationTestCase {
    
    override func invokeTest() {
        withMainSerialExecutor {
            super.invokeTest()
        }
    }

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
    func testCustomDefaultNotificationView() async {
        let notificationCenter = UINotificationCenter()
        notificationCenter.configuration = UINotificationCenterConfiguration(
            defaultNotificationViewType: MockNotificationView.self
        )
        notificationCenter.show(notification: notification)
        await Task.yield()

        XCTAssert(notificationCenter.currentPresenter?.presentationContext.notificationView is MockNotificationView, "The custom view should be used")
    }
    
    /// When a custom notification view is passed inside the presentation method, it should be used for presentation.
    func testCustomNotificationView() async {
        let notificationCenter = UINotificationCenter()
        notificationCenter.show(notification: notification, notificationViewType: MockNotificationView.self)
        await Task.yield()
        XCTAssert(notificationCenter.currentPresenter?.presentationContext.notificationView is MockNotificationView, "The custom view should be used")
    }
    
    /// When a custom presenter is set, it should be used for presenting.
    func testCustomNotificationPresenter() async {
        let notificationCenter = UINotificationCenter()
        notificationCenter.configuration = UINotificationCenterConfiguration(
            presenterType: MockPresenter.self
        )
        
        notificationCenter.show(notification: notification)

        await waitForCondition(notificationCenter.currentPresenter is MockPresenter, timeout: 5.0, description: "Custom presenter should be used for presenting")
    }
    
    /// When a presentation is finished, the presenter should be released.
    func testPresenterReleasing() async {
        let notificationCenter = UINotificationCenter()
        notificationCenter.configuration = UINotificationCenterConfiguration(
            presenterType: MockPresenter.self
        )
        notificationCenter.show(notification: notification)

        await waitForCondition(notificationCenter.currentPresenter == nil, timeout: 5.0, description: "Current presenter should be released and nil")
    }
}
