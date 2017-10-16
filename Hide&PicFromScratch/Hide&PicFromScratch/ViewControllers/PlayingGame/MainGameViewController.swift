//
//  MainGameViewController.swift
//  Hide&PicFromScratch
//
//  Created by Leonard Zou on 10/10/17.
//  Copyright © 2017 VanillaThunder. All rights reserved.
//

import UIKit
import MapKit
import FirebaseDatabase

class MainGameViewController: UIViewController, GameStateModelDelegate {

    var locationModel: LocationModel!
    var myPlayerString: String = "" // TODO: change this to a gameStateModel local var
    var gameSessionID: DatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        locationModel = LocationModel(myPlayerString: myPlayerString)
        locationModel.gameSessionID = gameSessionID
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // unwind segue from expanded map view back to main game screen
    @IBAction func goBack(segue: UIStoryboardSegue) { }
    
    
    // MARK: - Navigation
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    
    /* Send locationModel to MapViewController */
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        // works for both MapViewController that is embedded in a NavigationController, and not embedded
        if let mapVC = segue.destination.contents as? MapViewController {
                mapVC.locationModel = locationModel
        }
    }


    // MARK: - GameStateModel Delegate functions
    
    // may do this via a different implementation where we observe gameStateModel.gameState
    func gameDidEnd() {
        // TODO:
    }
}

extension UIViewController
{
    // a friendly var we've added to UIViewController
    // it returns the "contents" of this UIViewController
    // which, if this UIViewController is a UINavigationController
    // means "the UIViewController contained in me (and visible)"
    // otherwise, it just means the UIViewController itself
    // could easily imagine extending this for UITabBarController too
    var contents: UIViewController {
        if let navcon = self as? UINavigationController {
            return navcon.visibleViewController ?? self
        } else {
            return self
        }
    }
}
