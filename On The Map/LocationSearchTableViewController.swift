//
//  LocationSearchTableViewController.swift
//  On The Map
//
//  Created by Alan Campos on 7/29/17.
//  Copyright © 2017 Alan Campos. All rights reserved.
//

import UIKit
import MapKit

class LocationSearchTableViewController : UITableViewController {
    
    let reuseIdentifier = "SearchResultsCell"

    var matchingItems = [MKMapItem]()
    var mapView: MKMapView?
    var handleMapSearchDelegate: HandleMapSearch?
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return matchingItems.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier)
        let selectdItem = matchingItems[indexPath.row].placemark
        cell?.textLabel?.text = selectdItem.name
        cell?.detailTextLabel?.text = parseAddress(selectedItem: selectdItem)
        return cell!
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedItem = matchingItems[indexPath.row].placemark
        handleMapSearchDelegate?.dropPin(zoom: selectedItem)
        dismiss(animated: true, completion: nil)
    }
    
    func parseAddress(selectedItem: MKPlacemark) -> String {
        let firstSpace = (selectedItem.subThoroughfare != nil && selectedItem.thoroughfare != nil) ? " " : ""
        let comma = (selectedItem.subThoroughfare != nil || selectedItem.thoroughfare != nil) && (selectedItem.subAdministrativeArea != nil || selectedItem.administrativeArea != nil) ? ", " : ""
        let secondSpace = (selectedItem.subAdministrativeArea != nil && selectedItem.administrativeArea != nil) ? " " : ""
        let addressLine = String(
            format:"%@%@%@%@%@%@%@",
            // street number
            selectedItem.subThoroughfare ?? "",
            firstSpace,
            // street name
            selectedItem.thoroughfare ?? "",
            comma,
            // city
            selectedItem.locality ?? "",
            secondSpace,
            // state
            selectedItem.administrativeArea ?? ""
        )
        return addressLine
    }
}

extension LocationSearchTableViewController : UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let mapView = mapView, let searchBarText = searchController.searchBar.text else { return }
        let searchRequest = MKLocalSearchRequest()
        searchRequest.naturalLanguageQuery = searchBarText
        searchRequest.region = mapView.region
        let search = MKLocalSearch(request: searchRequest)
        search.start {
            response, _ in
            guard let response = response else {
                return
            }
            performUIUpdatesOnMain {
                self.matchingItems = response.mapItems
                self.tableView.reloadData()
            }
        }
    }
}



