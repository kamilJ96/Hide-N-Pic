//
//  SignInVC.swift
//  ChatFunctionality
//
//  Created by Karan Singh on 4/9/17.
//  Copyright © 2017 Karan Singh. All rights reserved.
//

import UIKit
import FirebaseAuth
import FBSDKLoginKit
import Firebase
import FirebaseDatabase
import FirebaseStorage

class SignInVC: UIViewController, FBSDKLoginButtonDelegate {
    
    private let CONTACTS_SEGUE = "ContactsSegue"
    
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
                self.performSegue(withIdentifier: self.CONTACTS_SEGUE, sender: nil)
            } else {
                // no one is signed in mate
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
        print("You good homie")
        loginButton.isHidden = true
        let accessToken = FBSDKAccessToken.current()
        
        guard let accessTokenString = accessToken?.tokenString else
        { return }
        
        let credentials = FacebookAuthProvider.credential(withAccessToken: (accessToken?.tokenString)!)
        Auth.auth().signIn(with: credentials, completion: { (user, error) in
            
            // when the user logs in for the first time, we'll store the users name and the users email on their profile page
            // also store the small version of their profile pic in the datbaase in the storage
            
            if error != nil {
                print("something went wrong with our fb user: ", error)
                return
            } else {
                let storage = Storage.storage()
                let storageRef = storage.reference(forURL: "gs://vanillathunder-ac0df.appspot.com/")
                let profilePicRef = storageRef.child(user!.uid+"/profile_pic_small.jpg")
                
                // store the userID
                let userID = user?.uid
                
                let databaseRef = Database.database().reference()
                databaseRef.child("user_profile").child(userID!).child("profile_pic_small").observeSingleEvent(of: .value, with: { (snapshot) in
                    let profile_pic = snapshot.value as? String?
                    
                    if(profile_pic == nil) {
                        if let imageData = NSData(contentsOf: user!.photoURL!) {
                            let uploadTask = profilePicRef.putData(imageData as Data, metadata:nil) {
                                metadata, error in
                                if(error == nil) {
                                    let downloadURL = metadata?.downloadURL
                                    
                                    databaseRef.child("user_profile").child("\(user!.uid)/profile_pic_small").setValue(downloadURL!()?.absoluteString)
                                } else {
                                    print("error downloading image")
                                }
                            }
                        }
                        databaseRef.child("user_profile").child("\(user!.uid)/name").setValue(user?.displayName)
                        databaseRef.child("user_profile").child("\(user!.uid)/email").setValue(user?.email)
                    } else {
                        print("user has logged in earlier ")
                    }
                    
                })
            }
            
            print("user logged into firebase ", user)
            
        })
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
