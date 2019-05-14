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
    
    let smallX = view.frame.minX + 10
    let smallY = view.frame.minY + 10
    let width = (view.frame.width / 2) - 15
    
    let extendedFrame = CGRect(x: smallX, y: smallY, width: view.frame.width - 20, height: view.frame.height - 200)
    
    let expandableButton1 = createExpandableButton(frame: CGRect(x: smallX, y: smallY, width: width, height: width),
                                                   expandedFrame: extendedFrame,
                                                   innerView: innerView,
                                                   title: "Expandable Button 1")
    expandableButton1.backGroundColor = #colorLiteral(red: 0.1764705926, green: 0.01176470611, blue: 0.5607843399, alpha: 1)
    expandableButton1.iconImage = UIImage(named: "listIcon")
    expandableButton1.innerViewBackgroundColor = .clear
    
    let expandableButton2 = createExpandableButton(frame: CGRect(x: smallX + width + 10, y: smallY, width: width, height: width),
                                                   expandedFrame: extendedFrame,
                                                   innerView: innerView,
                                                   title: "Expandable Button 2")
    expandableButton2.backGroundColor = #colorLiteral(red: 0.1215686277, green: 0.01176470611, blue: 0.4235294163, alpha: 1)
    expandableButton2.iconImage = UIImage(named: "listIcon")
    expandableButton2.innerViewBackgroundColor = .clear
    expandableButton2.keepsIconWhenExpanded = false
    expandableButton2.keepsTitleWhenExpanded = false
    
    let transitionButton = createTransitionButton(frame: CGRect(x: smallX, y: smallY + width + 10, width: width, height: width),
                                                  title: "Navigation Transition")
    transitionButton.iconImage = UIImage(named: "transitionIcon")
    transitionButton.backGroundColor = #colorLiteral(red: 0.08570287377, green: 0.3641412854, blue: 0.6271670461, alpha: 1)
    transitionButton.tag = 1
    transitionButton.delegate = self
    
    let transitionButton2 = createTransitionButton(frame: CGRect(x: smallX + width + 10, y: smallY + width + 10, width: width, height: width),
                                                   title: "Transition Modally")
    transitionButton2.iconImage = UIImage(named: "transitionIcon")
    transitionButton2.backGroundColor = #colorLiteral(red: 0.04904369265, green: 0.1762623787, blue: 0.2822244465, alpha: 1)
    transitionButton2.tag = 2
    transitionButton2.delegate = self
    
    view.addSubview(expandableButton1)
    view.addSubview(expandableButton2)
    view.addSubview(transitionButton)
    view.addSubview(transitionButton2)
  }

  private func createExpandableButton(frame: CGRect, expandedFrame: CGRect, innerView: UIView, title: String) -> ATExpandableButton {
    let newButton = ATExpandableButton(frame: frame, expandedFrame: expandedFrame, innerView: innerView, title: title)
    newButton.iconTint = #colorLiteral(red: 0.6947761178, green: 0.8313210607, blue: 0.8782641292, alpha: 1)
    newButton.titleColor = #colorLiteral(red: 0.6947761178, green: 0.8313210607, blue: 0.8782641292, alpha: 1)
    return newButton
  }
  
  private func createTransitionButton(frame: CGRect, title: String) -> ATExpandableButton {
    let newButton = ATExpandableButton(frame: frame, title: title)
    newButton.iconTint = #colorLiteral(red: 0.6947761178, green: 0.8313210607, blue: 0.8782641292, alpha: 1)
    newButton.titleColor = #colorLiteral(red: 0.6947761178, green: 0.8313210607, blue: 0.8782641292, alpha: 1)
    return newButton
  }
  
  func didEndTransitionAnimation(_ button: ATExpandableButton) {
    switch button.tag {
    case 1:
      performSegue(withIdentifier: "toVC2", sender: nil)
    case 2:
      performSegue(withIdentifier: "toVC3", sender: nil)
    default:
      break
    }
    
  }


  
}

