//
//  MapViewController.swift
//  On The Map
//
//  Created by Alan Campos on 7/25/17.
//  Copyright © 2017 Alan Campos. All rights reserved.
//
import Foundation
import UIKit
import MapKit

class MapViewController : UIViewController, MKMapViewDelegate, HandleMapSearch, JSONParsable {
    
    @IBOutlet weak var mapView: MKMapView!
        
    let locationManager = CLLocationManager()
    let delegate = UIApplication.shared.delegate as! AppDelegate
    
    var alertShown = false
    var annotations = [MKPointAnnotation]()
    var connection: CConnection?
    var resultSearchController: UISearchController?
    var selectedPin: MKPlacemark?
    var currentLocation: CLLocation?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        connection = delegate.connection
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
        let locationSearchTable = storyboard!.instantiateViewController(withIdentifier: "LocationSearchTableViewController") as! LocationSearchTableViewController
        resultSearchController = UISearchController(searchResultsController: locationSearchTable)
        resultSearchController?.searchResultsUpdater = locationSearchTable
        let searchBar = resultSearchController!.searchBar
        searchBar.sizeToFit()
        searchBar.placeholder = "Search for a location to post"
        navigationItem.titleView = resultSearchController?.searchBar
        resultSearchController?.hidesNavigationBarDuringPresentation = false
        resultSearchController?.dimsBackgroundDuringPresentation = true
        definesPresentationContext = true
        locationSearchTable.mapView = mapView
        locationSearchTable.handleMapSearchDelegate = self
        loadMapUsers()
    }
    
    private func dropMultiplePins(using jsonData: [String : AnyObject]) {
        let results = jsonData["results"] as! [[String : AnyObject]]
        for result in results {
            if let lat = result["latitude"] as? Double,
                let long = result["longitude"] as? Double,
                let first = result["firstName"] as? String,
                let last = result["lastName"] as? String,
                let mediaURL = result["mediaURL"] as? String {
                let annotation = MKPointAnnotation()
                annotation.coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
                annotation.title = "\(first) \(last)"
                annotation.subtitle = mediaURL
                annotations.append(annotation)
            } else {
                continue
            }
        }
        mapView.addAnnotations(annotations)
    }
    
    private func refreshMap() {
        // Delay each call by 5 seconds so we don't kill the CPU
        DispatchQueue.main.asyncAfter(deadline: .now() + 5.0, execute: {
            self.loadMapUsers()
        })
    }
    
    private func loadMapUsers() {
        let url = connection?.formatAsURL(scheme: Constants.URL.scheme, host: Constants.URL.host, path: Constants.URL.path, query: "limit=100")
        
        let header = [
            Constants.Key.api : Constants.Value.api,
            Constants.Key.parse : Constants.Value.parse
        ]
    
        connection?.connect(to: url!, httpHeaders: header, method: .get, httpBody: nil) {
            data, success, error in
            
            if success! {
                let json = self.convertToJSON(data: data!)
                performUIUpdatesOnMain {
                    self.delegate.userArray = json
                    self.dropMultiplePins(using: json)
                }
            }  else {
                performUIUpdatesOnMain {
                    self.alertUserOfError(title: "Error", message: error!, actionName: "OK", completion: {
                        self.refreshMap()
                    })
                }
            }
        }
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
            let app = UIApplication.shared
            if let toOpen = view.annotation?.subtitle! {
                app.open(URL(string: toOpen)!, options: [UIApplicationOpenURLOptionUniversalLinksOnly: toOpen]) { _ in }
            }
        }
    }
}

extension MapViewController : CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            locationManager.requestLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            currentLocation = location
            let span = MKCoordinateSpanMake(150.0, 150.0)
            let region = MKCoordinateRegion(center: location.coordinate, span: span)
            mapView.setRegion(region, animated: true)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("error:  \(error)")
    }
}

extension HandleMapSearch where Self : MapViewController {
    func dropPin(zoom inPlacemark: MKPlacemark) {
        selectedPin = inPlacemark
        //clear existing pins
        mapView.removeAnnotations(mapView.annotations)
        let annotation = MKPointAnnotation()
        annotation.coordinate = inPlacemark.coordinate
        annotation.title = inPlacemark.name
        if let city = inPlacemark.locality, let state = inPlacemark.administrativeArea {
            annotation.subtitle = "\(city), \(state)"
        }
        mapView.addAnnotation(annotation)
        let span = MKCoordinateSpanMake(0.05, 0.05)
        let region = MKCoordinateRegionMake(inPlacemark.coordinate, span)
        mapView.setRegion(region, animated: true)
    }
    
}

extension MapViewController: UserAlertable {
    internal func alertUserOfError(title: String, message: String, actionName: String, completion: WithFunc) {
        if !alertShown {
            // Set alertShown to true so we notify the user only once
            alertShown = true
            let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: actionName, style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            completion()
        } else {
            completion()
        }
    }
}


