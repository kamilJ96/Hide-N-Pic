//
//  HomeScreenTabBarViewController.swift
//  Hide&PicFromScratch
//
//  Created by Leonard Zou on 16/10/17.
//  Copyright © 2017 VanillaThunder. All rights reserved.
//

import UIKit

class HomeScreenTabBarViewController: UITabBarController, UITabBarControllerDelegate, GameStateModelObserver {
    
    var gameStateModel = GameStateModel() // shared by subviews "FriendsList" and "GameRequests"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.delegate = self
        
        gameStateModel.gameRequestObservers.append(self)
        
        for viewController in viewControllers! {
            // pass reference to gameStateModel to sub view controllers
            if let friendsVC = viewController as? FriendsListTableViewController {
                if friendsVC.gameStateModel == nil {
                    friendsVC.gameStateModel = gameStateModel
                    return
                }
            }
            
            if let gameRequestsVC = viewController as? GameRequestsTableViewController {
                if gameRequestsVC.gameStateModel == nil {
                    gameRequestsVC.gameStateModel = gameStateModel
                    return
                }
            }
        }
    }
    
    func gameRequestsArrayDidUpdate() {
        tabBar.items?[1].badgeValue = String(gameStateModel.gameRequests.count)
    }
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        // pass reference to gameStateModel to sub view controllers
        if let friendsVC = viewController as? FriendsListTableViewController {
            if friendsVC.gameStateModel == nil {
                friendsVC.gameStateModel = gameStateModel
                return
            }
        }
        
        if let gameRequestsVC = viewController as? GameRequestsTableViewController {
            if gameRequestsVC.gameStateModel == nil {
                gameRequestsVC.gameStateModel = gameStateModel
                return
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    // MARK: - Navigation
    /*
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
    }
    */
}
