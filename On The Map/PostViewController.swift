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
    
    let delegate = UIApplication.shared.delegate as! AppDelegate

    var selectedPin: MKPlacemark?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        selectedPin = delegate.selectedPin
    }
    
    @IBAction func cancel(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func postStudentLocation(_ sender: Any) {
        
    }
    
}
