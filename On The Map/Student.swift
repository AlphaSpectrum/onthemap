//
//  Student.swift
//  OnTheMap
//
//  Created by Alan Campos on 8/4/17.
//  Copyright © 2017 Alan Campos. All rights reserved.
//

import Foundation

struct Coordinates {
    var latitude: Double?
    var longitude: Double?
}

struct Location {
    var city: String?
    var state: String?
    var coordinates: Coordinates?
}

struct Student {
    var firstName: String?
    var lastName: String?
    var address: Location?
    var mediaURL: String?
}
