//
//  ViewController.swift
//  SnapTrack
//
//  Created by Kevin Delgado on 2/26/19.
//  Copyright © 2019 Lilybeth Delgado. All rights reserved.
//

import UIKit

var mainUser = UserInfo()

func sendRequest(url: String, route: String, params: [String]) -> [String : Any] {
    // URL=ServerUrl ; route = serverside function to execute (i.e. login, signup) ; params=http post/get data to send (format ["name1=value", "name2=value", ... ])
    print(url)
    print(route)
    print(params.joined(separator: "&"))
    let base_url = URL(string: String(format: "%@/%@", url, route))
    var literallyAnything : [String : Any]
    literallyAnything = ["message" : "wait"]
    var request = URLRequest(url: base_url!)
    let bodyString = params.joined(separator: "&")
    let bodyData = bodyString.data(using: String.Encoding.utf8)
    
    
    request.httpBody = bodyData
    
    print(NSString(data: request.httpBody!, encoding: String.Encoding.utf8.rawValue)!)
    
    request.httpMethod = "POST"
    
    request.setValue("application/x-www-form-urlencoded; charset=utf-8", forHTTPHeaderField: "Content-Type")
    request.addValue("application/json", forHTTPHeaderField: "Content-Type")
    request.addValue("application/json", forHTTPHeaderField: "Accept")
    let task = URLSession.shared.dataTask(with: request) { data, response, error in guard let data = data,
        let response = response as? HTTPURLResponse,
        (200 ..< 300) ~= response.statusCode,
        error == nil else {
            print ("unable to connect")
            return
        }
        
        let responseObject = ((try? JSONSerialization.jsonObject(with: data, options: [])) as? [String: Any])!
        literallyAnything = responseObject
        
    }
    task.resume()
    while (literallyAnything["message"] as! String == "wait") {}//wait for response
    return literallyAnything
}




class ViewController: UIViewController {

    @IBOutlet weak var userNameTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    var currentUserFirstName:String!
    
    // pulled from my ass i mean stack overflow

    
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
        // Do any additional setup after loading the view, typically from a nib.
        //let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        
        //view.addGestureRecognizer(tap)
    }
    
    // trying to dissmiss bitchass keyboard
        func textFieldShouldReturn(textField: UITextField) {
            
            //userNameTextField.resignFirstResponder()
            //passwordTextField.resignFirstResponder()
            textField.resignFirstResponder()
            
    }
    
        @IBAction func loginTapped(_ sender: Any) {
            
            let user_ = userNameTextField.text
            let pass_ = passwordTextField.text
            
            // need to dismiss keyboard

            
            let hashValue = strHash(str: String(format: "%@%@", user_!, pass_!))
            print(hashValue)
            /*
            let base_url = URL(string: String (format:"http://%@/login", server1))
            
            //base_url?.queryItems = [
              //  URLQueryItem(name: "user", value: user_),
              //  URLQueryItem(name: "pass", value: String(format: "'%@'", String(hashValue)))
            //]
            
            var request = URLRequest(url: base_url!)
            let bodyString = String(format: "user=%@&pass=%@", user_!, String(hashValue))
            let bodyData = bodyString.data(using: String.Encoding.utf8)
            
            
            request.httpBody = bodyData
            
            print(NSString(data: request.httpBody!, encoding: String.Encoding.utf8.rawValue)!)
            
            request.httpMethod = "POST"
            
            request.setValue("application/x-www-form-urlencoded; charset=utf-8", forHTTPHeaderField: "Content-Type")
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.addValue("application/json", forHTTPHeaderField: "Accept")
            let task = URLSession.shared.dataTask(with: request) { data, response, error in guard let data = data,
                let response = response as? HTTPURLResponse,
                (200 ..< 300) ~= response.statusCode,
                error == nil else {
                    print (base_url?.description as Any)
                    return
                }
                let responseObject = (try? JSONSerialization.jsonObject(with: data, options: .mutableContainers)) as? [String: Any]
                // let responseMessage = String(format: "%@", responseObject?["response"] as! CVarArg)
                let responseMessage = String(format: "%@", responseObject?["message"] as! CVarArg)
                
                
                if (responseMessage == "failed"){
                    print(String(format: "%@\n", responseMessage))
                    
                    /*let alertLogin = UIAlertController(title: "ERROR: Wrong Username Or Password", message: "Please Try Again", preferredStyle: .alert)
                    
                    alertLogin.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
                    
                    self.present(alertLogin, animated: true)*/
                    return
                }
 
                mainUser.email = String(format: "%@", responseObject?["email"] as! CVarArg)
                mainUser.fname = String(format: "%@", responseObject?["fname"] as! CVarArg)
                mainUser.lname = String(format: "%@", responseObject?["lname"] as! CVarArg)
                mainUser.dateOfBirth = String(format: "%@", responseObject?["dob"] as! CVarArg)
                mainUser.weight = String(format: "%@", responseObject?["weight"] as! CVarArg)
                mainUser.height = String(format: "%@", responseObject?["height"] as! CVarArg)
                
                print(String(format: "name:%@ %@\n", mainUser.fname, mainUser.lname))
                print(String(format: "date of birth: %@\n", mainUser.dateOfBirth))
                
                
                //let IconsTabViewController = self.storyboard?.instantiateViewController(withIdentifier: "iconsTab") as! IconsTabViewController
                //self.navigationController?.pushViewController(IconsTabViewController, animated: true)
                //self.performSegue(withIdentifier: "segueFromLogin", sender: nil)
                OperationQueue.main.addOperation {
                    [weak self] in
                    self?.performSegue(withIdentifier: "segueFromLogin", sender: self)
                }
                //print(responseMessage)
                
                //self.currentUserFirstName = responseMessage
            }
            task.resume()
            */
            let responseObject = sendRequest(url: server1, route: "login",
                                             params: [
                                                String(format: "user=%@", user_!),
                                                String(format: "pass=%@", String(hashValue))
                                             ]
            )
            let responseMessage = responseObject["message"] as! String
            if (responseMessage == "failed") {
                print("Incorrect query")
                return
            }
            if (responseMessage == "fatalerror"){
                print("lolidunno")
                return
            }
            mainUser.email = String(format: "%@", responseObject["email"] as! CVarArg)
            mainUser.fname = String(format: "%@", responseObject["fname"] as! CVarArg)
            mainUser.lname = String(format: "%@", responseObject["lname"] as! CVarArg)
            mainUser.dateOfBirth = String(format: "%@", responseObject["dob"] as! CVarArg)
            mainUser.weight = String(format: "%@", responseObject["weight"] as! CVarArg)
            mainUser.height = String(format: "%@", responseObject["height"] as! CVarArg)
            
            OperationQueue.main.addOperation {
                [weak self] in
                self?.performSegue(withIdentifier: "segueFromLogin", sender: self)
            }
        }
     
}

