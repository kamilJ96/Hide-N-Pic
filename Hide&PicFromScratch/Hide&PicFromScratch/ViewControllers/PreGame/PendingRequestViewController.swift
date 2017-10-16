//
//  PendingRequestViewController.swift
//  Hide&PicFromScratch
//
//  Created by Leonard Zou on 13/10/17.
//  Copyright © 2017 VanillaThunder. All rights reserved.
//

import UIKit

class PendingRequestViewController: UIViewController, GameStateModelObserver {

    var gameStateModel: GameStateModel! {
        didSet {
            gameStateModel.pendingGameRequestResponseObserver = self
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    
    func friendDidRespondToInvite(with response: String) {
        switch response {
        case "declined":
            // go back to friends list screen
            self.presentingViewController?.dismiss(animated: true)
        case "accepted":
            performSegue(withIdentifier: "FriendAcceptedGoToGame", sender: self)
        default:
            break
        }
    }
    
    @IBAction func cancelButtonTapped(_ sender: UIBarButtonItem) {
        gameStateModel.cancelInvite()
        self.presentingViewController?.dismiss(animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        if let mainGameVC = segue.destination.contents as? MainGameViewController {
            mainGameVC.gameStateModel = gameStateModel
        }
    }

}
