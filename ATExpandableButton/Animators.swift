//
//  Animators.swift
//  sidemenu
//
//  Created by Ahmed Eltabbal on 4/25/19.
//  Copyright © 2019 Ahmed Eltabbal. All rights reserved.
//

import UIKit

class FadePushAnimator: NSObject, UIViewControllerAnimatedTransitioning {
  
  open func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
    return 0.25
  }
  
  func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
    guard
      let toViewController = transitionContext.viewController(forKey: .to)
      else {
        return
    }
    transitionContext.containerView.addSubview(toViewController.view)
    toViewController.view.alpha = 0
    
    let duration = self.transitionDuration(using: transitionContext)
    UIView.animate(withDuration: duration, animations: {
      toViewController.view.alpha = 1
    }, completion: { _ in
      transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
    })
  }
}



class FadePopAnimator: NSObject, UIViewControllerAnimatedTransitioning {
  
  public enum TransitionType {
    case navigation
    case modal
  }
  
  let type: TransitionType
  let duration: TimeInterval
  
  init(type: TransitionType, duration: TimeInterval = 0.25) {
    self.type = type
    self.duration = duration
    
    super.init()
  }
  
  func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
    return self.duration
  }
  
  func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
    guard
      let fromViewController = transitionContext.viewController(forKey: .from)
      else {
        return
    }
    
    if self.type == .navigation, let toViewController = transitionContext.viewController(forKey: .to) {
      transitionContext.containerView.insertSubview(toViewController.view, belowSubview: fromViewController.view)
    }
    
    let duration = self.transitionDuration(using: transitionContext)
    UIView.animate(withDuration: duration, animations: {
      fromViewController.view.alpha = 0
    }, completion: { _ in
      transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
    })
  }
}
