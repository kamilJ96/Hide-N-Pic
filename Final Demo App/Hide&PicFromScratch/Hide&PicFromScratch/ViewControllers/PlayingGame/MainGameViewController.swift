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
import FirebaseAuth

// this view controller contains as subviews: the AR view, the small map view, the messages button, and hold down for photo button
class MainGameViewController: UIViewController, GameStateModelObserver {

    var gameStateModel: GameStateModel!
    var locationModel: LocationModel!
    
    var augmentedRealityVC: ARCLViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // unwind segue from expanded map view back to main game screen
    @IBAction func goBack(segue: UIStoryboardSegue) { }
    
    @IBAction func messagesButton(_ sender: Any) {
        performSegue(withIdentifier: "fromMainGameVCtoChatVC", sender: self)
    }
    
    @IBAction func buttonToTakePhoto(_ sender: UILongPressGestureRecognizer) {
        if sender.state == .began {
            performSegue(withIdentifier: "from MainGameVC to EndGameImage VC", sender: self)
        }
    }
    
    // MARK: - Navigation
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    
    /* Send locationModel to MapViewController */
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        if locationModel == nil {
            locationModel = LocationModel(gameStateModel)
        }
        
        // works for both MapViewController that is embedded in a NavigationController, and not embedded
        if let mapVC = segue.destination.contents as? MapViewController {
            mapVC.locationModel = locationModel
            return
        }
        
        if let arVC = segue.destination.contents as? ARCLViewController {
            arVC.locationModel = locationModel
            self.augmentedRealityVC = arVC
            return
        }
        
        if let chatVC = segue.destination.contents as? ChatViewController {
            let currentUser = Auth.auth().currentUser!
            chatVC.senderId = currentUser.uid
            chatVC.senderDisplayName = currentUser.displayName
            chatVC.receiverId = gameStateModel.opponentPlayerUserID
            chatVC.receiverName = gameStateModel.opponentPlayerName
            return
        }
        
        if let endGameVC = segue.destination.contents as? EndGameImageViewController {
            if let arViewScreenShot = augmentedRealityVC?.sceneLocationView.snapshot() {
                endGameVC.endGameImage = arViewScreenShot
            }
            return
        }
    }

   
    
    // MARK: - GameStateModel Delegate functions
    
    func gameDidEnd() {
        // TODO: clean up server, remove observers etc
    }
}

// code from Stanford CS193P Lecture 7 https://web.stanford.edu/class/cs193p/cgi-bin/drupal/
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
