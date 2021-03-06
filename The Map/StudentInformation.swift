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

struct Information {
    var name: Name
    var address: Location!
    var mediaURL: String!
    
}

struct Student {
    init(_ dictionary: [[String : AnyObject]]) {
        var students = [Information]()
        for student in dictionary {
            if let latitude = student["latitude"] as? Double,
                let longitude = student["longitude"] as? Double,
                let first = student["firstName"] as? String,
                let last = student["lastName"] as? String,
                let mediaURL = student["mediaURL"] as? String,
                let mapString = student["mapString"] as? String {
                let coordinates = Coordinates(latitude: latitude, longitude: longitude)
                let address = Location(mapString: mapString, coordinates: coordinates)
                let name = Name(first: first, last: last)
                let student = Information(name: name, address: address, mediaURL: mediaURL)
                students.append(student)
            }
        }
        StudentModel.shared.students = students
    }
}

class StudentModel {
    static var shared = StudentModel()
    var students: [Information]!
    var user: User!
}
