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

    var titleFont: UIFont {
        switch self {
        case .success:
            return .systemFont(ofSize: 15, weight: .semibold)
        case .failure:
            return .systemFont(ofSize: 13, weight: .regular)
        }
    }

    var subtitleFont: UIFont {
        return .systemFont(ofSize: 13, weight: .regular)
    }

    var titleTextColor: UIColor {
        switch self {
        case .success:
            return .black
        case .failure:
            return .white
        }
    }

    var subtitleTextColor: UIColor {
        return .darkGray
    }

    var backgroundColor: UIColor {
        switch self {
        case .success:
            return #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        case .failure:
            return #colorLiteral(red: 1, green: 0.431372549, blue: 0.431372549, alpha: 1)
        }
    }

    var thumbnailSize: CGSize {
        return .init(width: 50, height: 50)
    }

    /// The height of the notification which applies on the notification view.
    var height: UINotification.Height {
        switch self {
        case .success:
            return .navigationBar
        case .failure:
            return .statusBar
        }
    }

    /// Use this to set a max width to the notification view.
    var maxWidth: CGFloat? {
        return nil
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

    @IBOutlet private weak var titleTextField: UITextField!
    @IBOutlet private weak var subtitleTextField: UITextField!
    @IBOutlet private weak var showButton: UIButton!

    @IBOutlet private weak var automaticallyDismissSwitch: UISwitch!
    @IBOutlet private weak var addActionSwitch: UISwitch!
    @IBOutlet private weak var addButtonSwitch: UISwitch!
    @IBOutlet private weak var showsImageSwitch: UISwitch!
    @IBOutlet private weak var successStyleSwitch: UISwitch!

    override func viewDidLoad() {
        super.viewDidLoad()

        showButton.layer.cornerRadius = showButton.frame.size.height / 2
    }

    @IBAction func didTapShowNotificationButton(_ sender: UIButton) {
        let title = titleTextField.text?.isEmpty == true ? "Default title" : (titleTextField.text ?? "")
        let subtitle = subtitleTextField.text?.isEmpty == true ? "Default subtitle" : (subtitleTextField.text ?? "")
        var action: UINotificationAction?
        var dismissTrigger: UINotificationDismissTrigger = UINotificationDurationDismissTrigger(duration: 2.0)
        let style = successStyleSwitch.isOn ? NotificationStyle.success : NotificationStyle.failure
        let image: UIImage? = showsImageSwitch.isOn ? #imageLiteral(resourceName: "banner") : nil

        if automaticallyDismissSwitch.isOn == false {
            dismissTrigger = UINotificationManualDismissTrigger()
        }

        if addActionSwitch.isOn {
            action = UINotificationCallbackAction(callback: {
                print("Tapped the notification!")
            })
        }

        let notification = UINotification(content: UINotificationContent(title: title, subtitle: subtitle, image: image), style: style, action: action)

        if addButtonSwitch.isOn {
            let button = UIButton(type: .system)
            button.setTitle("Button", for: .normal)
            button.addTarget(self, action: #selector(handleTapNotificationButton), for: .touchUpInside)
            notification.button = button
        }

        UINotificationCenter.current.show(notification: notification, dismissTrigger: dismissTrigger)
    }

    @objc func handleTapNotificationButton() {
        print("Tapped the button!")
    }
}
