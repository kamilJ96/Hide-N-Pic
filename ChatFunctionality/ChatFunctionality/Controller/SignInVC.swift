//
//  SignInVC.swift
//  ChatFunctionality
//
//  Created by Karan Singh on 4/9/17.
//  Copyright © 2017 Karan Singh. All rights reserved.
//

import UIKit
import FirebaseAuth

class SignInVC: UIViewController {
    
    private let CONTACTS_SEGUE = "ContactsSegue"
    
    @IBOutlet weak var UsernameTF: UITextField!
    @IBOutlet weak var PasswordTF: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func register(_ sender: Any) {
    }
    @IBAction func login(_ sender: Any) {
        
        if UsernameTF.text != "" && PasswordTF.text != "" {
            Auth.auth().signIn(withEmail: UsernameTF.text!,
                               password: PasswordTF.text!, completion: {
                                (<#User?#>, <#Error?#>) in
                                if error != nil {
                                    
                                } else {
                                    performSegue(withIdentifier: self.CONTACTS_SEGUE, sender: nil)
                                }
                                
                                })
        }
    }
    
}
