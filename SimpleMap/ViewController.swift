//
//  ViewController.swift
//  SimpleMap
//
//  Created by Nick Chen on 10/4/15.
//  Copyright © 2015 Nick Chen. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

class ViewController: UIViewController, CLLocationManagerDelegate, UISearchBarDelegate {

    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var searchBar: UISearchBar!

    let locationManager = CLLocationManager()
    var localSearch: MKLocalSearch?

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func startSearch(searchString: String, region: MKCoordinateRegion) {
        let request = MKLocalSearchRequest()
        request.naturalLanguageQuery = searchString
        request.region = region

        localSearch = MKLocalSearch(request: request)
        localSearch?.startWithCompletionHandler({ (response, error) -> Void in
            if (error != nil) {
                // perform some error reporting
            } else {
                let places = response!.mapItems
                let boundingRegion = response!.boundingRegion
                dispatch_async(dispatch_get_main_queue()) {
                    self.updateMapWith(places, inRegion: boundingRegion)
                }
            }
        })

        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
    }

    func updateMapWith(places: [MKMapItem], inRegion boundingRegion: MKCoordinateRegion) {
        mapView.removeAnnotations(mapView.annotations)

        mapView.setRegion(boundingRegion, animated: true)

        for place in places {
            let annotation = PlaceAnnotation(coordinate: place.placemark.coordinate, title: place.name, url: place.url, phone: place.phoneNumber)
            mapView.addAnnotation(annotation)
        }
    }

    // MARK: CLLocationManagerDelegate
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations.last

        manager.stopUpdatingLocation()
        manager.delegate = nil

        let center = CLLocationCoordinate2D(latitude: location!.coordinate.latitude, longitude: location!.coordinate.longitude)
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 1, longitudeDelta: 1))
        mapView.setRegion(region, animated: true)

        if let searchString = searchBar.text {
            startSearch(searchString, region: region)
        }
    }

    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        print("Errors: " + error.localizedDescription)
    }

    // MARK: UISearchBarDelegate

    // called when cancel button pressed
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }

    // called when text starts editing
    func searchBarTextDidBeginEditing(searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(true, animated: true)
    }

    // called when text ends editing
    func searchBarTextDidEndEditing(searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(false, animated: true)
    }

    // called when text changes (including clear)
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {

    }

    // called when keyboard search button pressed
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        searchBar.resignFirstResponder()

        if(!CLLocationManager.locationServicesEnabled()) {
            requestToTurnOnLocationServices()
        }

        if(CLLocationManager.authorizationStatus() == CLAuthorizationStatus.NotDetermined ) {
            locationManager.requestAlwaysAuthorization()
            return
        } else if (CLLocationManager.authorizationStatus() == CLAuthorizationStatus.Denied) {
            requestToAuthorizeLocationServiceForApp()
            return
        }

        // Proceed if everything is fine
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
        mapView.showsUserLocation = true
    }

    func requestToTurnOnLocationServices() {
        let alert = UIAlertController.init(title: "Location services", message: "Location services are not enabled for this device. Please enable location services in settings", preferredStyle: UIAlertControllerStyle.Alert)
        let defaultAction = UIAlertAction.init(title: "Dismiss", style: UIAlertActionStyle.Default) { (UIAlertAction) -> Void in}
        alert.addAction(defaultAction)
        self.presentViewController(alert, animated: true, completion: nil)
    }

    func requestToAuthorizeLocationServiceForApp() {
        let alert = UIAlertController.init(title: "Location services", message: "Location services are disable for this application. Please enable location services for this app in settings.", preferredStyle: UIAlertControllerStyle.Alert)
        let defaultAction = UIAlertAction.init(title: "Dismiss", style: UIAlertActionStyle.Default) { (UIAlertAction) -> Void in}
        alert.addAction(defaultAction)
        self.presentViewController(alert, animated: true, completion: nil)
    }
}

