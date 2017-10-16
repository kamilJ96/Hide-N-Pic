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

class GameRequestsTableViewController: UITableViewController, GameStateModelObserver {
    
    var gameStateModel: GameStateModel? {
        didSet {
            tableView.reloadData()
            gameStateModel?.gameRequestObservers.append(self)
        }
    }
    
    var gameRequestCellID = "gameRequestTableCell"
    var gameSessionID: DatabaseReference!
    
    
    @IBAction func acceptButton(_ sender: UIButton) {
        // from https://stackoverflow.com/questions/28659845/swift-how-to-get-the-indexpath-row-when-a-button-in-a-cell-is-tapped
//        if let cell = sender.superview?.superview as? CellView {
//            let indexPath = itemTable.indexPath(for: cell)
//        }
        // TODO: call gameStateModel.acceptInvite()
    }
    
    @IBAction func declineButton(_ sender: UIButton) {
        // TODO: call gameStateModel.declineInvite()
        
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    

    func gameRequestsArrayDidUpdate() {
//        print("\nGameRequestsTableViewController -> gameRequestsArrayDidUpdate()\n")
        tableView.reloadData()
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
        return gameStateModel?.gameRequests.count ?? 0
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: gameRequestCellID, for: indexPath)

        if let gameRequest: GameRequest = gameStateModel?.gameRequests[indexPath.row] {
            // Configure the cell...
            if let gameRequestTableCell = cell as? GameRequestTableViewCell {
                gameRequestTableCell.gameRequest = gameRequest
            }
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
    /*
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
    }
    */

}
