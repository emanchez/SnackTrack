//
//  ProfileViewController.swift
//  SnapTrack
//
//  Created by Kevin Delgado on 2/26/19.
//  Copyright © 2019 Lilybeth Delgado. All rights reserved.
//

import Foundation
import UIKit



class ProfileViewController: UIViewController {
    
    @IBOutlet weak var welcomeLabel: UILabel!
    
    @IBOutlet weak var profilePicture: UIImageView!
    override func viewDidLoad() {
        
        super.viewDidLoad()
       // making the profile Picture ICON A CIRCLE
        profilePicture.layer.borderWidth = 1
        profilePicture.layer.masksToBounds = false
        profilePicture.layer.borderColor = UIColor.black.cgColor
        profilePicture.layer.cornerRadius = profilePicture.frame.height/2
        profilePicture.clipsToBounds = true
        profilePicture.contentMode = .scaleAspectFill
        welcomeLabel.text = String(format: "Hi %@ , you look great!",mainUser.fname)
        print ( String(format: "%@ name", mainUser.fname))
        profilePicture.image = getProfilePicture()
        NotificationCenter.default.addObserver(self, selector: #selector(refresh(_:)), name: Notification.Name(rawValue: "refresh"), object: nil)
    }
    
    @IBAction func touchMebutton(_ sender: Any) {
        let img : UIImage = getProfilePicture()
        profilePicture.image = img
    }
    
    
    func getProfilePicture() -> UIImage{
        
        if(mainUser.email == "dev"){
            return UIImage()
        }
        
        let route_ = "fetch/profile_picture"
        
        //var responsejson : [String : Any?]
        //responsejson = sendRequest(url: server1, route: route_, params: params_)
        var status = "wait"
        let base_url = URL(string: String(format: "%@/%@", server1, route_))
        var outImage : UIImage?
        var request = URLRequest(url: base_url!)
        let bodyString = String(format: "user=%@", mainUser.email)
        let bodyData = bodyString.data(using: String.Encoding.utf8)
        
        
        request.httpBody = bodyData
        
        //print(NSString(data: request.httpBody!, encoding: String.Encoding.utf8.rawValue)!)
        
        request.httpMethod = "POST"
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in guard let data = data,
            let response = response as? HTTPURLResponse,
            (200 ..< 300) ~= response.statusCode,
            error == nil else {
                status = "404"
                return
            }
            outImage = UIImage(data: data)
            if outImage == nil{
                status = "failed"
            }
            else {
                status = "ok"
            }
        }
        task.resume()
        
        
        let _timeout = Date().timeIntervalSince1970 + 5
        while (status == "wait") {
            if (Date().timeIntervalSince1970 > _timeout){
                break
            }
        }//wait for response
        
        if (status == "ok"){
            print("The data transfer is working")
            
            return outImage!
            
           /* else {
                print("Fatal error")
                return UIImage()
            }*/
            
            
        }
        else if (status == "failed"){
            print("Failed to cast to image")
            return UIImage()
        }
        else if (status == "404"){
            print ("unable to connect")
            return UIImage()
        }
        else if (status == "wait"){
            print("Connection timed out")
            return UIImage()
        }
        else{
            print("Unknown error")
            return UIImage()
        }
        
    }
    
    @objc func refresh(_ notification:Notification){
        
        profilePicture.image = mainUser.profilePic
    }
    @IBAction func didTapMenu(_ sender: UIBarButtonItem) {
        guard let settingsMenuViewController = storyboard?.instantiateViewController(withIdentifier: "SettingsMenuViewController") else {return}
        
        present(settingsMenuViewController,animated: true)
        
    }
    

    
    
}

