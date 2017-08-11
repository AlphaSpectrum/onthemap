//
//  CConnection.swift
//  On The Map
//
//  Created by Alan Campos on 8/3/17.
//  Copyright © 2017 Alan Campos. All rights reserved.
//

import Foundation

struct CConnection: ConnectionHandler {
        
    func connect(to url: URL) {
        performConnection(url: url, httpHeaders: nil, method: .get, httpBody: nil) { _ in }
    }
    
    func connect(to url: URL, httpHeaders: [String : String]?, method: RequestMethod, httpBody: String?, completionHandler: @escaping (Data?, Bool?, String?) -> Void) {
        performConnection(url: url, httpHeaders: httpHeaders, method: method, httpBody: httpBody) {
            data, success, error in
            
            if success! {
                completionHandler(data, true, nil)
            } else {
                completionHandler(nil, false, error)
            }
        }
    }
    
    internal func performConnection(url: URL, httpHeaders: [String : String]?, method: RequestMethod, httpBody: String?, completionHandler: @escaping (Data?, Bool?, String?) -> Void) {
        
        let request = NSMutableURLRequest(url: url)
        request.httpMethod = "\(method)".uppercased()

        func sendError(_ error: String?) {
            completionHandler(nil, false, error!)
        }
        
        if httpHeaders != nil {
            for (key, value) in httpHeaders! {
                request.addValue(value, forHTTPHeaderField: key)
            }
        }
        
        if httpBody != nil {
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
                sendError("Server unresponsive.")
                return
            }
            
            completionHandler(data, true, nil)
        }
        
        task.resume()
    }
    
    func logout(url: URL, completionHandler: @escaping (_ success: Bool?, _ error: String?) -> Void) {
        let request = NSMutableURLRequest(url: url)
        request.httpMethod = "DELETE"
        var xsrfCookie: HTTPCookie? = nil
        let sharedCookieStorage = HTTPCookieStorage.shared
        
        func sendError(_ error: String?) {
            completionHandler(false, error!)
        }
        
        for cookie in sharedCookieStorage.cookies! {
            if cookie.name == "XSRF-TOKEN" { xsrfCookie = cookie }
        }
        if let xsrfCookie = xsrfCookie {
            request.setValue(xsrfCookie.value, forHTTPHeaderField: "X-XSRF-TOKEN")
        }
        let session = URLSession.shared
        let task = session.dataTask(with: request as URLRequest) { _ , response, error in
            
            guard (error == nil) else {
                sendError("No internet connection.")
                return
            }
            
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
                sendError("Invalid username or password.")
                return
            }
            
            completionHandler(true, nil)
        }
        
        task.resume()
    }
    
    func formatAsURL(scheme: String?, host: String?, path: String?, query: String?) -> URL {
        var url = URLComponents()
        url.scheme = scheme
        url.host = host
        url.path = path!
        url.query = query
        return url.url!
    }
}
