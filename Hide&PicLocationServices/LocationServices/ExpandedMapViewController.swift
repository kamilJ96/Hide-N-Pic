//
//  ExpandedMapViewController.swift
//  Hide&PicLocationServices
//
//  Created by Kamil on 19/9/17.
//  Copyright © 2017 VanillaThunder. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

class ExpandedMapViewController: UIViewController {

    @IBOutlet weak var mapView: MKMapView!
    let regionRadius: CLLocationDistance = 100
    var playerLocation: CLLocation?
    var enemyLocation: CLLocation?
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Initialize region around player
        let region = MKCoordinateRegionMakeWithDistance((playerLocation?.coordinate)!, regionRadius * 2.0, regionRadius * 2.0)
        mapView.setRegion(region, animated: true)
        
        // Add pin for player (and enemy to be implemented)
        let location = LocationObject(title: "You", locationName: "player1", coordinate: CLLocationCoordinate2D(latitude: (playerLocation?.coordinate.latitude)!, longitude: (playerLocation?.coordinate.longitude)!))
        mapView.addAnnotation(location)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
