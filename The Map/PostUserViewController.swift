//
//  PostUserViewController.swift
//  The Map
//
//  Created by Alan Campos on 8/13/17.
//  Copyright © 2017 Alan Campos. All rights reserved.
//

import Foundation
import UIKit

class PostUserViewController: UIViewController, UIUserFeedback {
    
    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var mediaURLTextField: UITextField!
    
    override func viewDidLoad() {
        
    }
    
    @IBAction func cancelButtonPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func findLocationButtonPressed(_ sender: Any) {
        if (locationTextField.text?.isEmpty)! && (mediaURLTextField.text?.isEmpty)! {
            alertUser(self, title: "", message: "Location and Media URL cannot be empty.", actionName: "Dismiss", actionHandler: nil)
        } else {
            let viewController = storyboard?.instantiateViewController(withIdentifier: "PostMapView") as! PostMapViewController
            viewController.searchQuery = locationTextField.text
            viewController.mediaURL = mediaURLTextField.text
            present(viewController, animated: true, completion: nil)
        }
    }
}
