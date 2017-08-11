//
//  UConnectionConfig.swift
//  The Map
//
//  Created by Alan Campos on 8/11/17.
//  Copyright © 2017 Alan Campos. All rights reserved.
//

import Foundation

class UConnectionConfig: ConnectionClient {
        
    var studentData = [StudentInformation]()
    var userID: String?
    var sessionID: String?
    var headers = [
        Constants.Key.api : Constants.Value.api,
        Constants.Key.parse : Constants.Value.parse
    ]
    
    func loginToUdacityAccount(username: String, password: String, completionHandler: @escaping (_ data: Authentication?, _ success: Bool?, _ error: Bool?) -> Void) {
        
        let url = URL(string: Constants.URL.login)
        
        let headers = [
            "Accept"        : "application/json",
            "Content-Type"  : "application/json"
        ]
        
        let body = "{\"udacity\": {\"username\": \"\(username)\", \"password\": \"\(password)\"}}"
        
        performConnection(url: url!, httpHeaders: headers, method: .post, httpBody: body) {
            data, success, error in
            
            if success! {
                
                let loginResponseInformation = Authentication(data!)
                
                completionHandler(loginResponseInformation, true, nil)
                
                
            } else {
                
                print("error")
                
            }
        }
    }
    
    func getStudentData(handler: @escaping (_ students: [StudentInformation]) -> Void) {
        
        let query = ["limit" : 100] as [String : AnyObject]
        
        let url = makeURLUsing(queries: query)
        
        performConnection(url: url, httpHeaders: headers, method: .get, httpBody: nil) {
            data, success, error in
            
            if success! {
                
                let json = self.convertToJSON(data: data!)
                let studentArray = json["results"] as! [[String : AnyObject]]
                
                var students = [StudentInformation]()

                for student in studentArray {
                    
                    if let latitude = student["latitude"] as? Double,
                        let longitude = student["longitude"] as? Double,
                        let first = student["firstName"] as? String,
                        let last = student["lastName"] as? String,
                        let mediaURL = student["mediaURL"] as? String,
                        let mapString = student["mapString"] as? String {
                        
                        let coordinates = Coordinates(latitude: latitude, longitude: longitude)
                        let address = Location(mapString: mapString, coordinates: coordinates)
                        let student = StudentInformation(firstName: first, lastName: last, address: address, mediaURL: mediaURL)
                        
                        students.append(student)
                        
                    }
                    
                }
                
                handler(students)
            }
            
        }
        
    }
    
}

extension UConnectionConfig {
    
    struct shared {
        
        static var instance = UConnectionConfig()
        
    }
    
}
