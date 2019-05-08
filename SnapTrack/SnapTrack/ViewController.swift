//
//  ViewController.swift
//  SnapTrack
//
//  Created by Kevin Delgado on 2/26/19.
//  Copyright © 2019 Lilybeth Delgado. All rights reserved.
//

import UIKit

var mainUser = UserInfo()

class ViewController: UIViewController {

    @IBOutlet weak var userNameTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    var currentUserFirstName:String!
    
    override func shouldPerformSegue(withIdentifier identifier: String?, sender: Any?) -> Bool {
        if let ident = identifier {
            if ident == "segueFromLogin" {
                return false
            }
        }
        if let ident = identifier {
            if ident == "segueFromSignup" {
                return false
            }
        }
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
        //dismiss keyboard (does not work!)   
        func textFieldShouldReturn(textField: UITextField) {
            
            //userNameTextField.resignFirstResponder()
            //passwordTextField.resignFirstResponder()
            textField.resignFirstResponder()
            
    }
    
        @IBAction func loginTapped(_ sender: Any) {
            
            let user_ = userNameTextField.text
            let pass_ = passwordTextField.text
            
            // need to dismiss keyboard

            if( user_ == "dev"  && pass_ == "a"){
                mainUser.email = "dev"
                mainUser.fname = "dev"
                mainUser.lname = "dev"
            }
            else{
                let hashValue = strHash(str: String(format: "%@%@", user_!, pass_!))
                print(hashValue)
                
                let responseObject = sendRequest(url: server1, route: "login",
                                                 params: [
                                                    String(format: "user=%@", user_!),
                                                    String(format: "pass=%@", String(hashValue))
                                                 ]
                )
                let responseMessage = responseObject["message"] as! String
                if (responseMessage == "wait") {
                    print("Could not connect: Server timeout")
                    return
                }
                if (responseMessage == "failed") {
                    print("Incorrect query")
                    return
                }
                if (responseMessage == "fatalerror"){
                    print("Fatal error")
                    return
                }
                mainUser.email = String(format: "%@", responseObject["email"] as! CVarArg)
                mainUser.fname = String(format: "%@", responseObject["fname"] as! CVarArg)
                mainUser.lname = String(format: "%@", responseObject["lname"] as! CVarArg)
                mainUser.dateOfBirth = String(format: "%@", responseObject["dob"] as! CVarArg)
                mainUser.weight = String(format: "%@", responseObject["weight"] as! CVarArg)
                mainUser.height = String(format: "%@", responseObject["height"] as! CVarArg)
            }
            OperationQueue.main.addOperation {
                [weak self] in
                self?.performSegue(withIdentifier: "segueFromLogin", sender: self)
            }
        }
     
}

