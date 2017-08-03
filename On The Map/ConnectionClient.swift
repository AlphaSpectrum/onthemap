//
//  LoginHandler.swift
//  On The Map
//
//  Created by Alan Campos on 7/18/17.
//  Copyright © 2017 Alan Campos. All rights reserved.
//
/*
import Foundation

class LoginHandler {
    
    var header = Header()
    var loginResponse = LoginResponse()
    
    
    public func login(to url: String, with headers: [String : String], httpBody: String, completionHandler: @escaping (_ sucess: Bool?, _ error: String?) -> Void) {
        header.url = url
        header.httpHeaderBody = headers
        establishConnection(withHeaders: true, method: .post, httpBody: httpBody) {
            data, success, errorMessage in
            
            if success! {
                self.loginResponse.data = data
                completionHandler(true, errorMessage)
            } else {
                completionHandler(false, errorMessage)
            }
        }
    }
    
    private func establishConnection(withHeaders: Bool?, method: RequestMethod, httpBody: String?, completionHandler: @escaping(_ returnData: Data?, _ sucess: Bool?, _ errorMessage: String?) -> Void) {
        
        let request = header.request
        
        func sendError(_ error: String?) {
            completionHandler(nil, false, error!)
        }
        
        if withHeaders! {
            request.httpMethod = "\(method)".uppercased()
            for head in header.httpHeader {
                request.addValue(head.value, forHTTPHeaderField: head.key)
            }
        }
        
        if (httpBody != nil) {
            request.httpBody = httpBody?.data(using: String.Encoding.utf8)
        }
        
        let session = URLSession.shared
        let task = session.dataTask(with: request as URLRequest) {
            data, response, error in
            
            guard (error == nil) else {
                sendError("No internet connection.")
                return
            }
            
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
                sendError("Invalid username or password.")
                return
            }
            
            guard let data = data else {
                sendError("Server unresponsive")
                return
            }
            
            completionHandler(data, true, nil)
        
        }
        
        task.resume()
    }
}*/
