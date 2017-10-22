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
    
    @IBOutlet weak var mapView: MKMapView!
    
    let regionRadius: CLLocationDistance = 100 // the frame of the map view

    var locationModel: LocationModel? {
        didSet {
            locationModel?.addObserver(self)
        }
    }
    
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
            mapView.addAnnotation(latestLocationPin!)
        }
    }
    
    
    // MARK: - MKMapViewDelegate functions
    
    // returns a standard pin view to use to display the annotation, and also animatesDrop
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation { return nil }
        
        let annotationView = MKPinAnnotationView()
        annotationView.animatesDrop = true
        
        // automatically fade new pin views according to how old they are
        var alpha: CGFloat = 1
        if let annotation = annotation as? CLLocation {
            alpha = CGFloat(1 - (abs(annotation.timestamp.timeIntervalSinceNow) / DefaultValues.locationHintFadeTime))
        }
        
        annotationView.alpha = alpha
        
        return annotationView
    }
    
    
    func mapView(_ mapView: MKMapView, didAdd views: [MKAnnotationView]) {
        for annotationView in views {
            if annotationView == mapView.view(for: mapView.userLocation)  {
                continue
            }
            
            // create animator to animate pin fade out over 15 seconds
            UIViewPropertyAnimator.runningPropertyAnimator(
                withDuration: DefaultValues.locationHintFadeTime * Double(annotationView.alpha), // if pin has already started fading, fade out faster
                delay: 0,
                options: .curveLinear,
                animations: { annotationView.alpha = 0.0 },
                completion: { animatingPosition in
                    self.removeExpiredAnnotations()
                }
            )
        }
        
    }
    
    // when a map view is loaded for the first time, add all annotation pins that are younger than locationHintFadeTime
    func displayUnexpiredLocations() {
        if locationModel == nil { return }
        
        for location in locationModel!.opponentsLocations {
            if abs(location.timestamp.timeIntervalSinceNow) < DefaultValues.locationHintFadeTime {
                mapView.addAnnotation(location)
            }
        }
    }
    
    func removeExpiredAnnotations() {
        for annotation in mapView.annotations {
            if let annotation = annotation as? CLLocation {
                // if annotation pin is older than hint fade time then remove from mapView
                if abs(annotation.timestamp.timeIntervalSinceNow) > DefaultValues.locationHintFadeTime {
                    mapView.removeAnnotation(annotation)
                }
            }
        }
    }
    
    // MARK: - View Controller Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        mapView.delegate = self
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // reframe region around player
        // mapView.showAnnotations(mapView.annotations, animated: false) // alternative way to reframe
        if let playerLocationCoordinate = locationModel?.playerLocation?.coordinate {
            let region = MKCoordinateRegionMakeWithDistance(playerLocationCoordinate, regionRadius * 2.0, regionRadius * 2.0)
            mapView.setRegion(region, animated: false)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        // add all unexpired pins again (i.e. pins that are younger than DefaultValues.locationHintFadeTime
        displayUnexpiredLocations()
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
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
