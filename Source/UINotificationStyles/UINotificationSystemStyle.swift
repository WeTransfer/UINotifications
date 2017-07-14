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
    public var font: UIFont = UIFont.systemFont(ofSize: 13, weight: UIFontWeightSemibold)
    public var backgroundColor: UIColor = UIColor.white
    public var textColor: UIColor = UIColor.black
    public var height: UINotificationHeight = .navigationBar
    public var interactive: Bool = true
}
