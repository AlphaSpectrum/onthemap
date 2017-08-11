//
//  Authentication.swift
//  The Map
//
//  Created by Alan Campos on 8/11/17.
//  Copyright © 2017 Alan Campos. All rights reserved.
//

import Foundation

internal extension UConnectionConfig {
    
    struct Authentication: JSONParsable {
        
        var userUniqueKey: String?
        var userSessionID: String?
        
        init(_ data: Data?) {
            
            let range = Range(5..<data!.count)
            let newData = data?.subdata(in: range)
            
            let JSONData = convertToJSON(data: newData!)
            
            let uniqueIDDic = JSONData["account"]
            let sessionIDDic = JSONData["session"]
            
            self.userUniqueKey = uniqueIDDic?["key"] as? String
            self.userSessionID = sessionIDDic?["id"] as? String
            
        }
        
    }
    
}
