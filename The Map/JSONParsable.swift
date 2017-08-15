//
//  JSONParsable.swift
//  The Map
//
//  Created by Alan Campos on 8/3/17.
//  Copyright © 2017 Alan Campos. All rights reserved.
//

import Foundation

protocol JSONParsable {
    
    func convertToJSON(data: Data) -> [String : AnyObject]
    func convertStudentStructToJSON(_ user: User) -> String
    
}

extension JSONParsable {
    
    func convertToJSON(data: Data) -> [String : AnyObject] {
        let json = try? JSONSerialization.jsonObject(with: data, options: .allowFragments)
        let jsonDictionary = json as! [String : AnyObject]
        return jsonDictionary
    }
    
    func convertStudentStructToJSON(_ user: User) -> String {
        let studentJSONData = "{\"uniqueKey\": \"\(user.uniqueID)\", \"firstName\": \"\(user.student!.name.first)\", \"lastName\": \"\(user.student!.name.last)\",\"mapString\": \"\(user.student!.address!.mapString)\", \"mediaURL\": \"\(user.student!.mediaURL!)\",\"latitude\": \(user.student!.address!.coordinates.latitude), \"longitude\": \(user.student!.address!.coordinates.longitude)}"
        return studentJSONData
    }
    
}
