//
//  ConnectionHandler.swift
//  The Map
//
//  Created by Alan Campos on 8/11/17.
//  Copyright © 2017 Alan Campos. All rights reserved.
//

import Foundation

class ConnectionHandler: ConnectionClient {
        
    var studentData = [StudentInformation]()
    var userID: String?
    var sessionID: String?
    var httpHeaders = [
        Constants.Key.api : Constants.Value.api,
        Constants.Key.parse : Constants.Value.parse
    ]
    
    func loginToUdacityAccount(username: String, password: String, completionHandler: @escaping (_ data: Authentication?, _ success: Bool?, _ error: String?) -> Void) {
        let str = "\(Constants.URL.udacity)/session"
        let url = URL(string: str)
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
                completionHandler(nil, false, error)
            }
        }
    }
    
    func postStudentInformation(user: User, completionHandler: @escaping (_ success: Bool?, _ errorMessage: String?) -> Void) {
        let url = makeURLUsing(queries: nil)
        httpHeaders["Content-Type"] = "application/json"
        let httpbody = convertStudentStructToJSON(user)
        performConnection(url: url, httpHeaders: httpHeaders, method: .post, httpBody: httpbody) {
            data, success, errorMessage in
            if success! {
                completionHandler(success, nil)
            } else {
                completionHandler(nil, errorMessage)
            }
        }
    }
    
    func getStudentInformation(completionHandler: @escaping (_ students: [StudentInformation]?, _ errorMessage: String?) -> Void) {
        let query = [
            "order" : "-updatedAt",
            "limit" : 100
            ] as [String : AnyObject]
        let url = makeURLUsing(queries: query)
        performConnection(url: url, httpHeaders: httpHeaders, method: .get, httpBody: nil) {
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
                        let name = Name(first: first, last: last)
                        let student = StudentInformation(name: name, address: address, mediaURL: mediaURL)
                        students.append(student)
                    }
                }
                completionHandler(students, nil)
            } else {
                completionHandler(nil, error)
            }
        }
    }
    
    func getAuthenticatedStudentInformation(userID: String, completionHandler: @escaping (_ name: Name?, _ errorMessage: String?) -> Void) {
        let str = "\(Constants.URL.udacity)/users/\(userID)"
        let url = URL(string: str)
        performConnection(url: url!, httpHeaders: nil, method: .get, httpBody: nil) {
            data, success, error in
            
            if success! {
                let newData = data?.subsetData(data!)
                let json = self.convertToJSON(data: newData!)
                
                if let nameObject = json["user"] {
                    if let firstName = nameObject["first_name"] as? String,
                        let lastName = nameObject["last_name"] as? String {
                        let name = Name(first: firstName, last: lastName)
                        completionHandler(name, nil)
                    }
                } else {
                    completionHandler(nil, error)
                }
            }
        }
    }
    
    func logout(completionHandler: @escaping (_ success: Bool?, _ errorMessage: String?) -> Void) {
        let url = URL(string: "https://www.udacity.com/api/session")
        let request = NSMutableURLRequest(url: url!)
        request.httpMethod = "DELETE"
        var xsrfCookie: HTTPCookie? = nil
        let sharedCookieStorage = HTTPCookieStorage.shared
        
        func sendError(_ error: String?) {
            completionHandler(false, error!)
        }
        
        for cookie in sharedCookieStorage.cookies! {
            if cookie.name == "XSRF-TOKEN" { xsrfCookie = cookie }
        }
        
        if let xsrfCookie = xsrfCookie {
            request.setValue(xsrfCookie.value, forHTTPHeaderField: "X-XSRF-TOKEN")
        }
        
        let session = URLSession.shared
        
        let task = session.dataTask(with: request as URLRequest) { _ , response, error in
            
            guard (error == nil) else {
                sendError("No internet connection.")
                return
            }
            
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
                sendError("Invalid username or password.")
                return
            }
            completionHandler(true, nil)
        }
        task.resume()
    }
}

internal extension ConnectionHandler {
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

extension ConnectionHandler {
    struct shared {
        static var instance = ConnectionHandler()
    }
}

extension Data {
    func subsetData(_ data: Data) -> Data {
        let range = Range(5..<data.count)
        let newData = data.subdata(in: range)
        return newData
    }
}
