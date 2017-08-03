//
//  JSONParsable.swift
//  On The Map
//
//  Created by Alan Campos on 8/3/17.
//  Copyright © 2017 Alan Campos. All rights reserved.
//

import Foundation

protocol JSONParsable {
    func convertToJSON(data: Data) -> [String : AnyObject]
}

extension JSONParsable {
    func convertToJSON(data: Data) -> [String : AnyObject] {
        let json = try? JSONSerialization.jsonObject(with: data, options: .allowFragments)
        let jsonDictionary = json as! [String : AnyObject]
        return jsonDictionary
    }
}
