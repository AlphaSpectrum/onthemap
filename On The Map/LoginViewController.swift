//
//  LoginViewController.swift
//  On The Map
//
//  Created by Alan Campos on 7/18/17.
//  Copyright © 2017 Alan Campos. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, JSONParsable {
    
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var debugLabel: UILabel!
    @IBOutlet weak var warningLabel: UILabel!
    
    var connection: CConnection?
    var response: LoginData?
    
    override var shouldAutorotate: Bool {
        return false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let delegate  = UIApplication.shared.delegate as! AppDelegate
        connection = delegate.connection
        warningLabel.text = ""
        usernameTextField.text = "abcd"
        passwordTextField.text = "123446"
        login(self)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
                
                let pass = true
                // Bypass login window
                // Don't forget to change pass back to success
                performUIUpdatesOnMain {
                    if pass {
                        if let data = data {
                            self.response = LoginData(data: data)
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
