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

class ContactsVC: UIViewController {
    
    private let SIGNIN_SEGUE = "backToSignIn"

    override func viewDidLoad() {
        super.viewDidLoad()
        
        FBSDKGraphRequest(graphPath: "me/friends", parameters: ["fields": "id, name, email"]).start {
            (connection, result, err) in
            
            
            if err != nil {
                print("failed to start graph request:", err)
                return
            }
            
            print(result)
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
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
