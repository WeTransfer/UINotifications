//
//  UINotificationPresenter.swift
//  Coyote
//
//  Created by Antoine van der Lee on 17/05/2017.
//  Copyright © 2017 WeTransfer. All rights reserved.
//

import UIKit

public protocol UINotificationPresenter: class, Dismissable {
    /// Provides information about an in-progress notification presentation.
    var presentationContext: UINotificationPresentationContext { get }
    
    var dismissTrigger: UINotificationDismissTrigger { get }
    
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
