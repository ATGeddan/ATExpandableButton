//
//  ATExpandableButton.swift
//  sidemenu
//
//  Created by Ahmed Eltabbal on 4/22/19.
//  Copyright © 2019 Ahmed Eltabbal. All rights reserved.
//

import UIKit

/// The delegate of 'ATExpandableButton' for using transition type button must adopt this protocol. It allows performing segues at animation completion
protocol ATTransitionButtonDelegate: class {
  func didEndTransitionAnimation(_ button: ATExpandableButton)
}

class ATExpandableButton: UIView {
  
  /// Title of the button.
  open var title = "Expandable" {
    didSet {
      titleLabel.text = title
    }
  }
  
  /// Font of the title
  open var titleFont: UIFont? {
    didSet {
      guard titleFont != nil else {return}
      titleLabel.font = titleFont
    }
  }
  
  /// Text color of the title.
  open var titleColor = #colorLiteral(red: 0.937254902, green: 0.937254902, blue: 0.9568627451, alpha: 1) {
    didSet {
      titleLabel.textColor = titleColor
    }
  }
  
  /// Background color for inner View
  open var innerViewBackgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0) {
    didSet {
      expandedChildView.backgroundColor = innerViewBackgroundColor
    }
  }
  
  /// Background color for main button
  open var backGroundColor: UIColor = #colorLiteral(red: 0.5725490451, green: 0, blue: 0.2313725501, alpha: 1) {
    didSet {
      backgroundColor = backGroundColor
    }
  }
  
  /// Image for button icon
  open var iconImage: UIImage? {
    didSet {
      guard let image = iconImage else {
        iconImageView.isHidden = true
        return
      }
      iconImageView.isHidden = false
      iconImageView.image = image
    }
  }
  
  /// tint color for icon image
  open var iconTint: UIColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0) {
    didSet {
      iconImageView.tintColor = iconTint
    }
  }
  
  /// Decides if title should relocate to top after expansion or disappear. default is true
  open var keepsTitleWhenExpanded = true
  
  /// Decides if icon should relocate to top after expansion or disappear. default is true
  open var keepsIconWhenExpanded = true
  
  /// Returns the state of the button either normal or expanded.
  open var expanded: Bool {
    return _expanded
  }
  
  /// Sets the frame of the button in the normal state.
  open var originalFrame: CGRect?
  
  /// Sets the frame of the button in the expanded state.
  open var expandedFrame: CGRect?
  
  weak var delegate: ATTransitionButtonDelegate?
  
  
  private var originalLabelFrame: CGRect!
  private var originalIconFrame: CGRect!
  private var iconImageView = UIImageView()
  private var expandedChildView = UIView()
  private var titleLabel: UILabel!
  private var _expanded = false
  
  /// init for expanding type button
  public init(frame: CGRect, expandedFrame: CGRect, innerView: UIView, title: String) {
    super.init(frame: frame)
    originalFrame = frame
    self.expandedFrame = expandedFrame
    self.title = title
    let tap = UITapGestureRecognizer(target: self, action: #selector(handleExpandTap))
    addGestureRecognizer(tap)
    innerView.frame = expandedChildView.frame
    expandedChildView = innerView
    setup()
  }
  
  /// init for transition type button
  public init(frame: CGRect, title: String) {
    super.init(frame: frame)
    originalFrame = frame
    self.title = title
    let tap = UITapGestureRecognizer(target: self, action: #selector(handleTransitionTap))
    addGestureRecognizer(tap)
    setup()
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }
  
  private func setup() {
    isUserInteractionEnabled = true
    clipsToBounds = true
    layer.cornerRadius = 8
    originalLabelFrame = CGRect(x: 2, y: frame.height / 1.5, width: frame.width - 4, height: frame.height * 1/3)
    originalIconFrame = CGRect(x: 10, y: 10, width: frame.size.width * 0.5, height: frame.size.height * 0.5)
    setupIcon()
    setupTitle()
  }
  
  private func setupExpandedView() {
    guard let expandedFrame = expandedFrame ?? calculateExpandedFrame() else {return}
    let newHeight = (keepsIconWhenExpanded && keepsTitleWhenExpanded) ? expandedFrame.height - 55 : expandedFrame.height - 10
    expandedChildView.frame = CGRect(x: 5, y: (keepsIconWhenExpanded && keepsTitleWhenExpanded) ? 50 : 5, width: expandedFrame.size.width - 10, height: newHeight)
    expandedChildView.clipsToBounds = true
    expandedChildView.alpha = 0
  }
  
  private func toggleExpandedView() {
    switch _expanded {
    case false:
      addSubview(expandedChildView)
      expandedChildView.alpha = 1
    case true:
      expandedChildView.removeFromSuperview()
    }
  }
  
  func calculateExpandedFrame() -> CGRect! {
    guard originalFrame != nil, let superFrame = superview?.frame else {return nil}
    let newHeight = superFrame.maxY - 50
    return CGRect(x: superFrame.minX + 10, y: 40, width: superFrame.size.width - 20, height: newHeight)
  }
  
  @objc private func handleExpandTap() {
    _expanded ? collapse() : expand()
  }
  
  @objc private func handleTransitionTap() {
    performTransitionAnimation()
  }
  
  private func createTitleLabel() -> UILabel {
    let label = UILabel()
    label.text = title
    label.font = UIFont(name: "AvenirNext-DemiBold", size: 24.0)
    label.adjustsFontSizeToFitWidth = true
    label.numberOfLines = 2
    label.textAlignment = .center
    label.textColor = titleColor
    
    return label
  }
  
  private func setupTitle() {
    titleLabel = createTitleLabel()
    titleLabel.frame = originalLabelFrame
    titleLabel.text = title
    titleLabel.textColor = titleColor
    addSubview(titleLabel)
  }
  
  private func setupIcon() {
    iconImageView.frame = originalIconFrame
    iconImageView.contentMode = .scaleAspectFit
    addSubview(iconImageView)
  }
  
  /// Expand the button and show the child view
  func expand() {
    guard originalFrame != nil, let expandedFrame = expandedFrame ?? calculateExpandedFrame() else {return}
    setupExpandedView()
    hideOthers()
    titleLabel.textAlignment = .left
    UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseIn, animations: {
      self.frame = expandedFrame
      self.moveOrHideTitleAndIcon(expanding: true)
      self.toggleExpandedView()
    })
    _expanded = true
  }
  
  /// Collapse the button and pop other buttons on superview
  func collapse() {
    guard let original = originalFrame else {return}
    titleLabel.textAlignment = .center
    UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut, animations: {
      self.frame = original
      self.moveOrHideTitleAndIcon(expanding: false)
      self.toggleExpandedView()
    },completion: {[weak self] _ in
      self?._expanded = false
    })
    popOthers()
  }
  
  private func moveOrHideTitleAndIcon(expanding: Bool) {
    if keepsTitleWhenExpanded {
      titleLabel.frame = expanding ? CGRect(x: frame.width * 0.15, y: 10, width: frame.size.width * 0.8, height: 40) : originalLabelFrame
    } else {
      titleLabel.alpha = expanding ? 0 : 1
    }
    
    if keepsIconWhenExpanded {
      iconImageView.frame = expanding ? CGRect(x: 2, y: 6, width: frame.width * 0.1, height: 40) : originalIconFrame
    } else {
      iconImageView.alpha = expanding ? 0 : 1
    }
  }
  
  private func hideOthers() {
    superview?.subviews.forEach({ (view) in
      guard let otherView = view as? ATExpandableButton, otherView != self else {return}
      UIView.animate(withDuration: 0.3, animations: {
        otherView.alpha = 0
      },completion: { _ in
        otherView.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
      })
    })
  }
  
  private func popOthers() {
    superview?.subviews.forEach({ (view) in
      guard let otherView = view as? ATExpandableButton, otherView != self else {return}
      otherView.alpha = 1
      UIView.animate(withDuration: 0.3, delay: 0.1, animations: {
        otherView.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
      },completion: { _ in
        UIView.animate(withDuration: 0.15, animations: {
          otherView.transform = CGAffineTransform(scaleX: 1, y: 1)
        })
      })
    })
  }
  
  /// Perform the transition animation which triggers the delegate method on completion.
  func performTransitionAnimation() {
    guard let superView = superview else {return}
    superView.bringSubviewToFront(self)
    hideOthers()
    UIView.animate(withDuration: 0.15) {
      self.subviews.forEach { (view) in
        view.alpha = 0
      }
    }
    UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseIn, animations: {
      self.frame = CGRect(x: -20, y: -20, width: superView.frame.size.width + 40, height: superView.frame.size.height + 40)
    }, completion:  { [weak self] _ in
      guard let strongSelf = self else {return}
      strongSelf.delegate?.didEndTransitionAnimation(strongSelf)
      strongSelf._expanded = true
    })
  }
  
  func returnToNormal() {
    guard let original = originalFrame else {return}
    UIView.animate(withDuration: 0.25, animations: {
      self.frame = original
    }, completion: { [weak self] _ in
      self?.popOthers()
      self?._expanded = false
      self?.subviews.forEach { (view) in
        view.alpha = 1
    }
    })
  }
  
}



extension UIView {
  
  class func fromNib<T: UIView>() -> T {
    return Bundle.main.loadNibNamed(String(describing: T.self), owner: nil, options: nil)![0] as! T
  }
  
}
