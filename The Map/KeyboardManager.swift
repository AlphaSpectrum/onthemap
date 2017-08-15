//
//  KeyboardManager.swift
//  The Map
//
//  Created by Alan Campos on 8/13/17.
//  Copyright © 2017 Alan Campos. All rights reserved.
//

import Foundation
import UIKit
protocol KeyboardManager {
    func objectDistanceToBottomOf(currentView: UIViewController, objectToMeasure: AnyObject) -> CGFloat
    func getKeyboardHeight(_ notification: Notification) -> CGFloat
    func keyboardWillShow(_ notification: Notification)
    func keyboardWillHide()
    func registerForKeyboardNotifications()
}

extension KeyboardManager {
    func objectDistanceToBottomOf(currentView: UIViewController, objectToMeasure: AnyObject) -> CGFloat {
        let objcYCoordinate = objectToMeasure.frame.origin.y
        let objcHeight = objectToMeasure.frame.size.height
        let viewHeight = currentView.view.frame.size.height
        return (viewHeight - (objcYCoordinate + objcHeight))
    }
}
