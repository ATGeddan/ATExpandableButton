//
//  VC1.swift
//  ATExpandableButton
//
//  Created by Ahmed Eltabbal on 5/10/19.
//  Copyright © 2019 Ahmed Eltabbal. All rights reserved.
//

import UIKit

class VC1: CustomTransitionViewController, ATTransitionButtonDelegate {

  override func viewDidLoad() {
    super.viewDidLoad()
    
    let innerView: InnerView = .fromNib()
    innerView.titleLabel.text = "Inner View Title"
    
    let extendedFrame = CGRect(x: 20, y: 60, width: view.frame.width - 40, height: view.frame.height - 200)
    
    let expandableButton1 = createExpandableButton(frame: CGRect(x: 20, y: 60, width: 173, height: 173),
                                                   expandedFrame: extendedFrame,
                                                   innerView: innerView)
    expandableButton1.backGroundColor = #colorLiteral(red: 0.3098039329, green: 0.01568627544, blue: 0.1294117719, alpha: 1)
    expandableButton1.title = "Expandable Button 1"
    expandableButton1.iconImage = UIImage(named: "listIcon")
    expandableButton1.iconTint = #colorLiteral(red: 0.937254902, green: 0.937254902, blue: 0.9568627451, alpha: 1)
    expandableButton1.innerViewBackgroundColor = .clear
    
    let expandableButton2 = createExpandableButton(frame: CGRect(x: 203, y: 60, width: 173, height: 173),
                                                   expandedFrame: extendedFrame,
                                                   innerView: innerView)
    expandableButton2.backGroundColor = #colorLiteral(red: 0.05882352963, green: 0.180392161, blue: 0.2470588237, alpha: 1)
    expandableButton2.title = "Expandable Button 2"
    expandableButton2.iconImage = UIImage(named: "listIcon")
    expandableButton2.iconTint = #colorLiteral(red: 0.937254902, green: 0.937254902, blue: 0.9568627451, alpha: 1)
    expandableButton2.innerViewBackgroundColor = .clear
    expandableButton2.keepsIconWhenExpanded = false
    expandableButton2.keepsTitleWhenExpanded = false
    
    let transitionButton = createTransitionButton(frame: CGRect(x: 20, y: 260, width: 173, height: 173), title: "Transition Button")
    transitionButton.iconImage = UIImage(named: "transitionIcon")
    transitionButton.iconTint = #colorLiteral(red: 0.937254902, green: 0.937254902, blue: 0.9568627451, alpha: 1)
    transitionButton.backGroundColor = #colorLiteral(red: 0.4186429251, green: 0.148846794, blue: 0.404224254, alpha: 1)
    transitionButton.delegate = self
    
    view.addSubview(expandableButton1)
    view.addSubview(expandableButton2)
    view.addSubview(transitionButton)
  }

  private func createExpandableButton(frame: CGRect, expandedFrame: CGRect, innerView: UIView) -> ATExpandableButton {
    let newButton = ATExpandableButton(frame: frame, expandedFrame: expandedFrame, innerView: innerView)
    
    return newButton
  }
  
  private func createTransitionButton(frame: CGRect, title: String) -> ATExpandableButton {
    let newButton = ATExpandableButton(frame: frame, title: title)
    
    return newButton
  }
  
  func didEndTransitionAnimation(_ button: ATExpandableButton) {
    performSegue(withIdentifier: "toVC2", sender: nil)
  }

}

