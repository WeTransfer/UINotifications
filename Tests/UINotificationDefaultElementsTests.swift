//
//  UINotificationDefaultElementsTests.swift
//  UINotificationsTests
//
//  Created by Antoine van der Lee on 14/07/2017.
//  Copyright © 2017 WeTransfer. All rights reserved.
//

import XCTest
@testable import UINotifications
import ConcurrencyExtras

@MainActor
final class UINotificationDefaultElementsTests: UINotificationTestCase {

    struct CustomStyle: UINotificationStyle {
        var thumbnailSize: CGSize
        var titleFont: UIFont = UIFont.systemFont(ofSize: 13, weight: .semibold)
        var subtitleFont: UIFont = UIFont.systemFont(ofSize: 13, weight: .semibold)
        var titleTextColor: UIColor = UIColor.black
        var subtitleTextColor: UIColor = UIColor.black
        var backgroundColor: UIColor = UIColor.white
        var height: UINotification.Height {
            guard let customHeight = customHeight else { return .navigationBar }
            return .custom(height: customHeight)
        }
        var interactive: Bool = true
        var chevronImage: UIImage?
        
        let customHeight: CGFloat?
        let maxWidth: CGFloat?

        init(customHeight: CGFloat? = nil, maxWidth: CGFloat? = nil, thumbnailSize: CGSize = CGSize(width: 20, height: 20)) {
            self.customHeight = customHeight
            self.maxWidth = maxWidth
            self.thumbnailSize = thumbnailSize
        }
    }

    override func invokeTest() {
        withMainSerialExecutor {
            super.invokeTest()
        }
    }

    /// When the notification callback action is executed, the callback should be triggered.
    func testNotificationCallbackAction() {
        let expectation = self.expectation(description: "The callback should be triggered")
        let action = UINotificationCallbackAction {
            expectation.fulfill()
        }
        action.execute()
        
        waitForExpectations(timeout: 5.0, handler: nil)
    }
    
    /// When using the easeOutEaseInPresenter, the presenter should be released correctly.
    func testEaseOutEaseInPresenter() async throws {
        let notificationCenter = UINotificationCenter()
        notificationCenter.configuration = UINotificationCenterConfiguration(
            presenterType: UINotificationEaseOutEaseInPresenter.self,
            isDuplicateQueueingAllowed: true
        )
        notificationCenter.show(notification: notification)
        await Task.yield()

        let presenter = try XCTUnwrap(notificationCenter.currentPresenter as? UINotificationEaseOutEaseInPresenter)
        XCTAssert(notificationCenter.queue.requests.first?.state == .running, "We should have a running notification")
        
        await Task.megaYield(count: 4)
        await waitForCondition(notificationCenter.queue.requests.isEmpty, timeout: 5.0, description: "All requests should be cleaned up after presentation")

        presenter.state = .dismissing
        presenter.present()
        XCTAssert(presenter.state == .dismissing, "Presentation should not be possible when not in idle")
        
        presenter.dismiss()
        XCTAssert(presenter.state == .dismissing, "Dismissing should not be possible when not in presented state")
    }
    
    /// When passing a notification style with a custom height, this should be applied to the presented view.
    func testCustomNotificationViewHeight() async {
        let notificationCenter = UINotificationCenter()
        notificationCenter.configuration = UINotificationCenterConfiguration(
            presenterType: MockPresenter.self,
            isDuplicateQueueingAllowed: true
        )
        let customHeight: CGFloat = 500
        let notification = UINotification(content: UINotificationContent(title: "test"), style: CustomStyle(customHeight: customHeight))
        
        notificationCenter.show(notification: notification)
        
        await waitForCondition(notificationCenter.currentPresenter?.presentationContext.notificationView.frame.size.height == customHeight, timeout: 5.0, description: "Custom height should be applied to the view")
    }
    
