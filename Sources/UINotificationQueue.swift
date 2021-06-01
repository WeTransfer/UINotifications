//
//  UINotificationQueue.swift
//  Coyote
//
//  Created by Antoine van der Lee on 18/05/2017.
//  Copyright © 2017 WeTransfer. All rights reserved.
//

import Foundation

internal protocol UINotificationQueueDelegate: AnyObject {
    
    /// Will be called when a new request is ready to be handled.
    /// Will be called immediately if no request is currently running.
    /// If a request is currently handled, this will be called when that request is finished or cancelled.
    ///
    /// - Parameter request: The request to handle with the presenter.
    func handle(_ request: UINotificationRequest)
}

internal final class UINotificationQueue {
    
    /// The currently queued requests.
    internal var requests = [UINotificationRequest]()
    private weak var delegate: UINotificationQueueDelegate?
    
    /// The queue which is used to make sure the requests array is only modified serially.
    private let lockQueue = DispatchQueue(label: "com.uinotifications.LockQueue") // Defaults to a serial queue
    
    init(delegate: UINotificationQueueDelegate) {
        self.delegate = delegate
    }
    
    /// Adds the given notification to the queue. If `allowDuplicates` is `false`, the returned notification request can have a cancelled state directly after creation.
    ///
    /// - Parameters:
    ///   - notification: The notification which is requested.
    ///   - notificationViewType: The type of `UINotificationView` to use for presenting.
    ///   - dismissTrigger: The dismiss trigger which handles dismissing.
    ///   - allowDuplicates: If `true`, the notification will be queued in all cases.
    /// - Returns: The created notification request.
    @discardableResult func add(_ notification: UINotification, notificationViewType: UINotificationView.Type, dismissTrigger: UINotificationDismissTrigger? = nil, allowDuplicates: Bool = false) -> UINotificationRequest {
        let request = UINotificationRequest(notification: notification, delegate: self, notificationViewType: notificationViewType, dismissTrigger: dismissTrigger)
        
        if !allowDuplicates, requests.contains(where: { (queuedRequest) -> Bool in
            return queuedRequest.notification == request.notification
        }) {
            request.cancel()
        }
        
        lockQueue.sync {
            if request.state == .idle {
                requests.append(request)
            }
        }
        updateRunningRequest()
        return request
    }
    
    internal func remove(_ request: UINotificationRequest) {
        lockQueue.sync {
            requests.removeAll(where: { $0 == request })
        }
        updateRunningRequest()
    }
    
    internal func updateRunningRequest() {
        guard requestIsRunning() == false, let request = nextRequestToRun() else { return }
        request.start()
        delegate?.handle(request)
    }
    
    internal func requestIsRunning() -> Bool {
        return requests.lazy.contains(where: { $0.state == .running })
    }
    
    internal func nextRequestToRun() -> UINotificationRequest? {
        return requests.lazy.first(where: { $0.state == .idle })
    }
}

extension UINotificationQueue: UINotificationRequestDelegate {
    func notificationRequest(_ request: UINotificationRequest, didChangeStateTo state: UINotificationRequest.State) {
        switch state {
        case .finished, .cancelled:
            remove(request)
        default:
            break
        }
    }
}
