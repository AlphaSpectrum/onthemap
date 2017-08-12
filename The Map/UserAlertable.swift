//
//  UserAlertable.swift
//  The Map
//
//  Created by Alan Campos on 8/11/17.
//  Copyright © 2017 Alan Campos. All rights reserved.
//

import Foundation

protocol UserAlertable {
    
    typealias WithFunction = () -> ()
    
    func alertUser(title: String, message: String, actionName: String)
    
}
