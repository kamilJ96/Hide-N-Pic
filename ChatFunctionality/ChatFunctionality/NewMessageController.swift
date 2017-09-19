//
//  NewMessageController.swift
//  ChatFunctionality
//
//  Created by Karan Singh on 17/9/17.
//  Copyright © 2017 Karan Singh. All rights reserved.
//

import UIKit
import Firebase

class NewMessageController: UITableViewController {
    
    let cellId = "cellId"
    
    var users = [User]()
    
    var current_user = Auth.auth().currentUser
    
    var receiver_name = String()
    var receiver_id = String()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UserCell.self, forCellReuseIdentifier: cellId)
        fetchUser()
        

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    func fetchUser() {
        Database.database().reference().child("user_profile").observe(.childAdded, with: {
            (Snapshot) in
            
            if let dictionary = Snapshot.value as? [String: AnyObject] {
                let user = User()
                //if you use this setter, app will crash if properties dont match with firebase
                user.name = dictionary["name"] as! String
                user.id = Snapshot.key
                // if current user's name equals a database user
                if self.current_user?.displayName == user.name {
                    // do nothing
                } else {
                    self.users.append(user)
                }
                
                DispatchQueue.main.async(execute: {
                    self.tableView.reloadData()

                });
            }
            //print("user found")
            //print(Snapshot)
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func cancelPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
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

}
class UserCell: UITableViewCell {
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("has not been implemented correctly")
    }
    
}
