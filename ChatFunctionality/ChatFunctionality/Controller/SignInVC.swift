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

class SignInVC: UIViewController, FBSDKLoginButtonDelegate {
    
    private let CONTACTS_SEGUE = "ContactsSegue"
    
    @IBOutlet weak var EmailTF: UITextField!
    @IBOutlet weak var PasswordTF: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let loginButton = FBSDKLoginButton()
        view.addSubview(loginButton)
        loginButton.frame = CGRect(x: 16, y:50, width: view.frame.width - 32, height: 50)
        
        loginButton.delegate = self
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
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    @IBAction func register(_ sender: Any) {
    }
    @IBAction func login(_ sender: Any) {
        
        if EmailTF.text != "" && PasswordTF.text != "" {
            AuthProvider.Instance.login(withEmail: EmailTF.text!, password: PasswordTF.text!, loginHandler: { (message) in
                if message != nil {
                    self.alertTheUser(title: "Problem With Authentication", message: message!);
                } else {
                    print("login success")
                }
                
            })
        }
    }
    
    private func alertTheUser(title:String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert);
        let ok = UIAlertAction(title: "OK", style: .default, handler:nil);
        alert.addAction(ok);
        present(alert, animated:true, completion:nil);
    }
}
