//
//  PostUserViewController.swift
//  The Map
//
//  Created by Alan Campos on 8/13/17.
//  Copyright © 2017 Alan Campos. All rights reserved.
//

import Foundation
import UIKit
import MapKit

class PostUserViewController: UIViewController, UIUserFeedback {
    
    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var mediaURLTextField: UITextField!
    
    var activity = UIActivityIndicatorView()
    
    @IBAction func cancelButtonPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func findLocationButtonPressed(_ sender: Any) {
        displayActivityIndicator(viewController: self, activityIndicator: activity, isHidden: false)
        if (locationTextField.text?.isEmpty)! || (mediaURLTextField.text?.isEmpty)! {
            displayActivityIndicator(viewController: self, activityIndicator: self.activity, isHidden: true)
            alertUser(self, title: "", message: "Location and Media URL cannot be empty.", actionName: "Dismiss", actionHandler: nil)
        } else {
            let viewController = storyboard?.instantiateViewController(withIdentifier: "PostMapView") as! PostMapViewController
            viewController.mediaURL = mediaURLTextField.text
            let request = MKLocalSearchRequest()
            request.naturalLanguageQuery = locationTextField.text
            let search = MKLocalSearch(request: request)
            search.start() {
                response, error in
                if error == nil {
                    viewController.searchResults = response?.mapItems
                    performUIUpdatesOnMain {
                        self.displayActivityIndicator(viewController: self, activityIndicator: self.activity, isHidden: true)
                        self.present(viewController, animated: true, completion: nil)
                    }
                } else {
                    performUIUpdatesOnMain {
                        self.displayActivityIndicator(viewController: self, activityIndicator: self.activity, isHidden: true)
                        self.alertUser(self, title: "Error", message: "An error has occurred. Cannot perform operation right now. Check your network connection.", actionName: "Dismiss", actionHandler: nil)
                    }
                }
            }
        }
    }
}
