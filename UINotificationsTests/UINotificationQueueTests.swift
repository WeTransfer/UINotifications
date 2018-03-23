//
//  UINotificationQueueTests.swift
//  UINotificationsTests
//
//  Created by Antoine van der Lee on 14/07/2017.
//  Copyright © 2017 WeTransfer. All rights reserved.
//

import XCTest
@testable import UINotifications

final class UINotificationQueueTests: UINotificationTestCase {
    
    /// When a notification is added, a request should be added
    func testAddNotification() {
        let queue = UINotificationQueue(delegate: MockQueueDelegate())
        queue.add(notification, notificationViewType: UINotificationView.self)
        XCTAssert(queue.requests.count == 1, "Request should be added")
    }
    
    /// When a notification request is removed, the request should be deleted from the queue
    func testRemoveNotification() {
        let queue = UINotificationQueue(delegate: MockQueueDelegate())
        let request = queue.add(notification, notificationViewType: UINotificationView.self)
        queue.remove(request)
        XCTAssert(queue.requests.isEmpty == true, "Request should be removed")
    }
    
    /// When a request is running, it should be reported correctly.
    func testRunningNotificationRequest() {
        let queue = UINotificationQueue(delegate: MockQueueDelegate())
        queue.add(notification, notificationViewType: UINotificationView.self)
        XCTAssert(queue.requestIsRunning() == true, "")
    }
    
    /// When a request is the first, it should be presented directly and new ones should wait.
    func testFirstNotificationHandling() {
        let delegate = MockQueueDelegate()
        let queue = UINotificationQueue(delegate: delegate)
        let requestOne = queue.add(notification, notificationViewType: UINotificationView.self, allowDuplicates: true)
        let requestTwo = queue.add(notification, notificationViewType: UINotificationView.self, allowDuplicates: true)
        
        XCTAssert(requestOne.state == .running, "The request should be handled directly if it's the first")
        XCTAssert(requestTwo.state == .idle, "The second request should be in idle mode")
        XCTAssert(queue.nextRequestToRun() == requestTwo, "Next notification should be available")
        XCTAssert(delegate.handledRequest == requestOne, "Delegate should be called correctly")
    }
    
    /// When a request is cancelled, it should be removed from the queue.
    func testNotificationRequestCancellation() {
        let queue = UINotificationQueue(delegate: MockQueueDelegate())
        let requestOne = queue.add(notification, notificationViewType: UINotificationView.self, allowDuplicates: true)
        requestOne.cancel()
        XCTAssert(queue.requests.count == 1, "Request should not be removed as it is already handled.")
        let requestTwo = queue.add(notification, notificationViewType: UINotificationView.self, allowDuplicates: true)
        XCTAssert(queue.requests.count == 2, "Request should be removed")
        requestTwo.cancel()
        XCTAssert(queue.requests.count == 1, "Request should be removed")
    }
    
    /// When a request is already queued, it should not be added if duplicates are not allowed.
    func testDuplicateNotificationRequestsQueue() {
        let queue = UINotificationQueue(delegate: MockQueueDelegate())
        queue.add(notification, notificationViewType: UINotificationView.self)
        XCTAssert(queue.requests.count == 1, "Request should not be removed as it is already handled.")
        let requestTwo = queue.add(notification, notificationViewType: UINotificationView.self)
        XCTAssert(queue.requests.count == 1, "Request should not be added as it is a duplicate")
        XCTAssert(requestTwo.state == .cancelled, "Request state should be cancelled")
        let requestThree = queue.add(UINotification(content: UINotificationContent(title: "different title")), notificationViewType: UINotificationView.self)
        XCTAssert(queue.requests.count == 2, "Request should be added as it is not a duplicate")
        XCTAssert(requestThree.state == .idle, "Request state should be idle")
    }
}
