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

import FBSDKCoreKit
import Firebase
import FirebaseDatabase

class ViewController: UIViewController, CLLocationManagerDelegate   {
    
    private let SIGNIN_SEGUE = "ToSignIn"
    // reference to firebase
    var ref = Database.database().reference()
    // reference to current user
    var user = Auth.auth().currentUser
    // store device's id
    let deviceID = UIDevice.current.identifierForVendor?.uuidString
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // user has logged in, update online status
        if let user = Auth.auth().currentUser {
            let uid = user.uid
            manageConnections(userId: uid)
        }
        
        // for the bottom map view
        checkLocation()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    // MARK: - mapview code
    
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
        let expandedVC = navVC?.viewControllers.first as? ExpandedMapViewController
        expandedVC?.playerLocation = locationManager.location!
    }
    
    //////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    /* Chat Code */
    
    // Created by Karan Singh on 20/9/17.
    @IBAction func LogOutPressed(_ sender: Any) {
        // signs user out of firebase
        try! Auth.auth().signOut()
        //sign the user out of facebook too
        FBSDKAccessToken.setCurrent(nil)
        
        let myConnectionsRef = Database.database().reference(withPath: "user_profile/\(self.user!.uid)/connections/\(self.deviceID!)")
        myConnectionsRef.child("online").setValue(false)
        
        myConnectionsRef.child("last_online").setValue(NSDate().timeIntervalSince1970)
        
        self.performSegue(withIdentifier: self.SIGNIN_SEGUE, sender: nil)
    }
    
    /* managing whether a player is online or not */
    func manageConnections(userId: String) {
        // create a reference to the database
        let myConnectionsRef = Database.database().reference(withPath:"user_profile/\(userId)/connections/\(self.deviceID!)")
        myConnectionsRef.child("online").setValue(true)
        myConnectionsRef.child("last_online").setValue(NSDate().timeIntervalSince1970)
        // observer which will monitor if the user is logged in or out
        myConnectionsRef.observe(.value, with: {snapshot in
            // runs if the conditions are not met
            guard let connected = snapshot.value as? Bool, connected else {
                return
            }
        })
    }
    
}

