//
//  LocationObject.swift
//  Hide&PicLocationServices
//
//  Created by Kamil on 14/9/17.
//  Copyright © 2017 VanillaThunder. All rights reserved.
//

import Foundation
import MapKit

class LocationObject: NSObject, MKAnnotation {
    let title: NSString
    let locationName: String
    let coordinate: CLLocationCoordinate2D
    
    init (title: NSString, locationName: String, coordinate: CLLocationCoordinate2D) {
        self.title = title
        self.locationName = locationName
        self.coordinate = coordinate
    }
    
    var subtitle: NSString {
        return "locationName"
    }
}
