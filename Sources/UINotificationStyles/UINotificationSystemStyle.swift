//
//  UINotificationSystemStyle.swift
//  Coyote
//
//  Created by Antoine van der Lee on 23/05/2017.
//  Copyright © 2017 WeTransfer. All rights reserved.
//

import UIKit

/// Defines the default style for notifications.
public struct UINotificationSystemStyle: UINotificationStyle {
    public var titleFont: UIFont = UIFont.systemFont(ofSize: 13, weight: .semibold)
    public var subtitleFont: UIFont = UIFont.systemFont(ofSize: 13, weight: .regular)
    public var backgroundColor: UIColor = UIColor.white
    public var titleTextColor: UIColor = UIColor.black
    public var subtitleTextColor: UIColor = UIColor.darkGray
    public var height: UINotification.Height = .navigationBar
    public var maxWidth: CGFloat?
    public var interactive: Bool = true
    public var chevronImage: UIImage?
    public var thumbnailSize: CGSize = .init(width: 31, height: 31)
    
    public init() { }
}
