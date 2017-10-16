//
//  HomeScreenTabBarViewController.swift
//  Hide&PicFromScratch
//
//  Created by Leonard Zou on 16/10/17.
//  Copyright © 2017 VanillaThunder. All rights reserved.
//

import UIKit

class HomeScreenTabBarViewController: UITabBarController {
    
    var gameStateModel = GameStateModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        // pass reference to gameStateModel to sub views
        if let friendsVC = segue.destination.contents as? FriendsListTableViewController {
            friendsVC.gameStateModel = gameStateModel
            return
        }
        
        if let gameRequestsVC = segue.destination.contents as? GameRequestsTableViewController {
            gameRequestsVC.gameStateModel = gameStateModel
        }
    }
    

}
