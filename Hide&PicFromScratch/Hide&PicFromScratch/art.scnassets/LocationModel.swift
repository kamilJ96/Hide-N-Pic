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
    // TODO: change back to invitedPlayerString. temporarily use our own string to test retrieiving data
    lazy var opponentPlayerString = initiatingPlayerString
    
    // Firebase database references
    let ref: DatabaseReference! = Database.database().reference()
    var gameSessionID: DatabaseReference!
    var myLocationsID: DatabaseReference!
    var opponentsLocationsID: DatabaseReference!
    
    
    var playerLocation: CLLocation? {
        return locationManager.location!
    }
    
    // TODO: these two variables may need to be used for updating map and AR views
    var opponentsLocations: Array<CLLocation> = [] {
        didSet {
            // TODO: notify listeners
            print("opponentsLocations = \(opponentsLocations)")
        }
    }
    
    public override init() {
        super.init()
        checkLocation()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.startUpdatingLocation()
        }
        
        // Create new game session in Firebase Database
        gameSessionID = ref.child(gameSessionsString).childByAutoId()
        
        
        startGame()
        
    }
    
    public func startGame() {
        myLocationsID = gameSessionID.child(myPlayerString)
        opponentsLocationsID = gameSessionID.child(opponentPlayerString)
        
        // start continuously sending location to server
        Timer.scheduledTimer(withTimeInterval: locationUpdateFrequency, repeats: true) { [weak self] timer in
            self?.recordLocationAndSendToServer()
        }
        
        // listen for when new locations are added to opponent's location list on server
        let _ = opponentsLocationsID.observe(DataEventType.childAdded, with: { (snapshot) in
            if let locationDict = snapshot.value as? NSDictionary {
                
                if let latitude = locationDict["latitude"] as? CLLocationDegrees,
                    let longitude = locationDict["longitude"] as? CLLocationDegrees,
                    let timestampString = locationDict["timestamp"] as? String
                {
                    // try convert timestampString to a Date
                    let dateFormatter = DateFormatter()
                    // timestapString comes formated as "2017-10-11 08:32:36 +0000";
                    dateFormatter.dateFormat = "yyyy-MM-dd hh:mm:ss Z"
                    let timestamp = dateFormatter.date(from: timestampString)
                    if timestamp != nil {
                        // successfully converted timestamp string into Date type
                        // create new CLLocation, add it to user array
                        let coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
                        self.opponentsLocations.append(CLLocation(coordinate: coordinate, altitude: 50, horizontalAccuracy: 0, verticalAccuracy: 0, timestamp: timestamp!))
                    }
                }
                
                
            }
        })

    }
    
    
    func recordLocationAndSendToServer() {
        let currentLocation = locationManager.location!
        
        let latitude = currentLocation.coordinate.latitude
        let longitude = currentLocation.coordinate.longitude
        let timestamp = currentLocation.timestamp
        
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
        // remove listeners
        opponentsLocationsID.removeAllObservers()
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
