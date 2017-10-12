//
//  MapViewController.swift
//  Hide&PicFromScratch
//
//  Created by Leonard Zou on 11/10/17.
//  Copyright © 2017 VanillaThunder. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate, LocationModelObserver {

    @IBOutlet weak var mapView: MKMapView?
    
    let regionRadius: CLLocationDistance = 100

    var locationModel: LocationModel?
    
    var prevLocationPin: CLLocation! = nil
    
    
    // listens to when the model gets updated (i.e. when a new opponent's location is added)
    func locationModelDidUpdate() {
        // TODO: check to see if this MapView is visible on screen before doing any UI stuff
        // check if latest location is the same as the previous one
        let latestLocationPin = locationModel?.opponentsLocations.last
        if latestLocationPin == prevLocationPin { return }
        
        // create new location pin and display in map
        prevLocationPin = latestLocationPin
        if latestLocationPin != nil {
            mapView?.addAnnotation(latestLocationPin!)
        }
    }
    
    
    // returns a standard pin view to use to display the annotation, and also animatesDrop
    // MKMapViewDelegate function
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation {
            return nil
        }
        
        let annotationView = MKPinAnnotationView()
        annotationView.animatesDrop = true
        return annotationView
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        mapView?.delegate = self
        locationModel?.addObserver(self)
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        // reframe region around player
        let region = MKCoordinateRegionMakeWithDistance((locationModel?.playerLocation!.coordinate)!, regionRadius * 2.0, regionRadius * 2.0)
        mapView?.setRegion(region, animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}


// extension to allow us to use the CLLocation class as our annotation class
extension CLLocation: MKAnnotation {
    // since we do not need to display any titles or text for our map pins, return nil
    public var title: String? {
        return nil
    }
    public var subtitle: String? {
        return nil
    }
}
