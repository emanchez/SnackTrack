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
    
    // giving the user the option to no pick a picture
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        
        picker.dismiss(animated: true, completion: nil)
    }

    
    }
    
    

