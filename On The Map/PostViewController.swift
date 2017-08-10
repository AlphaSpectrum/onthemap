//
//  PostViewController.swift
//  OnTheMap
//
//  Created by Alan Campos on 8/7/17.
//  Copyright © 2017 Alan Campos. All rights reserved.
//

import Foundation
import UIKit
import MapKit

class PostViewController: UIViewController {
    
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var mediaURLTextField: UITextField!
    @IBOutlet weak var warningLabel: UILabel!
    
    let delegate = UIApplication.shared.delegate as! AppDelegate
    
    var header: [String : String]?
    var connection: CConnection?
    var selectedPin: MKPlacemark?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        connection = delegate.connection
        header = delegate.header
        selectedPin = delegate.selectedPin
    }
    
    @IBAction func cancel(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func postStudentLocation(_ sender: Any) {
        if (firstNameTextField.text?.isEmpty)! && (lastNameTextField.text?.isEmpty)! && (mediaURLTextField.text?.isEmpty)! {
            warningLabel.text = "First, last name and media URL cannot be blank."
        } else {
            let studentCoordinates = Coordinates(latitude: (selectedPin?.coordinate.latitude)!, longitude: (selectedPin?.coordinate.longitude)!)
            let studentAddress = Location(city: (selectedPin?.locality)!, state: (selectedPin?.administrativeArea)!, coordinates: studentCoordinates)
            let student = StudentInformation(uniqueKey: "9482084", firstName: firstNameTextField.text!, lastName: lastNameTextField.text!, address: studentAddress, mediaURL: mediaURLTextField.text!)
            let url = connection?.formatAsURL(scheme: Constants.URL.scheme, host: Constants.URL.host, path: Constants.URL.path, query: nil)
            header?["Content-Type"] = "application/json"
            let httpBody = convertStudentStructToJSON(student)
            
            print(httpBody)
            
            connection?.connect(to: url!, httpHeaders: header, method: .post, httpBody: httpBody) {
                data, success, error in
                print(NSString(data: data!, encoding: String.Encoding.utf8.rawValue) ?? "")
                self.dismiss(animated: true, completion: nil)
            }
            
        }
        
    }
    
    private func convertStudentStructToJSON(_ user: StudentInformation) -> String {
        let studentJSONData = "{\"uniqueKey\": \"\(user.uniqueKey)\", \"firstName\": \"\(user.firstName)\", \"lastName\": \"\(user.lastName)\",\"mapString\": \"\(user.address.city), \(user.address.state)\", \"mediaURL\": \"\(user.mediaURL)\",\"latitude\": \(user.address.coordinates.latitude), \"longitude\": \(user.address.coordinates.longitude)}"
        
        return studentJSONData
    }
    
    /*
    private func postStudentData(_ student: StudentInformation) {
        let coordinates = Coordinates(latitude: (selectedPin?.coordinate.latitude)!, longitude: (selectedPin?.coordinate.longitude)!)
        let location = Location(city: (selectedPin?.locality)!, state: (selectedPin?.administrativeArea)!, coordinates: coordinates)
        let student = StudentInformation(uniqueKey: "1294850", firstName: "John", lastName: "Doe", address: location, mediaURL: "https://theverge.com")
        let url = connection?.formatAsURL(scheme: Constants.URL.scheme, host: Constants.URL.host, path: Constants.URL.path, query: nil)
        var headers = header
        headers["Content-Type"] = "application/json"
        
        let httpBody = convertStudentStructToJSON(student)
        print(httpBody)
        
        connection?.connect(to: url!, httpHeaders: headers, method: .post, httpBody: httpBody) {
            data, success, error in
            print(NSString(data: data!, encoding: String.Encoding.utf8.rawValue) ?? "")
        }
    }*/
    
}
