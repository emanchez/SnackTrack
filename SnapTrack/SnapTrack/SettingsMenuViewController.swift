//
//  SettingsMenuViewController.swift
//  SnapTrack
//
//  Created by Kevin Delgado on 3/30/19.
//  Copyright © 2019 Lilybeth Delgado. All rights reserved.
//

import Foundation
import UIKit

enum MenuType:Int{
    case editProfile
    case extraFeature
    case logout
    
    
}
class SettingsMenuViewController: UITableViewController{
    var didTapMenuType:((MenuType) -> Void)?
    
    override func viewDidLoad() {
        
        super.viewDidLoad()

    }
    
    // minute 3:50 youtube video
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let menuType = MenuType(rawValue:indexPath.row) else { return }
        dismiss(animated: true){[weak self] in
            print ("Dismissing: \(menuType)")
            self?.didTapMenuType?(menuType)
        }
    }
    
    @IBAction func logoutButtonTapped(_ sender: UIButton) {
        print(String(format: "Logging out of %@'s account", mainUser.fname))
        mainUser = UserInfo()
        
    }
    
   
    
    
}
