//
//  IconsTabViewController.swift
//  SnapTrack
//
//  Created by Kevin Delgado on 2/27/19.
//  Copyright © 2019 Lilybeth Delgado. All rights reserved.
//

import Foundation
import UIKit

class IconsTabViewController: UITabBarController {
    
    var tabBarIteam = UITabBarItem()
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor : UIColor.white], for: .selected)
        
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor:UIColor.darkGray], for: .normal)
        
        let selectedImage1 = UIImage(named: "profileLight1x")?.withRenderingMode(.alwaysOriginal)
        let deSelectedImage1 = UIImage(named: "profileDark1x")?.withRenderingMode(.alwaysOriginal)
        tabBarIteam = self.tabBar.items![0]
        tabBarIteam.image = deSelectedImage1
        tabBarIteam.selectedImage = selectedImage1
        
        
        let selectedImage2 = UIImage(named: "apppleLight1x")?.withRenderingMode(.alwaysOriginal)
        let deSelectedImage2 = UIImage(named: "appleDark1x")?.withRenderingMode(.alwaysOriginal)
        tabBarIteam = self.tabBar.items![1]
        tabBarIteam.image = deSelectedImage2
        tabBarIteam.selectedImage = selectedImage2
        
        let selectedImage3 = UIImage(named: "graphLight1x")?.withRenderingMode(.alwaysOriginal)
        let deSelectedImage3 = UIImage(named: "graphDark1x")?.withRenderingMode(.alwaysOriginal)
        tabBarIteam = self.tabBar.items![2]
        tabBarIteam.image = deSelectedImage3
        tabBarIteam.selectedImage = selectedImage3
        
        /*let numOfTab = CGFloat((tabBar.items?.count)!)
        let tabBarSize = CGSize(width: tabBar.frame.width / numOfTab, height: tabBar.frame.height)
        tabBar.selectionIndicatorImage = UIImage.imageWithData(color: #colorLiteral(red: 0.7882352941, green: 0.7725490196, blue: 0.7294117647, alpha: 1), size: tabBarSize)
        
        self.selectedIndex = 0 */
    }
    
    
    /*override func didRecieveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }*/
    
}
