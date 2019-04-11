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
    
    
    @IBOutlet weak var profileImgEdit: UIImageView!
    
    @IBAction func uploadButtonpicEdit(_ sender: Any) {
    }
    
    
    @IBAction func chooseProfileImg(_ sender: Any) {
    }
    
    }
    
    

