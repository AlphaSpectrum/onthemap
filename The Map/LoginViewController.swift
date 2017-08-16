//
//  LoginViewController.swift
//  The Map
//
//  Created by Alan Campos on 8/11/17.
//  Copyright © 2017 Alan Campos. All rights reserved.
//

import Foundation
import UIKit

class LoginViewController: UIViewController, UITextFieldDelegate, UIUserFeedback, KeyboardManager {
    
    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginRegionView: UIView!
    
    let acitivyIndicator = UIActivityIndicatorView()
    
    override var shouldAutorotate: Bool {
        return false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerForKeyboardNotifications()
        userNameTextField.delegate = self
        passwordTextField.delegate = self
    }
    
    @IBAction private func loginPressed(_ sender: Any) {
        if (userNameTextField.text?.isEmpty)! || (passwordTextField.text?.isEmpty)! {
            alertUser(self, title: "", message: "Username and password cannot be blank.", actionName: "OK", actionHandler: nil)
        } else {
            let username = userNameTextField.text
            let password = passwordTextField.text
            displayActivityIndicator(viewController: self, activityIndicator: acitivyIndicator, isHidden: false)
            ConnectionHandler.shared.instance.loginToUdacityAccount(username: username!, password: password!) {
                data, success, error in
                
                if success! {
                    let userID = data?.userUniqueKey
                    let sessionID = data?.userSessionID
                    ConnectionHandler.shared.instance.getAuthenticatedStudentInformation(userID: userID!) {
                        name, errorMessage in
                        if errorMessage == nil {
                            let name = Name(first: (name?.first)!, last: (name?.last)!)
                            let student = StudentInformation(name: name, address: nil, mediaURL: "")
                            StudentModel.shared.user = User(sessionID: sessionID!, uniqueID: userID!, student: student)
                            performUIUpdatesOnMain{ self.completeLogin() }
                        } else {
                            performUIUpdatesOnMain {
                                self.alertUser(self, title: "Error", message: errorMessage!, actionName: "Dismiss", actionHandler: nil)
                            }
                        }
                        performUIUpdatesOnMain {
                            self.displayActivityIndicator(viewController: self, activityIndicator: self.acitivyIndicator, isHidden: true)
                        }
                    }
                } else {
                    performUIUpdatesOnMain {
                        self.displayActivityIndicator(viewController: self, activityIndicator: self.acitivyIndicator, isHidden: true)
                        self.alertUser(self, title: "Error", message: error!, actionName: "Dismiss", actionHandler: nil)
                    }
                }
            }
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    internal func getKeyboardHeight(_ notification: Notification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue
        return keyboardSize.cgRectValue.height
    }
    
    func keyboardWillShow(_ notification: Notification) {
        let keyboardHeight = getKeyboardHeight(notification)
        let viewDistanceToBottom = objectDistanceToBottomOf(currentView: self, objectToMeasure: loginRegionView)
        
        if keyboardHeight > viewDistanceToBottom {
            self.view.frame.origin.y = 0
            self.view.frame.origin.y -= (keyboardHeight - viewDistanceToBottom) + 5
        }
    }
    
    func keyboardWillHide() {
        self.view.frame.origin.y = 0
    }
    
    private func completeLogin() {
        self.performSegue(withIdentifier: "LoginViewSegue", sender: nil)
    }
    
    
    func registerForKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: .UIKeyboardWillHide, object: nil)
    }
}
