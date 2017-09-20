//
//  ViewController.swift
//  test
//
//  Created by Leonard Zou on 20/9/17.
//  Copyright © 2017 VanillaThunder. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit
import CoreGraphics
import ARCL

class ViewController: UIViewController, CLLocationManagerDelegate   {

    @IBOutlet var sceneLocationView: SceneLocationView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        checkLocation()
        
        sceneLocationView.run()
        
        // places around Alice Hoy and SMAC and ERC
        // 1
        addNewLocationAnnotationNodeToScene(latitude: -37.799288, longitude: 144.963672)
        // 2
        addNewLocationAnnotationNodeToScene(latitude: -37.799284, longitude: 144.963570)
        // 3
        addNewLocationAnnotationNodeToScene(latitude: -37.799396, longitude: 144.963460)
        // 4
        addNewLocationAnnotationNodeToScene(latitude: -37.799485, longitude: 144.963441)
        // 5
        addNewLocationAnnotationNodeToScene(latitude: -37.799549, longitude: 144.963350)
        // 6
        addNewLocationAnnotationNodeToScene(latitude: -37.799508, longitude: 144.963114)
        // 7
        addNewLocationAnnotationNodeToScene(latitude: -37.799286, longitude: 144.963130)
        // 8
        addNewLocationAnnotationNodeToScene(latitude: -37.799061, longitude: 144.963205)
        // 9
        addNewLocationAnnotationNodeToScene(latitude: -37.798828, longitude: 144.963208)
        // 10
        addNewLocationAnnotationNodeToScene(latitude: -37.798688, longitude: 144.963355)
        // 11
        addNewLocationAnnotationNodeToScene(latitude: -37.798633, longitude: 144.963540)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        sceneLocationView.pause()
    }
    
    // MARK: - ARCL code, added by Leonard
    func addNewLocationAnnotationNodeToScene(
        latitude: CLLocationDegrees, longitude: CLLocationDegrees,
        altitude: CLLocationDistance = 50,
        scaleRelativeToDistance: Bool = true)
    {
        let image = UIImage(named: "pin")!
        
        let locationCoordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        let location = CLLocation(coordinate: locationCoordinate, altitude: altitude)
        
        let annotationNode = LocationAnnotationNode(location: location, image: image)
        annotationNode.scaleRelativeToDistance = scaleRelativeToDistance
        sceneLocationView.addLocationNodeWithConfirmedLocation(locationNode: annotationNode)
        print("Coordinate added: \(latitude), \(longitude)") // DEBUG
    }


    // MARK: - mapview controller code
    
    @IBOutlet weak var mapView: MKMapView!
    let regionRadius: CLLocationDistance = 100
    var locationManager: CLLocationManager!
    
    @IBAction func unexpandMapSegue(unwindSegue: UIStoryboardSegue) {
        // This is here to allow the ExpandedMapViewController to return to this view
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

