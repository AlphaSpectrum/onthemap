//
//  OAuthResponse.swift
//  On The Map
//
//  Created by Alan Campos on 7/24/17.
//  Copyright © 2017 Alan Campos. All rights reserved.
//

import Foundation

protocol Authentication {
    var data: Data? { get }
    var sessionID: String { get }
    var response: Data? { get }
}

struct LoginResponse: Authentication, JSONParsable {
    var data: Data?
    var sessionID: String {
        let jsonObject = convertToJSON(data: response!)
        let sessionDictionary = jsonObject["session"]
        return sessionDictionary!["id"] as! String
    }
    var response: Data? {
        get {
            let range = Range(5 ..< data!.count)
            let newData = data?.subdata(in: range)
            return newData
        }
    }
}