    /// When passing a notification style with a custom thumbnail size, this should be applied to the presented view.
    func testCustomNotificationThumbnailSize() async {
        let notificationCenter = UINotificationCenter()
        notificationCenter.configuration = UINotificationCenterConfiguration(
            presenterType: MockPresenter.self,
            isDuplicateQueueingAllowed: true
        )
        let customSize = CGSize(width: 25, height: 25)
        let notification = UINotification(content: UINotificationContent(title: "test"), style: CustomStyle(thumbnailSize: customSize))
        
        notificationCenter.show(notification: notification)
        
        await waitForCondition(notificationCenter.currentPresenter?.presentationContext.notificationView.imageView.frame.size == customSize, timeout: 5.0, description: "Custom height should be applied to the view")
    }

    /// When passing a notification style with a max width, this should be applied to the presented view.
    func testNotificationViewMaxWidth() async {
        let notificationCenter = UINotificationCenter()
        notificationCenter.configuration = UINotificationCenterConfiguration(
            presenterType: MockPresenter.self,
            isDuplicateQueueingAllowed: true
        )
        let customWidth: CGFloat = 100
        let notification = UINotification(content: UINotificationContent(title: "test"), style: CustomStyle(maxWidth: customWidth))

        notificationCenter.show(notification: notification)

        await waitForCondition(notificationCenter.currentPresenter?.presentationContext.notificationView.frame.size.width == customWidth, timeout: 5.0, description: "Max width should be applied to the view")
    }

    /// When using the manual dismiss trigger, the notification should only dismiss after manually called.
    func testManualDismissTrigger() async {
        let notificationCenter = UINotificationCenter()
        notificationCenter.configuration = UINotificationCenterConfiguration(
            presenterType: MockPresenter.self,
            isDuplicateQueueingAllowed: true
        )
        let dismissTrigger = UINotificationManualDismissTrigger()
        
        notificationCenter.show(notification: notification, dismissTrigger: dismissTrigger)

        await waitForCondition(notificationCenter.currentPresenter?.dismissTrigger.target != nil, timeout: 5.0, description: "Dismiss trigger target should be set")
        XCTAssert((notificationCenter.currentPresenter as! MockPresenter).presented == true, "Notification should be presented")
        XCTAssert((notificationCenter.currentPresenter as! MockPresenter).dismissed == false, "Notification should not be dismissed")
        
        dismissTrigger.trigger()

        await waitForCondition(notificationCenter.currentPresenter == nil, timeout: 5.0, description: "The presenter should be nil after dismiss is finished")
    }
    
    /// When a touch is within the notification UIWindow bounds, it should only be handled when inside a presented notification.
    func testNotificationWindowTouches() async {
        let notificationCenter = UINotificationCenter()
        notificationCenter.configuration = UINotificationCenterConfiguration(
            presenterType: MockPresenter.self,
            isDuplicateQueueingAllowed: true
        )
        let dismissTrigger = UINotificationManualDismissTrigger()
        
        XCTAssert(notificationCenter.window.point(inside: CGPoint(x: 0, y: 10), with: nil) == false, "When not presenting anything, the window should not handle touches.")

        notificationCenter.show(notification: notification, dismissTrigger: dismissTrigger)
        
        // Wait till the notification is presented
        await waitForCondition(notificationCenter.currentPresenter?.dismissTrigger.target != nil, timeout: 5.0, description: "Dismiss trigger target should be set")

        let notificationViewFrameOrigin = notificationCenter.currentPresenter!.presentationContext.notificationView.frame.origin

        XCTAssert(notificationCenter.currentPresenter?.presentationContext.containerWindow.point(inside: CGPoint(x: notificationViewFrameOrigin.x, y: notificationViewFrameOrigin.y + 1), with: nil) == true, "Point inside the notification view should be handled")
        XCTAssert(notificationCenter.currentPresenter?.presentationContext.containerWindow.point(inside: CGPoint(x: notificationViewFrameOrigin.x, y: notificationViewFrameOrigin.y - 1), with: nil) == false, "Point outside the notification view should not be handled")
    }
}
