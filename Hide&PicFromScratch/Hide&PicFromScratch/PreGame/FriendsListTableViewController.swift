//
//  FriendsListTableViewController.swift
//  Hide&PicFromScratch
//
//  Created by Leonard Zou on 13/10/17.
//  Copyright © 2017 VanillaThunder. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth

class FriendsListTableViewController: UITableViewController {

    // TODO: in this class, have the logic for initiating a new game, when tapping on a friend's name
    
    var current_user = Auth.auth().currentUser
    
    let cellId = "cellId"
    var users = [User]()
    var receiver_name = String()
    var receiver_id = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("\ncurrent_user = \(String(describing: current_user))\n") // DEBUG
        print() // DEBUG
        
        tableView.register(UserCell.self, forCellReuseIdentifier: cellId)
        fetchUser()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    // Retrieving the current users of the app (however its every single user atm)
    func fetchUser() {
        Database.database().reference().child("user_profile").observe(.childAdded, with: {
            (Snapshot) in
            
            if let dictionary = Snapshot.value as? [String: AnyObject] {
                let user = User()
                // If you use this setter, app will crash if properties dont match with firebase
                user.name = dictionary["name"] as! String
                user.id = Snapshot.key
                // If current user's name equals a database user
                if self.current_user?.displayName == user.name {
                    // Do nothing
                } else {
                    self.users.append(user)
                }
                DispatchQueue.main.async(execute: {
                    self.tableView.reloadData()
                });
            }
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return users.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // let cell = UITableViewCell(style: .subtitle, reuseIdentifier: cellId)
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)
        let user = users[indexPath.row]
        cell.textLabel?.text = user.name
        return cell
    }
    
    // Handles the selection of a user in the DB
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.receiver_name = self.users[indexPath.row].name!
        self.receiver_id = self.users[indexPath.row].id!
        self.performSegue(withIdentifier: "Chat", sender: self.users[indexPath.row])
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        let navVc = segue.destination as! UINavigationController
        let chatVc = navVc.viewControllers.first as! ChatViewController
        chatVc.senderId = current_user?.uid
        chatVc.senderDisplayName = self.current_user?.displayName
        chatVc.receiverId = self.receiver_id
        chatVc.receiverName = self.receiver_name
    }
    
    class UserCell: UITableViewCell {
        override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
            super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        }
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("has not been implemented correctly")
        }
        
    }

    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
