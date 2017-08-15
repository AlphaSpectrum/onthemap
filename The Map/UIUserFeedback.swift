//
//  UIUserFeedback.swift
//  The Map
//
//  Created by Alan Campos on 8/11/17.
//  Copyright © 2017 Alan Campos. All rights reserved.
//

import Foundation
import UIKit

protocol UIUserFeedback {
    
    func alertUser(_ presentingViewController: UIViewController, title: String, message: String, actionName: String, actionHandler: (() -> Void)?)
    func displayActivityIndicator(viewController: UIViewController, activityIndicator: UIActivityIndicatorView, isHidden: Bool)
}

extension UIUserFeedback {
    
    internal func alertUser(_ presentingViewController: UIViewController, title: String, message: String, actionName: String, actionHandler: (() -> Void)?) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: actionName, style: UIAlertActionStyle.default, handler: {
            action in
            actionHandler?()
        }))
        presentingViewController.present(alert, animated: true, completion: nil)
    }
    
    func displayActivityIndicator(viewController: UIViewController, activityIndicator: UIActivityIndicatorView, isHidden: Bool) {
        if isHidden {
            activityIndicator.stopAnimating()
        } else {
            activityIndicator.center = viewController.view.center
            activityIndicator.hidesWhenStopped = true
            activityIndicator.activityIndicatorViewStyle = .whiteLarge
            activityIndicator.frame = viewController.view.frame
            activityIndicator.backgroundColor = UIColor.black
            activityIndicator.alpha = 0.4
            viewController.view.addSubview(activityIndicator)
            activityIndicator.startAnimating()
        }
    }
}

