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

struct StudentInformation {
    var firstName: String
    var lastName: String
    var address: Location
    var mediaURL: String
}
