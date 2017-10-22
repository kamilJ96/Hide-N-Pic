//
//  GetLocation.swift
//  Hide&PicLocationServices
//
//  Created by Kamil on 6/9/17.
//  Copyright © 2017 VanillaThunder. All rights reserved.
//

import Foundation
import CoreLocation

// Delegate function that implements the CoreLocationManager, allows you to
// use CoreLocation services
class GetLocation: CLLocationManagerDelegate {
    var locationManager = CLLocationManager()
    
    func checkLocation() {
        if locationManager.authorizationStatus() == .notDetermined {
            locationManager.requestWhenInUseAuthorization()
        }
    }
}
