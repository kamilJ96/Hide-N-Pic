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


class ViewController: UIViewController {
    // This is the main class we will use from ARCL pod
    var sceneLocationView = SceneLocationView()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Code from ARCL readme file under Quick Start Guide heading
        sceneLocationView.run()
        view.addSubview(sceneLocationView)
        
        //==============================================================
        // remove this code later, only for getting start purposes
        let image = UIImage(named: "pin")!
        
        let universityOval = CLLocationCoordinate2D(latitude: -37.794472, longitude: 144.961393)
        let universityOvalLocation = CLLocation(coordinate: universityOval, altitude: 300)
        let annotationNode1 = LocationAnnotationNode(location: universityOvalLocation, image: image)
        sceneLocationView.addLocationNodeWithConfirmedLocation(locationNode: annotationNode1)
        
        
        let theSpot = CLLocationCoordinate2D(latitude: -37.801625, longitude: 144.958838)
        let theSpotLocation = CLLocation(coordinate: theSpot, altitude: 300)
        let annotationNode2 = LocationAnnotationNode(location: theSpotLocation, image: image)
        sceneLocationView.addLocationNodeWithConfirmedLocation(locationNode: annotationNode2)
        
        // TODO: add third location from Twist app
/*
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

}
