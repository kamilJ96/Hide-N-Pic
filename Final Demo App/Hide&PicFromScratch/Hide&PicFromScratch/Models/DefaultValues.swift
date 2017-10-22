//
//  DefaultValues.swift
//  Hide&PicFromScratch
//
//  Created by Leonard Zou on 13/10/17.
//  Copyright © 2017 VanillaThunder. All rights reserved.
//

import Foundation
import CoreLocation

// class to remove magic numbers from across the app
public struct DefaultValues {
    // for pins
    static let locationUpdateFrequency: TimeInterval = 5 // seconds
    static let locationHintFadeTime: TimeInterval = 15 // seconds
    
    // for creating new CLLocation objects to be displayed in mapViews
    static let altitude: CLLocationDistance = 50 // metres
    static let horizontalAccuracy: CLLocationAccuracy = 0 // metres
    static let verticalAccuracy: CLLocationAccuracy = 0 // metres
}
