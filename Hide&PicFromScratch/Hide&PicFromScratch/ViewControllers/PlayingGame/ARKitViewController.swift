//
//  ViewController.swift
//  Hide&PicFromScratch
//
//  Created by Leonard Zou on 10/10/17.
//  Copyright © 2017 VanillaThunder. All rights reserved.
//

import UIKit
import SceneKit
import ARKit
import ARCL

class ARKitViewController: UIViewController, ARSCNViewDelegate, LocationModelObserver {

    @IBOutlet var sceneView: ARSCNView!
    var endGameImage: UIImage?
    
    @IBAction func handleLongPress(_ sender: Any) {
        print("handleLongPress() -> sender = \(sender)")
        if let longPressRecogniser = sender as? UILongPressGestureRecognizer {
            switch longPressRecogniser.state {
            case .began:
                endGameImage = sceneView.snapshot()
                performSegue(withIdentifier: "from ARScene to EndGameImageVC", sender: self)
            default:
                break
            }
        }
    }
    
    var locationModel: LocationModel? {
        didSet {
            // register as locationModel observer
            locationModel?.addObserver(self)
        }
    }
    
    // listens to when the model gets updated (i.e. when a new opponent's location is added)
    func locationModelDidUpdate() {
        // TODO: check to see if this ARView is visible on screen before doing any UI stuff
        
    }
    
    
    // MARK: - default AR app code
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and timing information
//        sceneView.showsStatistics = true
        
        // Create a new scene
        let scene = SCNScene()
        
        // Set the scene to the view
        sceneView.scene = scene
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()

        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

    // MARK: - ARSCNViewDelegate
    
/*
    // Override to create and configure nodes for anchors added to the view's session.
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        let node = SCNNode()
     
        return node
    }
*/
    
    func session(_ session: ARSession, didFailWithError error: Error) {
        // Present an error message to the user
        
    }
    
    func sessionWasInterrupted(_ session: ARSession) {
        // Inform the user that the session has been interrupted, for example, by presenting an overlay
        
    }
    
    func sessionInterruptionEnded(_ session: ARSession) {
        // Reset tracking and/or remove existing anchors if consistent tracking is required
        
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        if let endGameImageVC = segue.destination.contents as? EndGameImageViewController {
            endGameImageVC.endGameImage = endGameImage
        }
    }
}
