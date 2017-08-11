//
//  RequestHandler.swift
//  The Map
//
//  Created by Alan Campos on 8/11/17.
//  Copyright © 2017 Alan Campos. All rights reserved.
//

import Foundation

protocol RequestHandler: JSONParsable {
    
    func performConnection(url: URL, httpHeaders: [String : String]?, method: ConnectionRequestMethod, httpBody: String?, completionHandler: @escaping (_ data: Data?, _ success: Bool?, _ error: String?) -> Void)
    
    func makeURLUsing(queries: [String : AnyObject], withPathExtension: String?) -> URL
    
}
