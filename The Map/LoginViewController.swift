//
//  LoginViewController.swift
//  The Map
//
//  Created by Alan Campos on 8/11/17.
//  Copyright © 2017 Alan Campos. All rights reserved.
//

import Foundation
import UIKit

class LogingViewController: UIViewController {
    
    let delegate = UIApplication.shared.delegate as! AppDelegate
    let connection = UConnectionConfig.shared.instance
    
    override var shouldAutorotate: Bool {
        
        return false
        
    }
    
    override func viewDidLoad() {
        
        connection.loginToUdacityAccount(username: "alancampos@me.com", password: "UkB-s54-JKE-KAF") {
            data, success, error in
            
            if success! {
                
                self.delegate.user = User(sessionID: data?.userSessionID, uniqueID: data?.userUniqueKey)

            } else {
                
                print(error ?? "no error")
                
            }
        
        }
        
    }
    
}
