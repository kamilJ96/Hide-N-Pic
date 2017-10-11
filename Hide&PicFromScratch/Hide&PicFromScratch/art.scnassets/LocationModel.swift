//
//  Model.swift
//  Hide&PicFromScratch
//
//  Created by Leonard Zou on 11/10/17.
//  Copyright © 2017 VanillaThunder. All rights reserved.
//

import Foundation
import MapKit
import CoreLocation

import Firebase
import FirebaseDatabase

// LocationModel class for constantly fetching user location, storing it in the cloud
// and constantly retrieving opponent's locations from the cloud
// initiating player is responsible for creating game session on server and deleting it afterwards
public class LocationModel: NSObject, CLLocationManagerDelegate {
    
    let locationUpdateFrequency: TimeInterval = 5 // seconds
    let locationHintFadeTime: TimeInterval = 15 // seconds
    
    // strings for accessing file path in database
    let gameSessionsString = "gameSessions"
    let initiatingPlayerString = "initiatingPlayer"
    let invitedPlayerString = "invitedPlayer"
    
    // TODO: make this an if else statement to change your string, depending on whether you initiated the game or accepted an invite to a game
    lazy var myPlayerString = initiatingPlayerString
    lazy var opponentPlayerString = invitedPlayerString
    
    // Firebase database references
    let ref: DatabaseReference! = Database.database().reference()
    var gameSessionID: DatabaseReference!
    var myLocationsID: DatabaseReference!
    var opponentsLocationsID: DatabaseReference!
    
    
    var playerLocation: CLLocation? {
        return locationManager.location!
    }
    
//    var myLocations: Array<CLLocation> {
//        didSet {
//
//        }
//    }
//
//    var opponentsLocations: Array<CLLocation> {
//        didSet {
//
//        }
//    }
    
    public override init() {
        super.init()
        checkLocation()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.startUpdatingLocation()
        }
        
        // Create new game session in Firebase Database
        gameSessionID = ref.child(gameSessionsString).childByAutoId()
        myLocationsID = gameSessionID.child(myPlayerString)
        opponentsLocationsID = gameSessionID.child(opponentPlayerString)
        
        
        Timer.scheduledTimer(withTimeInterval: locationUpdateFrequency, repeats: true) { [weak self] timer in
            self?.recordLocationAndSendToServer()
        }
        // TODO: Timer.scheduledTimer() retrieveOpponentsLocationFromServer()
    }
    
    
    func recordLocationAndSendToServer() {
        let currentLocation = locationManager.location!
        
        let latitude = currentLocation.coordinate.latitude
        let longitude = currentLocation.coordinate.longitude
        let timestamp = currentLocation.timestamp
        
        print("record new current location: \(currentLocation)")
        
        // add to Firebase Database
        myLocationsID.childByAutoId().setValue(
            [
                "latitude"  : latitude,
                "longitude" : longitude,
                "timestamp" : "\(timestamp)"
            ]
        )
    }
    

    // TODO: currently not working properly, when stopping running or closing app
    deinit {
        // delete data from server for recorded locations for game session
        gameSessionID.removeValue()
    }
    
    
    // MARK: - Location Manager object
    let locationManager: CLLocationManager! = CLLocationManager()
    
    func checkLocation() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
        
        // enable location usage if not authorised
        switch CLLocationManager.authorizationStatus() {
        case .notDetermined:
            // Request when-in-use authorization initially
            locationManager.requestWhenInUseAuthorization()
            break
            
        case .restricted, .denied:
            // Disable location features
            break
            
        case .authorizedWhenInUse, .authorizedAlways:
            // Enable location features
            break
        }
        
    }
    
}

protocol LocationModelDelegate {
    func modelListener()
}
