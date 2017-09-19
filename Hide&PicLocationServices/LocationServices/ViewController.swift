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

    
    @IBOutlet weak var heightConstraint: NSLayoutConstraint!
    @IBOutlet weak var expandMap: UIButton!
    @IBOutlet weak var mapView: MKMapView!
    let regionRadius: CLLocationDistance = 100
    var locationManager: CLLocationManager!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let initialLocation = CLLocation(latitude: 21.28277, longitude: -157.829444)
        centerMapOnLocation(location: initialLocation)
        
        let location = LocationObject(title: "Player 1", locationName: "player1", coordinate: CLLocationCoordinate2D(latitude: 21.28277, longitude: -157.829444))
        mapView.addAnnotation(location)
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func checkLocation() {
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.startUpdatingLocation()
        }
    }
    
    func locationManager(_manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let userLocation:CLLocation = locations[0] as CLLocation
        print("user latitude = \(userLocation.coordinate.latitude)")
        print("user longitude = \(userLocation.coordinate.longitude)")
    }
    
    func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate, regionRadius * 2.0, regionRadius * 2.0)
        mapView.setRegion(coordinateRegion, animated: true)
    }
    
    
    @IBAction func expandMaps(_ sender: Any) {
        if (!self.expandMap.isSelected) {
            self.heightConstraint.constant = 0
            expandMap.frame.origin = CGPoint(x: 20, y: 30)
            expandMap.frame.size = CGSize(width: 46, height: 30)
            expandMap.setTitle(_:"Return", for: UIControlState.normal)
            self.expandMap.isSelected = true
        } else {
            self.heightConstraint.constant = 576
            expandMap.frame.origin = CGPoint(x: 0, y: 567)
            expandMap.frame.size = CGSize(width: 375, height: 100)
            expandMap.setTitle(_:"", for: UIControlState.normal)
            self.expandMap.isSelected = false
        }
        
        view.bringSubview(toFront: expandMap)
    }

}

