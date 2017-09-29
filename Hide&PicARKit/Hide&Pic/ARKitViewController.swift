//
//  ViewController.swift
//  Hide&Pic
//
//  Created by Leonard Zou on 5/9/17.
//  Copyright © 2017 VanillaThunder. All rights reserved.
//

import UIKit
import SceneKit
import ARKit
import ARCL
import CoreLocation
import MapKit


class ARKitViewController: UIViewController {
    
    var sceneLocationView = SceneLocationView()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Code from ARCL readme file under Quick Start Guide heading
        // TODO check this init, to see what's happening with the CGRect frame
        sceneLocationView.run()
        view.addSubview(sceneLocationView)
        
        //==============================================================
        // remove this code later, only for getting start purposes
/*
        // UniversityOval
        addNewLocationAnnotationNodeToScene(latitude: -37.794472, longitude: 144.961393, scaleRelativeToDistance: false)
        // the Spot commerce building
        addNewLocationAnnotationNodeToScene(latitude: -37.801625, longitude: 144.958838, scaleRelativeToDistance: false)
 */
        

        // places around Alice Hoy and SMAC and ERC
        // 1
        addNewLocationAnnotationNodeToScene(latitude: -37.799288, longitude: 144.963672)
        // 2
        addNewLocationAnnotationNodeToScene(latitude: -37.799284, longitude: 144.963570)
        // 3
        addNewLocationAnnotationNodeToScene(latitude: -37.799396, longitude: 144.963460)
        // 4
        addNewLocationAnnotationNodeToScene(latitude: -37.799485, longitude: 144.963441)
        // 5
        addNewLocationAnnotationNodeToScene(latitude: -37.799549, longitude: 144.963350)
        // 6
        addNewLocationAnnotationNodeToScene(latitude: -37.799508, longitude: 144.963114)
        // 7
        addNewLocationAnnotationNodeToScene(latitude: -37.799286, longitude: 144.963130)
        // 8
        addNewLocationAnnotationNodeToScene(latitude: -37.799061, longitude: 144.963205)
        // 9
        addNewLocationAnnotationNodeToScene(latitude: -37.798828, longitude: 144.963208)
        // 10
        addNewLocationAnnotationNodeToScene(latitude: -37.798688, longitude: 144.963355)
        // 11
        addNewLocationAnnotationNodeToScene(latitude: -37.798633, longitude: 144.963540)
        
/*      // Example code copied from AR+CL Xcode project
        let tempNode = LocationAnnotationNode(location: location, image: image)
        sceneLocationView.addLocationNodeForCurrentPosition(locationNode: tempNode)
 */
        //==============================================================
        
    }
    
    // This function's code from ARCL readme file under Quick Start Guide heading
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        sceneLocationView.frame = view.bounds
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
/*
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()

        // Run the view's session
        sceneView.session.run(configuration)
 */
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        //sceneView.session.pause()
        
        // Code from ARCL readme file under Quick Start Guide heading
        sceneLocationView.pause()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }
    
    // MARK: - code added by Leonard
    
    func addNewLocationAnnotationNodeToScene(
        latitude: CLLocationDegrees, longitude: CLLocationDegrees,
        altitude: CLLocationDistance = 50,
        scaleRelativeToDistance: Bool = true)
    {
        let image = UIImage(named: "pin")!
        
        let locationCoordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        let location = CLLocation(coordinate: locationCoordinate, altitude: altitude)
        
        let annotationNode = LocationAnnotationNode(location: location, image: image)
        annotationNode.scaleRelativeToDistance = scaleRelativeToDistance
        sceneLocationView.addLocationNodeWithConfirmedLocation(locationNode: annotationNode)
    }

}
