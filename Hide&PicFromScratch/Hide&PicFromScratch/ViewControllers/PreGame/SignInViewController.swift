//
//  SignInViewController.swift
//  Combined-Maps-ARKit
//
//  Created by Karan Singh on 9/10/17.
//  Copyright © 2017 VanillaThunder. All rights reserved.
//

import UIKit

import FirebaseAuth
import FBSDKLoginKit
import Firebase
import FirebaseDatabase
import FirebaseStorage

class SignInViewController: UIViewController, FBSDKLoginButtonDelegate {

    private let HOME_SEGUE = "ToHome"
    
    @IBOutlet weak var EmailTF: UITextField!
    @IBOutlet weak var PasswordTF: UITextField!
    let loginButton = FBSDKLoginButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loginButton.isHidden = true
        Auth.auth().addStateDidChangeListener { auth, user in
            if let user = user {
                // User is still signed in
                print("user is still signed in")
                // Sends them to the logged in page
                self.performSegue(withIdentifier: self.HOME_SEGUE, sender: nil)
            } else {
                // User is not logged in
                // present log in button and unhide it
                self.loginButton.frame = CGRect(x: 16, y:50, width: self.view.frame.width - 32, height: 50)
                self.loginButton.readPermissions = ["email", "public_profile", "user_friends"]
                self.loginButton.delegate = self
                self.view.addSubview(self.loginButton)
                
                self.loginButton.isHidden = false
            }
        }
        // Do any additional setup after loading the view.
    }
    
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        print("did log out of facebook")
    }
    
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        if error != nil {
            print(error)
            return
        }
        print("Successful log in")
        
        loginButton.isHidden = true
        let accessToken = FBSDKAccessToken.current()
        guard let accessTokenString = accessToken?.tokenString else
        { return }
        
        let credentials = FacebookAuthProvider.credential(withAccessToken: (accessToken?.tokenString)!)
        Auth.auth().signIn(with: credentials, completion: { (user, error) in
            
            // When the user logs in for the first time, we'll store the users name and the users email on their profile page
            if error != nil {
                print("something went wrong with our fb user: ", error)
                return
            } else {
                let databaseRef = Database.database().reference()
                // Creating name and email references for user in DB from facebook
                // And setting them to be online
                databaseRef.child("user_profile").child("\(user!.uid)/name").setValue(user?.displayName)
                databaseRef.child("user_profile").child("\(user!.uid)/email").setValue(user?.email)
                databaseRef.child("user_profile").child("\(user!.uid)/online").setValue(true)
            }
            print("user logged into firebase ", user)
        })
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

