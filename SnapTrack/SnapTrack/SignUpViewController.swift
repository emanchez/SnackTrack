//
//  SignUpViewController.swift
//  SnapTrack
//
//  Created by Kevin Delgado on 4/8/19.
//  Copyright © 2019 Lilybeth Delgado. All rights reserved.
//

import Foundation
import UIKit

var signUpConfirmation = false

class SignUpViewController: UIViewController{
    
    
    
    @IBOutlet weak var fnameText: UITextField!
    
    @IBOutlet weak var lnameText: UITextField!
    
    @IBOutlet weak var dobText: UITextField!
    
    @IBOutlet weak var emailText: UITextField!
    
    @IBOutlet weak var passwordText: UITextField!
    
    @IBOutlet weak var confirmPassText: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    override func shouldPerformSegue(withIdentifier identifier: String?, sender: Any?) -> Bool {
        if let ident = identifier {
            if ident == "segueFromSignup" {
                return false
            }
        }
        if let ident = identifier {
            if ident == "segueFromLogin" {
                return false
            }
        }
        return true
    }
    
    @IBAction func signUpButton(_ sender: Any) {
        // sending information to the server
        
        if ( fnameText.text == ""){
            let alert = UIAlertController(title: "ERROR: Empty Field", message: "Please Enter First Name", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "Sure", style: .cancel, handler: nil))
            
            self.present(alert, animated: true)
            return
        }
        if ( lnameText.text == ""){
            let alert = UIAlertController(title: "ERROR: Empty Field", message: "Please Enter Last Name", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "Sure", style: .cancel, handler: nil))
            
            self.present(alert, animated: true)
            return
        }
        
        if ( dobText.text == ""){
            let alert = UIAlertController(title: "ERROR: Empty Field", message: "Please Enter DOB Name", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "Sure", style: .cancel, handler: nil))
            
            self.present(alert, animated: true)
            return
        }
        
        if ( emailText.text == ""){
            let alert = UIAlertController(title: "ERROR: Empty Field", message: "Please Enter email Name", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "Sure", style: .cancel, handler: nil))
            
            self.present(alert, animated: true)
            return
        }
        if ( passwordText.text == ""){
            let alert = UIAlertController(title: "ERROR: Empty Field", message: "Please Enter DOB Name", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "Sure", style: .cancel, handler: nil))
            
            self.present(alert, animated: true)
            return
        }
        
        if (confirmPassText.text != passwordText.text)
        {
            let alert = UIAlertController(title: "Passwords Do Not Match", message: "REDO Password Entry", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "Sure", style: .cancel, handler: nil))
            
            self.present(alert, animated: true)
            
            print("Hey it should work")
            
            return
        }
        else {
            let hashValue = strHash(str: String(format: "%@%@", emailText.text!, confirmPassText.text!))
            var base_url = URLComponents(string: String (format:"http://%@/signup?", server1))
            
            base_url?.queryItems = [
                URLQueryItem(name: "table", value: "user_profile"),
                //URLQueryItem(name: "values", value: String(format: "%@,%@,%@,%@,0001-01-01",emailText.text!,String(hashValue),fnameText.text!,lnameText.text!))
                
                 URLQueryItem(name: "email", value: emailText.text!),
                 URLQueryItem(name: "pass", value: String(hashValue)),
                 URLQueryItem(name: "fname", value: fnameText.text!),
                 URLQueryItem(name: "lname", value: lnameText.text!),
                 URLQueryItem(name: "dob", value: "0001-01-01"),
                
            ]
            
            let request = URLRequest(url: (base_url?.url)!)
            
            
            let task = URLSession.shared.dataTask(with: request) { data, response, error in guard let data = data,
                let response = response as? HTTPURLResponse,
                (200 ..< 300) ~= response.statusCode,
                error == nil else {
                    print (base_url?.url as Any)
                    print("failed to connect")
                    return
                }
                let responseObject = (try? JSONSerialization.jsonObject(with: data)) as? [String: Any]
                // let responseMessage = String(format: "%@", responseObject?["response"] as! CVarArg)
                let responseMessage = String(format: "%@", responseObject?["response"] as! CVarArg)
                print(String(format: "%@\n", responseMessage))
                if (responseMessage == "NOT OK"){
                    print("query failed")
                    return
                }
                
                
                
                
                //let IconsTabViewController = self.storyboard?.instantiateViewController(withIdentifier: "iconsTab") as! IconsTabViewController
                //self.navigationController?.pushViewController(IconsTabViewController, animated: true)
                //self.performSegue(withIdentifier: "segueFromLogin", sender: nil)

                //print(responseMessage)
                
                //self.currentUserFirstName = responseMessage
            }
            task.resume()
            
            //let vc = ViewController()
            //self.present(vc, animated: true, completion: nil)
            
            //let alert = UIAlertController(title: "Success!", message: "Please Login", preferredStyle: .alert)
            
            //alert.addAction(UIAlertAction(title: "Sure", style: .cancel, handler: nil))
            
            //self.present(alert, animated: true)
            
            print("Signup Successful")
            
            signUpConfirmation = true
            OperationQueue.main.addOperation {
              [weak self] in
                self?.performSegue(withIdentifier: "segueFromSignup", sender: self)
            }
        }
        
    }
    
    
    
    
    
}
