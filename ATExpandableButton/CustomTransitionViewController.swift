//
//  CustomTransitionViewController.swift
//  TransitionButton
//
//  Created by Ahmed Eltabbal on 4/25/19.
//  Copyright © 2019 Ahmed Eltabbal. All rights reserved.
//

import UIKit

protocol didPopViewControllerDelegate: class {
  func didPopViewController()
}

class CustomTransitionViewController: UIViewController, didPopViewControllerDelegate {
  
  var interactionController: UIPercentDrivenInteractiveTransition?
  
  weak var didPopDelegate: didPopViewControllerDelegate?
  
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
  
  override func viewDidDisappear(_ animated: Bool) {
    super.viewDidDisappear(animated)
    didPopDelegate?.didPopViewController()
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
  
  func didPopViewController() {
    view.subviews.forEach { (view) in
      if let transitionBtn = view as? ATExpandableButton, transitionBtn.expanded {
        transitionBtn.returnToNormal()
      }
    }
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if let destination = segue.destination as? CustomTransitionViewController {
      destination.didPopDelegate = self
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


