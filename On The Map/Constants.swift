//
//  Constants.swift
//  On The Map
//
//  Created by Alan Campos on 7/18/17.
//  Copyright © 2017 Alan Campos. All rights reserved.
//

import Foundation

struct Constants {
    
    struct URL {
        static let scheme = "https"
        static let host = "parse.udacity.com"
        static let path = "/parse/classes/StudentLocation"
        static let login = "https://www.udacity.com/api/session"
    }
    
    struct Key {
        static let api = "X-Parse-REST-API-Key"
        static let parse = "X-Parse-Application-Id"
    }
    
    struct Value {
        static let api = "QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY"
        static let parse = "QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr"
    }
    
}
