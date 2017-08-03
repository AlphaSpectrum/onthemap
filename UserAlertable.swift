//
//  UserAlertable.swift
//  On The Map
//
//  Created by Alan Campos on 8/3/17.
//  Copyright © 2017 Alan Campos. All rights reserved.
//

protocol UserAlertable {
    typealias WithFunc = () -> ()
    func alertUserOfError(title: String, message: String, actionName: String, completion: WithFunc)
}
