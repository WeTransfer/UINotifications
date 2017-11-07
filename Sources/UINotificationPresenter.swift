//
//  UINotificationPresenter.swift
//  Coyote
//
//  Created by Antoine van der Lee on 17/05/2017.
//  Copyright © 2017 WeTransfer. All rights reserved.
//

import UIKit

/// The state of a notification presenter.
public enum UINotificationPresenterState {
    /// Ready to be presented.
    case idle
    /// Currently animating out.
    case dismissing
    
    /// Currently animatin in.
    case presenting
    
    /// Currently visible, presented.
    case presented
}

/// Defines a protocol for a UINotification presenter & dismisser.
public protocol UINotificationPresenter: Dismissable {
    /// Provides information about an in-progress notification presentation.
    var presentationContext: UINotificationPresentationContext { get }
    
    /// The trigger which can trigger the dismissing.
    var dismissTrigger: UINotificationDismissTrigger { get }
    
    /// Indicates the current state the presenter is in.
    var state: UINotificationPresenterState { get }
    
    /// Initialises a new instance of the presenter.
    ///
    /// - Parameter presentationContext: The context in which we're presenting.
    /// - Parameter dismissTrigger: The dismiss trigger to use for dismissing. If not passed, the default dismiss trigger should be used.
    init(presentationContext: UINotificationPresentationContext, dismissTrigger: UINotificationDismissTrigger?)
    
    /// Manages the presentation of the `UINotificationView`.
    func present()
    
    /// Manages the dismissing of the `UINotificationView`.
    func dismiss()
}
