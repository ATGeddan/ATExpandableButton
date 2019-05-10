//
//  CustomTransitionViewController.swift
//  TransitionButton
//
//  Created by Ahmed Eltabbal on 4/25/19.
//  Copyright © 2019 Ahmed Eltabbal. All rights reserved.
//

import UIKit

class CustomTransitionViewController: UIViewController {
  
  var interactionController: UIPercentDrivenInteractiveTransition?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    let edge = UIScreenEdgePanGestureRecognizer(target: self,
                                                action: #selector(self.handleEdgePan(_:)))
    edge.edges = .left
    view.addGestureRecognizer(edge)
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    
    self.navigationController?.delegate = self
  }
  
  @objc func handleEdgePan(_ gesture: UIScreenEdgePanGestureRecognizer) {
    let translate = gesture.translation(in: gesture.view)
    let percent = translate.x / gesture.view!.bounds.size.width
    
    switch gesture.state {
    case .began:
      self.interactionController = UIPercentDrivenInteractiveTransition()
      self.navigationController?.popViewController(animated: true)
    case .changed:
      self.interactionController?.update(percent)
    case .ended:
      let velocity = gesture.velocity(in: gesture.view)
      
      if percent > 0.5 || velocity.x > 0 {
        self.interactionController?.finish()
      }
      else {
        self.interactionController?.cancel()
      }
      self.interactionController = nil
    default:
      break
    }
  }
}

extension CustomTransitionViewController: UINavigationControllerDelegate {
  
  func navigationController(_ navigationController: UINavigationController,
                            interactionControllerFor animationController: UIViewControllerAnimatedTransitioning)
    -> UIViewControllerInteractiveTransitioning? {
      
      return self.interactionController
  }
  
  func navigationController(_ navigationController: UINavigationController,
                            animationControllerFor operation: UINavigationController.Operation,
                            from fromVC: UIViewController,
                            to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
    
    switch operation {
    case .push:
      return FadePushAnimator()
    case .pop:
      return FadePopAnimator(type: .navigation)
    default:
      return nil
    }
  }
}


