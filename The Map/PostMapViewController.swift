//
//  PostMapViewController.swift
//  The Map
//
//  Created by Alan Campos on 8/14/17.
//  Copyright © 2017 Alan Campos. All rights reserved.
//

import Foundation
import UIKit
import MapKit

class PostMapViewController: UIViewController, UIUserFeedback {
    
    @IBOutlet weak var mapView: MKMapView!
        
    var searchQuery: String?
    var mediaURL: String!
    var searchResults: [MKMapItem]?
    var selectedLocation: MKPlacemark?
    var activity = UIActivityIndicatorView()
    
    override func viewDidLoad() {
        placeSearchResultOnMap()
    }
    
    private func placeSearchResultOnMap() {
        displayActivityIndicator(viewController: self, activityIndicator: activity, isHidden: false)
        let request = MKLocalSearchRequest()
        request.naturalLanguageQuery = searchQuery
        request.region = mapView.region
        let search = MKLocalSearch(request: request)
        search.start(completionHandler: {
            response, error in
            
            if error == nil {
                self.searchResults = response?.mapItems
                performUIUpdatesOnMain {
                    self.updateMapWithSearchResults()
                    self.displayActivityIndicator(viewController: self, activityIndicator: self.activity, isHidden: true)
                }
            }
        })
    }
    
    private func updateMapWithSearchResults() {
        for result in searchResults! {
            selectedLocation = result.placemark
            let annotation = MKPointAnnotation()
            annotation.coordinate = result.placemark.coordinate
            annotation.title = result.placemark.title
            mapView.addAnnotation(annotation)
            let span = MKCoordinateSpanMake(0.05, 0.05)
            let region = MKCoordinateRegionMake(result.placemark.coordinate, span)
            mapView.setRegion(region, animated: true)
        }
    }
    
    @IBAction func cancelButtonPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func finishButtonPressed(_ sender: Any) {
        displayActivityIndicator(viewController: self, activityIndicator: activity, isHidden: false)
        let loggedUser = StudentModel.shared.user
        if let firstName = loggedUser?.student?.name.first,
            let lastName = loggedUser?.student?.name.last,
            let mapString = selectedLocation?.title,
            let latitude = selectedLocation?.coordinate.latitude,
            let longitude = selectedLocation?.coordinate.longitude,
            let sessionID = loggedUser?.sessionID,
            let uniqueID = loggedUser?.uniqueID,
            let mediaURL = mediaURL {
            let address = Location(mapString: mapString, coordinates: Coordinates(latitude: latitude, longitude: longitude))
            let name = Name(first: firstName, last: lastName)
            let student = StudentInformation(name: name, address: address, mediaURL: mediaURL)
            let user = User(sessionID: sessionID, uniqueID: uniqueID, student: student)
            ConnectionHandler.shared.instance.postStudentInformation(user: user) {
                success, errorMessage in
                if success! {
                    performUIUpdatesOnMain {
                        self.displayActivityIndicator(viewController: self, activityIndicator: self.activity, isHidden: true)
                        self.alertUser(self, title: "Success!", message: "Your location has been posted successfully.", actionName: "Dismiss", actionHandler: {
                            self.presentingViewController?.presentingViewController?.dismiss(animated: true, completion: nil)
                        })
                    }
                } else {
                    performUIUpdatesOnMain {
                        self.displayActivityIndicator(viewController: self, activityIndicator: self.activity, isHidden: true)
                        self.alertUser(self, title: "Error", message: errorMessage!, actionName: "Dismiss", actionHandler: nil)
                    }
                }
            }
            
        }
    }
}
