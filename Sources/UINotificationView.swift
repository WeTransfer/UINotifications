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
    
    var imageViewWidthConstraint: NSLayoutConstraint?
    var imageViewHeightConstraint: NSLayoutConstraint?
    
    /// The limit of translation before we will dismiss the notification.
    internal let translationDismissLimit: CGFloat = -15
    
    // MARK: UI Elements
    /// Saved to use for resetting the spacing after an image is shown or hidden.
    private let containerStackViewDefaultSpacing: CGFloat = 14
    
    private lazy var containerStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = self.containerStackViewDefaultSpacing
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.alignment = .center
        
        return stackView
    }()
    
    /// Override this to change the order of subviews. For example, to show the subtitle above the title.
    open var arrangedSubviews: [UIView] {
        return [self.titleLabel, self.subtitleLabel]
    }
    
    open private(set) lazy var titlesStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: arrangedSubviews)
        stackView.axis = .vertical
        stackView.spacing = 0
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.alignment = .fill
        return stackView
    }()
    
    public lazy var titleLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    public lazy var subtitleLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    public lazy var imageView: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 5
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    public lazy var chevronImageView: UIImageView = {
        let imageView = UIImageView(image: self.notification.style.chevronImage)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    var button: UIButton? {
        let button = self.notification.button
        button?.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }
    
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
    
    public required init(notification: UINotification) {
        self.notification = notification
        super.init(frame: CGRect.zero)
        notification.delegate = self
        setupView()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Setup
    open func setupView() {
        translatesAutoresizingMaskIntoConstraints = false
        isUserInteractionEnabled = true
        
        layoutMargins = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
        addArrangedSubviewsForContainerStackView()
        addSubview(containerStackView)
        
        setupConstraints()
        updateForNotificationData()
        addGestureRecognizer(panGestureRecognizer)
        addGestureRecognizer(tapGestureRecognizer)
    }
    
    open func updateForNotificationData() {
        titleLabel.text = notification.content.title
        titleLabel.font = notification.style.titleFont
        titleLabel.textColor = notification.style.titleTextColor
        
        subtitleLabel.text = notification.content.subtitle
        subtitleLabel.font = notification.style.subtitleFont
        subtitleLabel.textColor = notification.style.subtitleTextColor
        
        imageView.image = notification.content.image
        imageView.isHidden = notification.content.image == nil
        imageViewWidthConstraint?.constant = notification.style.thumbnailSize.width
        imageViewHeightConstraint?.constant = notification.style.thumbnailSize.height
        
        backgroundColor = notification.style.backgroundColor
        
        chevronImageView.tintColor = notification.style.titleTextColor
        chevronImageView.isHidden = notification.action == nil
        
        panGestureRecognizer.isEnabled = notification.style.interactive
        tapGestureRecognizer.isEnabled = notification.style.interactive
    }
    
    open func updateForButton() {
        guard !subviews.isEmpty else { return }
        subviews.forEach { subview in
            subview.removeFromSuperview()
        }

        setupView()
    }
    
    /// Called when all constraints should be setup for the notification. Can be overwritten to set your own constraints.
    /// When setting your own constraints, you should not be calling super.
    open func setupConstraints() {
        imageViewWidthConstraint = imageView.widthAnchor.constraint(equalToConstant: 31)
        imageViewHeightConstraint = imageView.heightAnchor.constraint(equalToConstant: 31)
        
        let constraints = [
            containerStackView.leftAnchor.constraint(equalTo: layoutMarginsGuide.leftAnchor, constant: 18),
            containerStackView.rightAnchor.constraint(equalTo: layoutMarginsGuide.rightAnchor, constant: -18),
            containerStackView.topAnchor.constraint(equalTo: topAnchor, constant: layoutMargins.top),
            containerStackView.bottomAnchor.constraint(equalTo: layoutMarginsGuide.bottomAnchor, constant: 0),
            
            chevronImageView.widthAnchor.constraint(equalToConstant: chevronImageView.image?.size.width ?? 0),
            
            imageViewWidthConstraint!,
            imageViewHeightConstraint!
        ]
        
        button?.setContentHuggingPriority(.defaultHigh, for: .horizontal)

        NSLayoutConstraint.activate(constraints)
    }
    
    private func addArrangedSubviewsForContainerStackView() {
        var arrangedSubviews = [self.imageView, self.titlesStackView, self.chevronImageView]
        
        if let button = self.button {
            arrangedSubviews.insert(button, at: arrangedSubviews.count - 1)
        }
        
        containerStackView.arrangedSubviews.forEach { (view) in
            containerStackView.removeArrangedSubview(view)
        }
        
        arrangedSubviews.forEach { (view) in
            containerStackView.addArrangedSubview(view)
        }
    }
    
    @objc internal func handleTapGestureRecognizer() {
        guard let presenter = presenter, presenter.state == UINotificationPresenterState.presented else { return }
        notification.action?.execute()
        presenter.dismiss()
    }
    
    @objc private func handlePanGestureRecognizer() {
        let translation = panGestureRecognizer.translation(in: self)
        handlePanGestureState(panGestureRecognizer.state, translation: translation)
    }
    
    internal func handlePanGestureState(_ state: UIGestureRecognizer.State, translation: CGPoint) {
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
                (presenter.dismissTrigger as? UINotificationSchedulableDismissTrigger)?.schedule()
            }
        }
    }
}

extension UINotificationView: UINotificationDelegate {
    
    func didUpdateContent(in notificaiton: UINotification) {
        updateForNotificationData()
    }
    
    func didUpdateButton(in notificaiton: UINotification) {
        updateForButton()
    }
    
}

extension NSLayoutConstraint {
    
    /// Returns the constraint sender with the passed priority.
    ///
    /// - Parameter priority: The priority to be set.
    /// - Returns: The sended constraint adjusted with the new priority.
    func usingPriority(_ priority: UILayoutPriority) -> NSLayoutConstraint {
        self.priority = priority
        return self
    }
    
}
