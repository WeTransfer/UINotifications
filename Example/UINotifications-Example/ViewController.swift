//
//  ViewController.swift
//  UINotifications
//
//  Created by Antoine van der Lee on 05/29/2017.
//  Copyright (c) 2017 WeTransfer. All rights reserved.
//

import UIKit
import UINotifications

enum NotificationStyle: UINotificationStyle {
    case success
    case failure
    
    var font: UIFont {
        switch self {
        case .success:
            return UIFont.systemFont(ofSize: 15, weight: .semibold)
        case .failure:
            return UIFont.systemFont(ofSize: 13, weight: .regular)
        }
        
    }
    var backgroundColor: UIColor {
        switch self {
        case .success:
            return #colorLiteral(red: 0.4549019608, green: 0.8509803922, blue: 0.5215686275, alpha: 1)
        case .failure:
            return #colorLiteral(red: 1, green: 0.431372549, blue: 0.431372549, alpha: 1)
        }
        
    }
    var textColor: UIColor {
        return UIColor.white
    }
    
    /// The height of the notification which applies on the notification view.
    var height: UINotificationHeight {
        switch self {
        case .success:
            return UINotificationHeight.navigationBar
        case .failure:
            return UINotificationHeight.statusBar
        }
    }
    
    /// When `true`, the notification is swipeable and tappable.
    var interactive: Bool {
        return true
    }
    
    var chevronImage: UIImage? {
        return #imageLiteral(resourceName: "iconToastChevron")
    }
}

final class ViewController: UIViewController {

    @IBOutlet private weak var contentTextField: UITextField!
    @IBOutlet private weak var showButton: UIButton!
    
    @IBOutlet private weak var automaticallyDismissSwitch: UISwitch!
    @IBOutlet private weak var addActionSwitch: UISwitch!
    @IBOutlet private weak var successStyleSwitch: UISwitch!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        showButton.layer.cornerRadius = showButton.frame.size.height / 2
        
    }

    @IBAction func didTapShowNotificationButton(_ sender: UIButton) {
        let content = contentTextField.text?.isEmpty == true ? "Default content" : (contentTextField.text ?? "")
        var action: UINotificationAction?
        var dismissTrigger: UINotificationDismissTrigger = UINotificationDurationDismissTrigger(duration: 2.0)
        let style = successStyleSwitch.isOn ? NotificationStyle.success : NotificationStyle.failure
        
        if automaticallyDismissSwitch.isOn == false {
            dismissTrigger = UINotificationManualDismissTrigger()
        }
        
        if addActionSwitch.isOn {
            action = UINotificationCallbackAction(callback: {
                print("Tapped the notification!")
            })
        }
        
        let notification = UINotification(content: UINotificationContent(title: content), style: style, action: action)
        
        UINotificationCenter.current.show(notification: notification, dismissTrigger: dismissTrigger)
    }
}
