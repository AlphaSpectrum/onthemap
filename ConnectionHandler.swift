//
//  ConnectionHandler.swift
//  On The Map
//
//  Created by Alan Campos on 8/3/17.
//  Copyright © 2017 Alan Campos. All rights reserved.
//

import Foundation

protocol ConnectionHandler {
    func connect(to url: URL)
    
    func connect(to url: URL, httpHeaders: [String : String]?, method: RequestMethod, httpBody: String?, completionHandler: @escaping (_ data: Data?, _ success: Bool?, _ errorMessage: String?) -> Void)
    
    func performConnection(url: URL, httpHeaders: [String : String]?, method: RequestMethod, httpBody: String?, completionHandler: @escaping (_ data: Data?, _ sucess: Bool?, _ error: String?) -> Void)
    
    func formatAsURL(scheme: String?, host: String?, path: String?, query: String?) -> URL
}
