//
//  CameraViewController.swift
//  SnapTrack
//
//  Created by Kevin Delgado on 2/26/19.
//  Copyright © 2019 Lilybeth Delgado. All rights reserved.
//

import Foundation
import UIKit

// import CoreML
//import Vision also allows us to work better with COREML

class CameraViewController:UIViewController,UIImagePickerControllerDelegate, UINavigationControllerDelegate ,
UITabBarControllerDelegate{
    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var responseLabel: UILabel!
    
    @IBOutlet weak var Upload: UIButton!
    
    @IBAction func chooseImage(_ sender: Any) {
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
    
    // picking the image from the user
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        let image = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        imageView.image = image
        if (imageView.image == nil){
            
            Upload.isHidden = true
            
        }
        else{
            
            Upload.isHidden = false
        }
        
        picker.dismiss(animated: true, completion: nil)
    }
    // creating the upload function
    
    
    @IBAction func UploadImage(_ sender: Any) {
        let input_ = String("hello")
        var base_url = URLComponents(string: String (format:"http://%@/test?", server1))
        
        base_url?.queryItems = [
            URLQueryItem(name: "input", value: input_)
        ]
        
        let request = URLRequest(url: (base_url?.url)!)
        
        self.responseLabel.text = "Loading..."
        let task = URLSession.shared.dataTask(with: request) { data, response, error in guard let data = data,
                let response = response as? HTTPURLResponse,
                (200 ..< 300) ~= response.statusCode,
                error == nil else {
                    print (base_url?.url as Any)
                    self.responseLabel.text = "Error"
                    return
            }
            let responseObject = (try? JSONSerialization.jsonObject(with: data)) as? [String: Any]
            self.responseLabel.text = String(format: "Success: %@", responseObject?["response"] as! CVarArg)
        }
        task.resume()
            
            
            
    }
    
    
    
    
    
    // giving the user the option to not pick a photos
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
       
        picker.dismiss(animated: true, completion: nil)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
  

    
}

