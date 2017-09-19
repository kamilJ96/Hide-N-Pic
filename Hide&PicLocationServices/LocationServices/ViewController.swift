//
//  ViewController.swift
//  LocationServices
//
//  Created by Kamil on 6/9/17.
//  Copyright © 2017 VanillaThunder. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit
import CoreGraphics

class ViewController: UIViewController, CLLocationManagerDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    let regionRadius: CLLocationDistance = 100
    var locationManager: CLLocationManager!
    
    @IBAction func unexpandMapSegue(unwindSegue: UIStoryboardSegue) {
        // This is here to allow the ExpandedMapViewController to return to this view
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        checkLocation()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    /* Initializes the CoreLocation manager and starts pulling location data */
    func checkLocation() {
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.startUpdatingLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let userLocation:CLLocation = locations[0] as CLLocation
        
        // Initialize map region around player
        let region = MKCoordinateRegionMakeWithDistance(userLocation.coordinate, regionRadius * 2.0, regionRadius * 2.0)
        mapView.setRegion(region, animated: true)
        
        // Add location pin for enemy player, currently just uses user's location lul
        let locationPin = LocationObject(title: "Enemy", locationName: "enemy", coordinate: CLLocationCoordinate2D(latitude: userLocation.coordinate.latitude-0.0005, longitude: userLocation.coordinate.longitude-0.0005))
        mapView.addAnnotation(locationPin)
    }
    
    /* Send player and enemy data to the ExpandedViewController */
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let navVC = segue.destination as? UINavigationController
        let expandedVC = navVC?.viewControllers.first as! ExpandedMapViewController
        expandedVC.playerLocation = locationManager.location!
    }
}

