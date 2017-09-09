//
//  AuthProvider.swift
//  ChatFunctionality
//
//  Created by Karan Singh on 8/9/17.
//  Copyright © 2017 Karan Singh. All rights reserved.
//

import Foundation
import FirebaseAuth

typealias LoginHandler = (_ msg:String?) -> Void;

struct LoginErrorCode {
    static let INVALID_EMAIL = "Invalid Email Address, Please Provide A Real Email Address";
    static let INVALID_PASSWORD = "Invalid Password, Try Again";
    
}

class AuthProvider {
    private static let _instance = AuthProvider();
    
    static var Instance: AuthProvider {
        return _instance;
    }
    
    func login(withEmail: String, password: String, loginHandler: LoginHandler?) {
        Auth.auth().signIn(withEmail: withEmail, password: password, completion: { (user, error) in
            if error != nil {
                self.handleErrors(err: error as! NSError, loginHandler: loginHandler);
            } else {
                loginHandler?(nil);
            }
            
        });
    }
    
    private func handleErrors(err: NSError, loginHandler: LoginHandler?) {
        if let errCode = AuthErrorCode(rawValue: err.code) {
            
            switch errCode {
                
            case .wrongPassword:
                loginHandler?(LoginErrorCode.INVALID_PASSWORD)
                break;
            case .invalidEmail:
                loginHandler?(LoginErrorCode.INVALID_EMAIL)
                break;

            default:
                break;
            }
        }
    }
}
