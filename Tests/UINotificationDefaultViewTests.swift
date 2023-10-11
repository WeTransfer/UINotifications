//
//  UINotificationViewTests.swift
//  UINotificationsTests
//
//  Created by Antoine van der Lee on 14/07/2017.
//  Copyright © 2017 WeTransfer. All rights reserved.
//

import XCTest
@testable import UINotifications
import ConcurrencyExtras

@MainActor
final class UINotificationViewTests: UINotificationTestCase {
    
    override func invokeTest() {
        withMainSerialExecutor {
            super.invokeTest()
        }
    }

    /// When a notification view is tapped, the action trigger should be called.
    func testTapGesture() {
        let expectation = self.expectation(description: "Action should be triggered")
        let notification = UINotification(content: UINotificationContent(title: ""), action: UINotificationCallbackAction(callback: {
                expectation.fulfill()
        }))
        let notificationView = UINotificationView(notification: notification)
        notificationView.presenter = MockPresenter(presentationContext: UINotificationPresentationContext(request: UINotificationRequest(notification: notification, delegate: MockRequestDelegate(), notificationViewType: UINotificationView.self), containerWindow: UIWindow(), windowLevel: UIWindow.Level.statusBar, notificationView: notificationView), dismissTrigger: nil)
        notificationView.presenter?.present()
        notificationView.handleTapGestureRecognizer()
            
        waitForExpectations(timeout: 5.0, handler: nil)
    }
    
    /// When a notification view is tapped twice, the action trigger should be called only once.
    func testDoubleTap() {
        var actionTriggeredCount: Int = 0
        let notification = UINotification(content: UINotificationContent(title: ""), action: UINotificationCallbackAction(callback: {
            actionTriggeredCount += 1
        }))
        let notificationView = UINotificationView(notification: notification)
        notificationView.presenter = MockPresenter(presentationContext: UINotificationPresentationContext(request: UINotificationRequest(notification: notification, delegate: MockRequestDelegate(), notificationViewType: UINotificationView.self), containerWindow: UIWindow(), windowLevel: UIWindow.Level.statusBar, notificationView: notificationView), dismissTrigger: nil)
        notificationView.presenter?.present()
        
        notificationView.handleTapGestureRecognizer()
        XCTAssert(actionTriggeredCount == 1, "Action should be triggered")
        notificationView.handleTapGestureRecognizer()
        XCTAssert(actionTriggeredCount == 1, "Action should be triggered only once")
    }
    
    /// When the pan gesture is used, the animations should be handled by the default view.
    func testPanGesture() {
        let notificationView = UINotificationView(notification: notification)
        let presenter = MockPresenterCapturer(presentationContext: UINotificationPresentationContext(request: UINotificationRequest(notification: notification, delegate: MockRequestDelegate(), notificationViewType: UINotificationView.self), containerWindow: UIWindow(), windowLevel: UIWindow.Level.statusBar, notificationView: notificationView), dismissTrigger: nil)
        notificationView.presenter = presenter
        
        notificationView.handlePanGestureState(.began, translation: CGPoint.zero)
        XCTAssert((presenter.dismissTrigger as! UINotificationDurationDismissTrigger).dismissWorkItem == nil, "Dismiss trigger should be cancelled")
        
        notificationView.handlePanGestureState(.changed, translation: CGPoint(x: 0, y: notificationView.translationDismissLimit))
        XCTAssert(notificationView.topConstraint?.constant == notificationView.translationDismissLimit, "Top constraint constant should be changed")
        
        notificationView.handlePanGestureState(.ended, translation: CGPoint.zero)
        XCTAssert(presenter.dismissed == true, "When the translation dismiss limit is reached, the notification should be dismissed")
        
        notificationView.handlePanGestureState(.changed, translation: CGPoint(x: 0, y: 0))
        notificationView.handlePanGestureState(.ended, translation: CGPoint.zero)
        XCTAssert(presenter.presented == true, "When the translation dismiss limit is not reached, the notification should be presented again")
    }
    
    /// When the notification content updates, the view should inherit these changes.
    func testNotificationContentUpdate() async {
        let notificationView = UINotificationView(notification: notification)
        
        XCTAssert(notificationView.titleLabel.text == notification.content.title, "Title should match initial content")
        XCTAssert(notificationView.subtitleLabel.text == notification.content.subtitle, "Subtitle should match initial content")
        
        let updatedContent = UINotificationContent(title: "Updated title", subtitle: "Updated subtitle", image: LargeChevronStyle().chevronImage)
        notification.update(updatedContent)
        await Task.yield()

        XCTAssert(notificationView.titleLabel.text == updatedContent.title, "Title of the notification view should update accordingly")
        XCTAssert(notificationView.subtitleLabel.text == updatedContent.subtitle, "Subtitle of the notification view should update accordingly")
        XCTAssert(notificationView.imageView.image == updatedContent.image, "Image of the notification view should update accordingly")
    }
    
    /// It should add the button as a subview when set.
    func testButton() async {
        let notificationView = UINotificationView(notification: notification)
        
        XCTAssertNil(notificationView.button)

        notification.button = UIButton(type: .system)
        await Task.yield()
        XCTAssertNotNil(notificationView.button)
        XCTAssertNotNil(notificationView.button?.superview)
    }
    
    /// It should add the button as a subview when set, even after the notification is shown.
    func testButtonAfterShow() async {
        let notificationView = UINotificationView(notification: notification)

        UINotificationCenter.current.show(notification: notification, dismissTrigger: nil)
        
        XCTAssertNil(notificationView.button)
        notification.button = UIButton(type: .system)
        await Task.yield()
        XCTAssertNotNil(notificationView.button)
        XCTAssertNotNil(notificationView.button?.superview)
    }
    
}

private struct LargeChevronStyle: UINotificationStyle {
    var thumbnailSize: CGSize = CGSize(width: 20, height: 20)
    var titleFont: UIFont = UIFont.systemFont(ofSize: 13, weight: .semibold)
    var subtitleFont: UIFont = UIFont.systemFont(ofSize: 13, weight: .semibold)
    var titleTextColor: UIColor = UIColor.black
    var subtitleTextColor: UIColor = UIColor.black
    var backgroundColor: UIColor = UIColor.white
    var height: UINotification.Height {
        return UINotification.Height.navigationBar
    }
    var maxWidth: CGFloat?
    var interactive: Bool = true
    var chevronImage: UIImage? {
        let bundle = Bundle(for: UINotificationViewTests.self)
        return UIImage(named: "iconToastChevron", in: bundle, compatibleWith: nil)
    }
}
