//
//  UINotificationView.swift
//  Coyote
//
//  Created by Antoine van der Lee on 17/05/2017.
//  Copyright © 2017 WeTransfer. All rights reserved.
//
//  danger:disable final_class

import UIKit

/// The default view which can be used for notification presentations.
/// Will present a title and a chevron with basic green and red colors for the notification Type.
open class UINotificationView: UIView {
    
    var presenter: UINotificationPresenter?
    internal let notification: UINotification
    
    /// Will be set by the presenter. Is used to animate the notification view with a pan gesture.
    var topConstraint: NSLayoutConstraint?
    
    /// The left and right margin of the contents.
    private let leftRightMargin: CGFloat = 20
    
    /// The limit of translation before we will dismiss the notification.
    internal let translationDismissLimit: CGFloat = -15
    
    // MARK: UI Elements
    lazy public var titleLabel: UILabel = {
        let label = UILabel(frame: CGRect.zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy internal var chevronImageView: UIImageView = {
        let imageView = UIImageView(image: self.notification.content.chevronImage)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    // MARK: Gestures
    internal fileprivate(set) lazy var panGestureRecognizer: UIPanGestureRecognizer = { [unowned self] in
        let gesture = UIPanGestureRecognizer()
        gesture.addTarget(self, action: #selector(UINotificationView.handlePanGestureRecognizer))
        
        return gesture
    }()
    
    internal fileprivate(set) lazy var tapGestureRecognizer: UITapGestureRecognizer = { [unowned self] in
        let gesture = UITapGestureRecognizer()
        gesture.addTarget(self, action: #selector(UINotificationView.handleTapGestureRecognizer))
        
        return gesture
    }()
    
    required public init(notification: UINotification) {
        self.notification = notification
        super.init(frame: CGRect.zero)
        notification.delegate = self
        setupView()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Setup
    internal func setupView() {
        translatesAutoresizingMaskIntoConstraints = false
        isUserInteractionEnabled = true
        
        addSubview(titleLabel)
        addSubview(chevronImageView)
        
        setupConstraints()
        updateForNotificationData()
        addGestureRecognizer(panGestureRecognizer)
        addGestureRecognizer(tapGestureRecognizer)
    }
    
    open func updateForNotificationData() {
        titleLabel.text = notification.content.title
        
        titleLabel.font = notification.style.font
        titleLabel.textColor = notification.style.textColor
        backgroundColor = notification.style.backgroundColor
        
        chevronImageView.tintColor = notification.style.textColor
        
        panGestureRecognizer.isEnabled = notification.style.interactive
        tapGestureRecognizer.isEnabled = notification.style.interactive
    }
    
    internal func setupConstraints() {
        let hasAction = notification.action != nil
        let constraints = [
            titleLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: leftRightMargin),
            titleLabel.topAnchor.constraint(equalTo: topAnchor),
            titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor),
            chevronImageView.leftAnchor.constraint(equalTo: titleLabel.rightAnchor, constant: leftRightMargin),
            chevronImageView.rightAnchor.constraint(equalTo: rightAnchor, constant: hasAction ? -leftRightMargin : 0),
            chevronImageView.widthAnchor.constraint(equalToConstant: hasAction ? (notification.content.chevronImage?.size.width ?? 0) : 0),
            chevronImageView.centerYAnchor.constraint(equalTo: centerYAnchor)
        ]
        
        NSLayoutConstraint.activate(constraints)
    }
    
    @objc internal func handleTapGestureRecognizer() {
        notification.action?.execute()
    }
    
    @objc private func handlePanGestureRecognizer() {
        let translation = panGestureRecognizer.translation(in: self)
        handlePanGestureState(panGestureRecognizer.state, translation: translation)
    }
    
    internal func handlePanGestureState(_ state: UIGestureRecognizerState, translation: CGPoint) {
        guard let presenter = presenter, let topConstraint = topConstraint else { return }
        
        if state == .began {
            (presenter.dismissTrigger as? UINotificationSchedulableDismissTrigger)?.cancel()
        } else if state == .changed {
            topConstraint.constant = min(translation.y, 0)
        } else {
            if topConstraint.constant <= translationDismissLimit {
                presenter.dismiss()
            } else {
                presenter.present()
            }
        }
    }
}

extension UINotificationView: UINotificationDelegate {
    func didUpdateContent(in notificaiton: UINotification) {
        updateForNotificationData()
    }
}
