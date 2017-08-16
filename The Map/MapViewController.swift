//
//  MapViewController.swift
//  The Map
//
//  Created by Alan Campos on 8/12/17.
//  Copyright © 2017 Alan Campos. All rights reserved.
//

import Foundation
import UIKit
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate, UIUserFeedback {
    
    @IBOutlet weak var mapView: MKMapView!
    
    let activity = UIActivityIndicatorView()
    
    var annotations: [MKPointAnnotation]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        getStudents()
    }
    
    @IBAction func refresh(_ sender: Any) {
        getStudents()
    }
    
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        let reuseId = "pin"
        
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        if annotationView == nil {
            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            annotationView!.tintColor = .green
            annotationView!.canShowCallout = true
            annotationView!.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        } else {
            annotationView!.annotation = annotation
        }
        
        if annotation is MKPointAnnotation {
            annotationView?.pinTintColor = .orange
        }
        
        return annotationView
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView {
            if let toOpen = view.annotation?.subtitle {
                if let url = URL(string: toOpen!) {
                    let app = UIApplication.shared
                    app.open(url, options: [UIApplicationOpenURLOptionUniversalLinksOnly: toOpen!]) {
                        success in
                        if !success {
                            performUIUpdatesOnMain {
                                self.alertUser(self, title: "", message: "Not a valid URL.", actionName: "Dismiss", actionHandler: nil)
                            }
                        }
                    }
                }
            }
        }
    }
    
    @IBAction func logoutPressed(_ sender: Any) {
        displayActivityIndicator(viewController: self, activityIndicator: activity, isHidden: false)
        ConnectionHandler.shared.instance.logout() {
            success, errorMessage in
            if success! {
                performUIUpdatesOnMain { self.dismiss(animated: true, completion: nil) }
            } else {
                performUIUpdatesOnMain { self.alertUser(self, title: "Error", message: errorMessage!, actionName: "Dismiss", actionHandler: nil) }
            }
            performUIUpdatesOnMain {
                self.displayActivityIndicator(viewController: self, activityIndicator: self.activity, isHidden: true)
            }
        }
    }
    
    private func getStudents() {
        displayActivityIndicator(viewController: self, activityIndicator: activity, isHidden: false)
        ConnectionHandler.shared.instance.getStudentInformation() {
            students, errorMessage in
            if errorMessage == nil {
                StudentModel.shared.students = students
                performUIUpdatesOnMain { self.loadUsersOnMap(students!) }
            } else {
                performUIUpdatesOnMain { self.alertUser(self, title: "Error", message: errorMessage!, actionName: "Dismiss", actionHandler: nil) }
            }
            performUIUpdatesOnMain { self.displayActivityIndicator(viewController: self, activityIndicator: self.activity, isHidden: true) }
        }
    }
    
    private func loadUsersOnMap(_ students: [Information]) {
        if annotations != nil {
            mapView.removeAnnotations(annotations!)
        }
        var tempAnnotations = [MKPointAnnotation]()
        for student in students {
            let annotation = MKPointAnnotation()
            annotation.coordinate = CLLocationCoordinate2D(latitude: (student.address?.coordinates.latitude)!, longitude: (student.address?.coordinates.longitude)!)
            annotation.title = "\(student.name.first) \(student.name.last)"
            annotation.subtitle = student.mediaURL
            tempAnnotations.append(annotation)
        }
        annotations = tempAnnotations
        mapView.addAnnotations(annotations!)
    }
}
