//
//  ConnectionClient.swift
//  The Map
//
//  Created by Alan Campos on 8/11/17.
//  Copyright © 2017 Alan Campos. All rights reserved.
//

import Foundation

class ConnectionClient: RequestHandler {
    
    internal func performConnection(url: URL, httpHeaders: [String : String]?, method: ConnectionRequestMethod, httpBody: String?, completionHandler: @escaping (Data?, Bool?, String?) -> Void) {
        
        let request = NSMutableURLRequest(url: url)
        
        request.httpMethod = "\(method)".uppercased()
        
        func sendError(_ error: String?) {
            completionHandler(nil, false, error!)
        }
        
        if httpHeaders != nil {
            for (key, value) in httpHeaders! { request.addValue(value, forHTTPHeaderField: key) }
        }
        
        if httpBody != nil { request.httpBody = httpBody?.data(using: String.Encoding.utf8) }
        
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
    
    internal func makeURLUsing(queries: [String : AnyObject], withPathExtension: String? = nil) -> URL {
        
        var components = URLComponents()
        components.scheme = Constants.URL.scheme
        components.host = Constants.URL.host
        components.path = Constants.URL.path + (withPathExtension ?? "")
        components.queryItems = [URLQueryItem]()
        
        for (key, value) in queries {
            let queryItem = URLQueryItem(name: key, value: "\(value)")
            components.queryItems?.append(queryItem)
        }
        
        return components.url!

    }
}
