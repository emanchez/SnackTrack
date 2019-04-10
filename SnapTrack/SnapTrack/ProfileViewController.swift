//
//  ProfileViewController.swift
//  SnapTrack
//
//  Created by Kevin Delgado on 2/26/19.
//  Copyright © 2019 Lilybeth Delgado. All rights reserved.
//

import Foundation
import UIKit

class ProfileViewController: UIViewController{
    
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
        welcomeLabel.text = String(format: "Hi %@ , you look great!",mainUser.fname)
        print ( String(format: "%@ name", mainUser.fname))
    }
    

    @IBAction func didTapMenu(_ sender: UIBarButtonItem) {
        guard let settingsMenuViewController = storyboard?.instantiateViewController(withIdentifier: "SettingsMenuViewController") else {return}
        
        present(settingsMenuViewController,animated: true)
        
    }
    

    
    
}
