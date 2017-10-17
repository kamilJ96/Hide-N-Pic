//
//  ViewController.swift
//  ARKit+CoreLocation
//
//  Created by Andrew Hart on 02/07/2017.
//  Copyright © 2017 Project Dent. All rights reserved.
//  Modified by Leonard Zou
//

import UIKit
import SceneKit 
import MapKit
import ARCL

@available(iOS 11.0, *)
class ARCLViewController: UIViewController, MKMapViewDelegate, SceneLocationViewDelegate, LocationModelObserver {
    let sceneLocationView = SceneLocationView()
    
    var demoArray: Array<CLLocationCoordinate2D> = [
        CLLocationCoordinate2DMake(-37.799634, 144.961783),
        CLLocationCoordinate2DMake(-37.799846, 144.961971),
        CLLocationCoordinate2DMake(-37.800003, 144.962384),
        CLLocationCoordinate2DMake(-37.800126, 144.962990),
        CLLocationCoordinate2DMake(-37.800049, 144.963521)
    ]
    
    var annotationsOnScreen: Array<LocationNode> = []
    
    var userAnnotation: MKPointAnnotation?
    var locationEstimateAnnotation: MKPointAnnotation?
    
    ///Whether to display some debugging data
    ///This currently displays the coordinate of the best location estimate
    ///The initial value is respected
    var displayDebugging = false
    
    var adjustNorthByTappingSidesOfScreen = true
    
    var locationModel: LocationModel? {
        didSet {
            // register as locationModel observer
            locationModel?.addObserver(self)
        }
    }
    
    
    // listens to when the model gets updated (i.e. when a new opponent's location is added)
    func locationModelDidUpdate() {
        /////////////////////////////////////////////////////////////////////////////////////
        // test code, no need to keep this
        if demoArray.count < 1 {return}
        let nextLocation = demoArray.removeFirst()
        annotationsOnScreen.append(addNewLocationAnnotationNodeToScene(latitude: nextLocation.latitude, longitude: nextLocation.longitude))
        
        /////////////////////////////////////////////////////////////////////////////////////
        // real code keep this for demo
//        if let nextLocation = locationModel?.opponentsLocations.last {
//            annotationsOnScreen.append(addNewLocationAnnotationNodeToScene(latitude: nextLocation.coordinate.latitude, longitude: nextLocation.coordinate.longitude))
//        }
        
        // magic number 3, because pins show up every five seconds are meant to disappear after 15 seconds
        if annotationsOnScreen.count > 3 {
            sceneLocationView.removeLocationNode(locationNode: annotationsOnScreen.removeFirst())
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Set to true to display an arrow which points north.
        //Checkout the comments in the property description and on the readme on this.
        sceneLocationView.orientToTrueNorth = false
        
//        sceneLocationView.locationEstimateMethod = .coreLocationDataOnly
//        sceneLocationView.showAxesNode = false
        sceneLocationView.locationDelegate = self
        
        
        // add a pin to AR view
        let pinCoordinate = CLLocationCoordinate2D(latitude: -37.788468, longitude: 145.138788)
        let pinLocation = CLLocation(coordinate: pinCoordinate, altitude: 100)
        let pinImage = UIImage(named: "pin")!
        let pinLocationNode = LocationAnnotationNode(location: pinLocation, image: pinImage)
        sceneLocationView.addLocationNodeWithConfirmedLocation(locationNode: pinLocationNode)
        
        view.addSubview(sceneLocationView)
    }
    
    func addNewLocationAnnotationNodeToScene(
        latitude: CLLocationDegrees, longitude: CLLocationDegrees,
        altitude: CLLocationDistance = DefaultValues.altitude,
        scaleRelativeToDistance: Bool = true)
        -> LocationAnnotationNode
    {
        let image = UIImage(named: "pin")!
        
        let locationCoordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        let location = CLLocation(coordinate: locationCoordinate, altitude: altitude)
        
        let annotationNode = LocationAnnotationNode(location: location, image: image)
        annotationNode.scaleRelativeToDistance = scaleRelativeToDistance
        sceneLocationView.addLocationNodeWithConfirmedLocation(locationNode: annotationNode)
        print("Coordinate added: \(latitude), \(longitude)") // DEBUG
        
        return annotationNode
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        sceneLocationView.run()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        

        // Pause the view's session
        sceneLocationView.pause()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        sceneLocationView.frame = CGRect(
            x: 0,
            y: 0,
            width: self.view.frame.size.width,
            height: self.view.frame.size.height)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }
    
    
    //MARK: MKMapViewDelegate
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation {
            return nil
        }
        
        if let pointAnnotation = annotation as? MKPointAnnotation {
            let marker = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: nil)
            
            if pointAnnotation == self.userAnnotation {
                marker.displayPriority = .required
                marker.glyphImage = UIImage(named: "user")
            } else {
                marker.displayPriority = .required
                marker.markerTintColor = UIColor(hue: 0.267, saturation: 0.67, brightness: 0.77, alpha: 1.0)
                marker.glyphImage = UIImage(named: "compass")
            }
            
            return marker
        }
        
        return nil
    }
    
    //MARK: SceneLocationViewDelegate
    
    func sceneLocationViewDidAddSceneLocationEstimate(sceneLocationView: SceneLocationView, position: SCNVector3, location: CLLocation) {

    }
    
    func sceneLocationViewDidRemoveSceneLocationEstimate(sceneLocationView: SceneLocationView, position: SCNVector3, location: CLLocation) {

    }
    
    func sceneLocationViewDidConfirmLocationOfNode(sceneLocationView: SceneLocationView, node: LocationNode) {
    }
    
    func sceneLocationViewDidSetupSceneNode(sceneLocationView: SceneLocationView, sceneNode: SCNNode) {
        
    }
    
    func sceneLocationViewDidUpdateLocationAndScaleOfLocationNode(sceneLocationView: SceneLocationView, locationNode: LocationNode) {
        
    }
}

extension DispatchQueue {
    func asyncAfter(timeInterval: TimeInterval, execute: @escaping () -> Void) {
        self.asyncAfter(
            deadline: DispatchTime.now() + Double(Int64(timeInterval * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC), execute: execute)
    }
}

extension UIView {
    func recursiveSubviews() -> [UIView] {
        var recursiveSubviews = self.subviews
        
        for subview in subviews {
            recursiveSubviews.append(contentsOf: subview.recursiveSubviews())
        }
        
        return recursiveSubviews
    }
}
