//
//  ContactsVC.swift
//  ChatFunctionality
//
//  Created by Karan Singh on 4/9/17.
//  Copyright © 2017 Karan Singh. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import Firebase
import FirebaseDatabase

class ContactsVC: UIViewController {
    
    private let SIGNIN_SEGUE = "backToSignIn"
    var ref = Database.database().reference()
    var user = Auth.auth().currentUser
    
    // store device id
    let deviceID = UIDevice.current.identifierForVendor?.uuidString
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let user = Auth.auth().currentUser {
            let uid = user.uid
            manageConnections(userId: uid)
        }
        
        
        checkIfUserIsLoggedIn()
        // Do any additional setup after loading the view.
    }

    
    func setUpNavBar(user: User) {
        let titleView = UIView()
        titleView.frame = CGRect(x: 0, y: 0, width: 100, height: 40)
        
        let containerView = UIView()
        containerView.translatesAutoresizingMaskIntoConstraints = false
        
        
        let nameLabel = UILabel()
        
        titleView.addSubview(containerView)
        
        containerView.addSubview(nameLabel)
        nameLabel.text = user.name
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.rightAnchor.constraint(lessThanOrEqualTo: containerView.rightAnchor).isActive = true
        containerView.centerXAnchor.constraint(equalTo: titleView.centerXAnchor).isActive = true
        containerView.centerYAnchor.constraint(equalTo: titleView.centerYAnchor).isActive = true
        self.navigationItem.titleView = titleView
    
        titleView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(showChatController)))

    }
    
    @objc func showChatController() {
        print(1222222) 
    }
    
    func fetchUserAndSetupNavBarTitle() {
        guard let uid = Auth.auth().currentUser?.uid else {
            return
        }
        
        self.ref.child("users").child(uid).observe(.value, with: {
            (snapshot) in
            if let dictionary = snapshot.value as? [String: AnyObject] {
                let user = User()
                user.setValuesForKeys(dictionary)
                self.setUpNavBar(user: user)
                
            }
        })
    }
    
    
    func checkIfUserIsLoggedIn() {
        fetchUserAndSetupNavBarTitle()
    }
    
    @IBAction func newMessageHandler(_ sender: Any) {
       /* let newMessageController = NewMessageController()
        let navController = UINavigationController(rootViewController: newMessageController)
        present(navController, animated: true, completion: nil) */
        
        self.performSegue(withIdentifier: "newMessage", sender: nil)
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func logout(_ sender: Any) {
        // signs user out of firebase
        try! Auth.auth().signOut()
        //sign the user out of facebook too
        FBSDKAccessToken.setCurrent(nil)
        
        let myConnectionsRef = Database.database().reference(withPath: "user_profile/\(self.user!.uid)/connections/\(self.deviceID!)")
        myConnectionsRef.child("online").setValue(false)
        
        myConnectionsRef.child("last_online").setValue(NSDate().timeIntervalSince1970)
        
        self.performSegue(withIdentifier: self.SIGNIN_SEGUE, sender: nil)
    }
    
    func manageConnections(userId: String) {
        // create a reference to the database
        let myConnectionsRef = Database.database().reference(withPath:"user_profile/\(userId)/connections/\(self.deviceID!)")
        myConnectionsRef.child("online").setValue(true)
        myConnectionsRef.child("last_online").setValue(NSDate().timeIntervalSince1970)
        // observer which will monitor if the user is logged in or out
        myConnectionsRef.observe(.value, with: {snapshot in
            // runs if the conditions are not met
            guard let connected = snapshot.value as? Bool, connected else {
                return
            }
        })
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
