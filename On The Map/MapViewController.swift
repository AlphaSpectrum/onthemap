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
    
    @IBOutlet weak var postButton: UIButton!
    @IBOutlet weak var revealSearchPinButton: UIBarButtonItem!
    @IBOutlet weak var mapView: MKMapView!
    
    //let locationManager = CLLocationManager()
    
    let header = [
        Constants.Key.api : Constants.Value.api,
        Constants.Key.parse : Constants.Value.parse
    ]
    
    let delegate = UIApplication.shared.delegate as! AppDelegate
    
    var alertShown = false
    var annotations = [MKPointAnnotation]()
    var connection: CConnection?
    var resultSearchController: UISearchController?
    var selectedPin: MKPlacemark?
    var currentLocation: CLLocation?
    var searchBar: UISearchBar?
    
    override func viewWillAppear(_ animated: Bool) {
        loadMapUsers()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        connection = delegate.connection
        postButton.alpha = 0.7
        postButton.isHidden = true
        configureSearchBar()
    }
    
    @IBAction func revealSearchBar(_ sender: Any) {
        searchBar?.isHidden = false
        searchBar?.becomeFirstResponder()
    }

    private func configureSearchBar() {
        let locationSearchTable = storyboard?.instantiateViewController(withIdentifier: "LocationSearchTableViewController") as! LocationSearchTableViewController
        resultSearchController = UISearchController(searchResultsController: locationSearchTable)
        resultSearchController?.searchResultsUpdater = locationSearchTable
        searchBar = resultSearchController?.searchBar
        searchBar?.sizeToFit()
        searchBar?.placeholder = "Search for a location"
        navigationItem.titleView = resultSearchController?.searchBar
        resultSearchController?.hidesNavigationBarDuringPresentation = false
        resultSearchController?.dimsBackgroundDuringPresentation = true
        definesPresentationContext = true
        locationSearchTable.mapView = mapView
        locationSearchTable.handleMapSearchDelegate = self
        searchBar?.isHidden = true
    }
    
    private func dropMultiplePins(using jsonData: [[String : AnyObject]]) {
        let results = jsonData
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
            }
        }
        if selectedPin != nil {
            let span = MKCoordinateSpanMake(100.0, 100.0)
            let region = MKCoordinateRegionMake((selectedPin?.coordinate)!, span)
            mapView.setRegion(region, animated: true)
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
    
        connection?.connect(to: url!, httpHeaders: header, method: .get, httpBody: nil) {
            data, success, error in
            
            if success! {
                let rawJSON = self.convertToJSON(data: data!)
                performUIUpdatesOnMain {
                    if let json = rawJSON["results"] as? [[String : AnyObject]] {
                        self.delegate.userArray = json
                        self.dropMultiplePins(using: json)
                    }
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
            annotationView?.animatesDrop = true
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
            
            if selectedPin == nil {
                let app = UIApplication.shared
                if let toOpen = view.annotation?.subtitle! {
                    if let url = URL(string: toOpen) {
                        app.open(url, options: [UIApplicationOpenURLOptionUniversalLinksOnly: toOpen]) { _ in }
                    }
                }
            }
            
            
            // Simplify this code in (simplification above)
            /*if selectedPin != nil {
            } else {
                let app = UIApplication.shared
                if let toOpen = view.annotation?.subtitle! {
                    if let url = URL(string: toOpen) {
                        app.open(url, options: [UIApplicationOpenURLOptionUniversalLinksOnly: toOpen]) { _ in }
                    }
                }
            }*/
        }
    }
    
    @IBAction func postStudentLocation(_ sender: Any) {
        delegate.selectedPin = selectedPin
        performSegue(withIdentifier: "PostViewSegue", sender: nil)
    }
}

extension HandleMapSearch where Self : MapViewController {
    func dropPin(zoom inPlacemark: MKPlacemark, completionHandler: @escaping (_ button: UIButton) -> Void) {
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
        completionHandler(postButton)
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

/*
 extension MapViewController : CLLocationManagerDelegate {
 func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
 if status == .authorizedWhenInUse {
 //locationManager.requestLocation()
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
 */


