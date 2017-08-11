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

class PostViewController: UIViewController, UserAlertable {
    
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
            let student = StudentInformation(uniqueKey: (delegate.loginResponse?.accountKey)!, firstName: firstNameTextField.text!, lastName: lastNameTextField.text!, address: studentAddress, mediaURL: mediaURLTextField.text!)
            
            let url = connection?.formatAsURL(scheme: Constants.URL.scheme, host: Constants.URL.host, path: Constants.URL.path, query: nil)
            header?["Content-Type"] = "application/json"
            let httpBody = convertStudentStructToJSON(student)
            
            connection?.connect(to: url!, httpHeaders: header, method: .post, httpBody: httpBody) {
                data, success, error in
                
                performUIUpdatesOnMain {
                    if success! {
                        self.alertUser(title: "Posted!", message: "Your information has been posted successfully.", actionName: "OK", completion: nil)
                    } else {
                        self.warningLabel.text = error
                    }
                    
                }
            }
        }
    }
    
    private func convertStudentStructToJSON(_ user: StudentInformation) -> String {
        let studentJSONData = "{\"uniqueKey\": \"\(user.uniqueKey)\", \"firstName\": \"\(user.firstName)\", \"lastName\": \"\(user.lastName)\",\"mapString\": \"\(user.address.city), \(user.address.state)\", \"mediaURL\": \"\(user.mediaURL)\",\"latitude\": \(user.address.coordinates.latitude), \"longitude\": \(user.address.coordinates.longitude)}"
        return studentJSONData
    }
    
    func alertUser(title: String, message: String, actionName: String, completion: UserAlertable.WithFunction?) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: actionName, style: UIAlertActionStyle.default, handler: {
            action in
            self.dismiss(animated: true, completion: nil)
        }))
        self.present(alert, animated: true, completion: nil)
    }
}
