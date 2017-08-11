//
//  LoginViewController.swift
//  On The Map
//
//  Created by Alan Campos on 7/18/17.
//  Copyright © 2017 Alan Campos. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, JSONParsable, UITextFieldDelegate {
    
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var debugLabel: UILabel!
    @IBOutlet weak var warningLabel: UILabel!
    
    let delegate  = UIApplication.shared.delegate as! AppDelegate

    var connection: CConnection?    

    override var shouldAutorotate: Bool {
        return false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        connection = delegate.connection
        usernameTextField.delegate = self
        passwordTextField.delegate = self
        warningLabel.text = ""
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }

    @IBAction func login(_ sender: Any) {
        let requestHeaders = [
            "Accept"        : "application/json",
            "Content-Type"  : "application/json"
        ]
        
        if (usernameTextField.text?.isEmpty)! || (passwordTextField.text?.isEmpty)! {
            self.warningLabel.text = "Username or password is blank."
        } else {
            
            let httpBody = "{\"udacity\": {\"username\": \"" + usernameTextField.text! + "\", \"password\": \"" + passwordTextField.text! + "\"}}"
            
            let url = connection?.formatAsURL(scheme: Constants.URL.scheme, host: "www.udacity.com", path: "/api/session", query: nil)
            
            connection?.connect(to: url!, httpHeaders: requestHeaders, method: .post, httpBody: httpBody) {
                data, success, error in
                
                performUIUpdatesOnMain {
                    if success! {
                        if let data = data {
                            self.delegate.loginResponse = LoginData(data: data)
                        }
                        self.completeLogin()
                    } else {
                        self.warningLabel.text = error
                    }
                }
            }
        }
    }
    private func completeLogin() {
        self.performSegue(withIdentifier: "TabViewController", sender: nil)
    }
}
