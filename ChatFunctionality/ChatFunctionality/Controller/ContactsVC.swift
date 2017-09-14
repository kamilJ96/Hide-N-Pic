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
        
        
        FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "id, name, email"]).start {
            (connection, result, err) in
            
            if err != nil {
                print("failed to start graph request:", err)
                return
            }
            print(result)
        }
        
        if let user = Auth.auth().currentUser {
            let uid = user.uid
            manageConnections(userId: uid)
        }

        // Do any additional setup after loading the view.
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
