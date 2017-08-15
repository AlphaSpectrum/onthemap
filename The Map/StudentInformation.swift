//
//  StudentInformation.swift
//  The Map
//
//  Created by Alan Campos on 8/11/17.
//  Copyright © 2017 Alan Campos. All rights reserved.
//

import Foundation

struct Coordinates {
    var latitude: Double
    var longitude: Double
}

struct Location {
    var mapString: String
    var coordinates: Coordinates
}

struct Name {
    var first: String
    var last: String
}

struct StudentInformation {
    var name: Name
    var address: Location!
    var mediaURL: String!
    var studentDictionary: [String : AnyObject]?
    
    init(name: Name, address: Location!, mediaURL: String!, studentDictionary: [String : AnyObject]? = nil) {
        self.name = name
        self.address = address
        self.mediaURL = mediaURL
        self.studentDictionary = studentDictionary
    }
}
