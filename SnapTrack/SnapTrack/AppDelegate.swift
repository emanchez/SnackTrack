//
//  AppDelegate.swift
//  SnapTrack
//
//  Created by Kevin Delgado on 2/26/19.
//  Copyright © 2019 Lilybeth Delgado. All rights reserved.
//

import UIKit


class UserInfo {
    var email: String = ""
    var fname: String = ""
    var lname: String = ""
    var dateOfBirth: String = ""
    var weight: String = ""
    var height: String = ""
    var profilePic: UIImage = UIImage()
}

var server1 = String("http://67.80.162.105:5000")

func strHash(str: String) -> UInt64 {
    var res = UInt64 (5382)
    let buffer_ = [UInt8](str.utf8)
    for buff in buffer_ {
        res = 127 * (result & 0x00ffffffffffffff) + UInt64(buff)
    }
    return res
}
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
    let _timeout = Date().timeIntervalSince1970 + 5
    while (literallyAnything["message"] as! String == "wait") {
        if (Date().timeIntervalSince1970 > _timeout){
            break
        }
    }//wait for response
    return literallyAnything
}
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

    
    

}

