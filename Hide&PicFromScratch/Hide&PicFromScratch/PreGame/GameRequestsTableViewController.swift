//
//  GameRequestsTableViewController.swift
//  Hide&PicFromScratch
//
//  Created by Leonard Zou on 13/10/17.
//  Copyright © 2017 VanillaThunder. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth

class GameRequestsTableViewController: UITableViewController {
    
    // TODO: in this class, contantly listen to ref.child("myUserID").child("requests")
    // add new table cells when new requests pop up in the database
    
    var gameRequestCellID = "gameRequestTableCell"
    var gameRequests: Array<GameRequest> = []
    var gameSessionID: DatabaseReference!
    
    
    func fetchGameRequestsFromServer() {
        let myUserID = Auth.auth().currentUser?.uid
        let requestsDBref = Database.database().reference().child("user_profile").child(myUserID!).child("requests")
        
        let _ = requestsDBref.observe(.childAdded, with: {
            (snapshot) in
            // TODO: add all game requests to gameRequests array
            
            if let dictionary = Snapshot.value as? [String: AnyObject] {
                let gameRequest = GameRequest()
                // If you use this setter, app will crash if properties dont match with firebase
                gameRequest.invitingPlayerName = dictionary["initiatingPlayerName"] as? String
                gameRequest.gameSessionID = Snapshot.key
                
                self.gameRequests.append(gameRequest)
                
                DispatchQueue.main.async(execute: {
                    self.tableView.reloadData()
                });
            }
        })
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.gameSessionID = self.gameRequests[indexPath.row].gameSessionID!
        // perform segue to 
        //self.performSegue(withIdentifier: "Chat", sender: self.users[indexPath.row])
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return gameRequests.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: gameRequestCellID, for: indexPath)

        let gameRequest: GameRequest = gameRequests[indexPath.row]
        
        // Configure the cell...
        if let gameRequestCell = cell as? GameRequestTableViewCell {
            gameRequestCell.gameRequest = gameRequest
        }
        
        return cell
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let gameVC = segue.destination.contents as? MainGameViewController {
            gameVC.myPlayerString = "invitedPlayer"
        }
    }
    

}
