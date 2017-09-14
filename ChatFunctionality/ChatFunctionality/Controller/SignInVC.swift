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
                self.loginButton.readPermissions = ["email", "public_profile"]
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
            
            if error != nil {
                print("something went wrong with our fb user: ", error)
                return
            }
            
            print("user logged into firebase ", user)
            
        })
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
