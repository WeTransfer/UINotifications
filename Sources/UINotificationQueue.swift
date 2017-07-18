//
//  UINotificationQueue.swift
//  Coyote
//
//  Created by Antoine van der Lee on 18/05/2017.
//  Copyright © 2017 WeTransfer. All rights reserved.
//

import Foundation

internal protocol UINotificationQueueDelegate: class {
    
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
    
    /// Adds the given notification to the queue.
    ///
    /// - Parameter notification: The notification which is requested.
    /// - Parameter dismissTrigger: Optional dismiss trigger to use for the animation. If `nil` the default trigger will be used.
    /// - Returns: The notification request which is added to the queue. Can be used to `cancel()`.
    @discardableResult func add(_ notification: UINotification, dismissTrigger: UINotificationDismissTrigger? = nil) -> UINotificationRequest {
        let request = UINotificationRequest(notification: notification, delegate: self, dismissTrigger: dismissTrigger)
        lockQueue.sync {
            requests.append(request)
        }
        updateRunningRequest()
        return request
    }
    
    internal func remove(_ request: UINotificationRequest) {
        lockQueue.sync {
            guard let index = requests.index(where: { $0 == request }) else { return }
            requests.remove(at: index)
        }
        updateRunningRequest()
    }
    
    internal func updateRunningRequest() {
        guard requestIsRunning() == false, let request = nextRequestToRun() else { return }
        request.start()
        delegate?.handle(request)
    }
    
    internal func requestIsRunning() -> Bool {
        return requests.lazy.first(where: { $0.state == .running }) != nil
    }
    
    internal func nextRequestToRun() -> UINotificationRequest? {
        return requests.lazy.first(where: { $0.state == .idle })
    }
}

extension UINotificationQueue: UINotificationRequestDelegate {
    func notificationRequest(_ request: UINotificationRequest, didChangeStateTo state: UINotificationRequest.UINotificationRequestState) {
        switch state {
        case .finished, .cancelled:
            remove(request)
        default:
            break
        }
    }
}
