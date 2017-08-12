//
//  LoginViewController.swift
//  The Map
//
//  Created by Alan Campos on 8/11/17.
//  Copyright © 2017 Alan Campos. All rights reserved.
//

import Foundation
import UIKit

class LoginViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginRegionView: UIView!
    
    let delegate = UIApplication.shared.delegate as! AppDelegate
    let connection = UConnectionConfig.shared.instance
    
    override var shouldAutorotate: Bool {
        
        return false
        
    }
    
    override func viewDidLoad() {

        registerForKeyboardNotifications()
        
        userNameTextField.delegate = self
        passwordTextField.delegate = self
        
    }
    
    @IBAction private func loginPressed(_ sender: Any) {
        
        let username = userNameTextField.text
        let password = passwordTextField.text
        
        connection.loginToUdacityAccount(username: username!, password: password!) {
            data, success, error in
            
            if success! {
                
                self.delegate.user = User(sessionID: data?.userSessionID, uniqueID: data?.userUniqueKey)
                
                self.completeLogin()
                
            } else {
                
                performUIUpdatesOnMain { self.alertUser(title: "Error", message: error!, actionName: "Dismiss") }
                
            }
            
        }
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    
        self.view.endEditing(true)
    
        return false
        
    }
    
    private func getKeyboardHeight(_ notification: Notification) -> CGFloat {
        
        let userInfo = notification.userInfo
        
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue
        
        return keyboardSize.cgRectValue.height
        
    }
    
    func keyboardWillShow(_ notification: Notification) {
        
        let keyboardHeight = getKeyboardHeight(notification)
        
        var viewDistanceToBottom: CGFloat {
            
            let loginRegionViewCoordinateY = loginRegionView.frame.origin.y
            let loginRegionViewHeight = loginRegionView.frame.size.height
            let viewHeight = self.view.frame.size.height
            
            return (viewHeight - (loginRegionViewCoordinateY + loginRegionViewHeight))
            
        }
        
        if keyboardHeight > viewDistanceToBottom {
            
            self.view.frame.origin.y = 0
            self.view.frame.origin.y -= (keyboardHeight - viewDistanceToBottom) + 5
            
        }
        
    }
    
    func keyboardWilldHide() {
        
        self.view.frame.origin.y = 0
        
    }
    
    private func completeLogin() {
        
        performSegue(withIdentifier: "LoginViewSegue", sender: nil)
        
    }
    
    
    func registerForKeyboardNotifications() {
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWilldHide), name: .UIKeyboardWillHide, object: nil)
        
    }
    
}

extension LoginViewController: UserAlertable {
    
    internal func alertUser(title: String, message: String, actionName: String) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        
        alert.addAction(UIAlertAction(title: actionName, style: UIAlertActionStyle.default, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
        
    }
    
}
