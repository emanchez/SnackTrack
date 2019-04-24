//
//  EditProfileViewController.swift
//  SnapTrack
//
//  Created by Kevin Delgado on 4/10/19.
//  Copyright © 2019 Lilybeth Delgado. All rights reserved.
//

import Foundation
import UIKit

class EditProfileViewController:UIViewController,UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    override func viewDidLoad() {
        profileImgEdit.layer.borderWidth = 1
        profileImgEdit.layer.masksToBounds = false
        profileImgEdit.layer.borderColor = UIColor.black.cgColor
        profileImgEdit.layer.cornerRadius = profileImgEdit.frame.height/2
        profileImgEdit.clipsToBounds = true
        profileImgEdit.contentMode = .scaleAspectFill
        
        super.viewDidLoad()
    }
    
    // variable where the picture is held
    @IBOutlet weak var profileImgEdit: UIImageView!
    
    @IBOutlet weak var chooseImgButton: UIButton!
    
    @IBOutlet weak var uploadButton: UIButton!
    
    
    
    // choosing image from the user
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        let image = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        profileImgEdit.image = image
        if (profileImgEdit.image == nil){
            
            uploadButton.isHidden = true
            
        }
        else{
            
            uploadButton.isHidden = false
        }
        
        picker.dismiss(animated: true, completion: nil)
    }
    
    
    
    
    @IBAction func uploadButtonpicEdit(_ sender: Any) {
        let outImage : UIImage = profileImgEdit.image!
        
        let imageData = outImage.jpegData(compressionQuality: 1.0)
        let route_ = "post/profile_picture"
        
        //var responsejson : [String : Any?]
        //responsejson = sendRequest(url: server1, route: route_, params: params_)
        var status = "wait"
        let base_url = URL(string: String(format: "%@/%@", server1, route_))
        
        var request = URLRequest(url: base_url!)
        var bodyData = Data()
        
        let boundary = UUID().uuidString
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        let userValue = mainUser.email
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        bodyData.append("\r\n--\(boundary)\r\n".data(using: .utf8)!)
        bodyData.append("Content-Disposition: form-data; name=\"user\"\r\n\r\n".data(using: .utf8)!)
        bodyData.append("\(userValue)".data(using: .utf8)!)
        
        bodyData.append("\r\n--\(boundary)\r\n".data(using: .utf8)!)
        bodyData.append("Content-Disposition: form-data; name=\"image\"; filename=\"image.jpg\"\r\n".data(using: .utf8)!)
        bodyData.append("Content-Type: image/png\r\n\r\n".data(using: .utf8)!)
        bodyData.append(imageData!)
        
        bodyData.append("\r\n--\(boundary)--\r\n".data(using: .utf8)!)
        request.httpMethod = "POST"
        session.uploadTask(with: request, from: bodyData, completionHandler: { responseData, response, error in
            
            if(error != nil){
                status = "404"
                print("\(error!.localizedDescription)")
            }

            guard let responseData = responseData else {
                status = "failed"
                print("no response data")
                return
            }
            
            let responseObject = ((try? JSONSerialization.jsonObject(with: responseData, options: [])) as? [String: Any])!
            if(responseObject["message"] as! String == "ok"){
                status = "ok"
                print("uploaded successfully")
            }
            else if (responseObject["message"] as! String == "failed"){
                status = "failed"
                print(responseObject["details"] as! String)
            }
        }).resume()

        
        
        request.httpBody = bodyData
        
        
        //print(NSString(data: request.httpBody!, encoding: String.Encoding.utf8.rawValue)!)
        
        request.httpMethod = "POST"
        
        
        /*
        let task = URLSession.shared.dataTask(with: request) { data, response, error in guard let data = data,
            let response = response as? HTTPURLResponse,
            (200 ..< 300) ~= response.statusCode,
            error == nil else {
                status = "404"
                return
            }
            if let responsejson = (try? JSONSerialization.jsonObject(with: data, options: [])) as? [String : Any]{
                if (responsejson["message"] as! String == "ok"){
                    status = "ok"
                    return
                }
                else{
                    status = "failed"
                    return
                }
            }
            else {
                status = "failed"
                return
            }
        }
        task.resume()
        */
        
        let _timeout = Date().timeIntervalSince1970 + 5
        while (status == "wait") {
            if (Date().timeIntervalSince1970 > _timeout){
                break
            }
        }//wait for response
        mainUser.profilePic = outImage
        NotificationCenter.default.post(name:Notification.Name(rawValue: "refresh"),object:nil)
    }
    
    
    @IBAction func chooseProfileImg(_ sender: Any) {
        //setting our variable for option
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        
        // setting up the actionSheet
        let actionSheet = UIAlertController(title: "Picture Source", message: "Choose", preferredStyle: . actionSheet)
        //Giving the user Camera Option
        actionSheet.addAction(UIAlertAction(title: "Camera", style: .default, handler: { (action:UIAlertAction) in
            
            if UIImagePickerController.isSourceTypeAvailable(.camera){
                
                imagePickerController.sourceType = .camera
                self.present(imagePickerController, animated: true, completion: nil)
            }
            else{
                print("Camera not Available")
            }
            
        }))
        //Giving the user the Option to use Photos from library
        actionSheet.addAction(UIAlertAction(title: "Photo Library", style: .default, handler: { (action:UIAlertAction) in
            imagePickerController.sourceType = .photoLibrary
            self.present(imagePickerController, animated: true, completion: nil)
        }))
        //Giving the user the option to not do either
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        self.present(actionSheet,animated: true, completion: nil)
        
        
    }
    
    // giving the user the option to not pick a picture
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        
        picker.dismiss(animated: true, completion: nil)
    }

    
    }
    
    

