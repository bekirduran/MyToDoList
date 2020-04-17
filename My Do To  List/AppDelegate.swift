//
//  AppDelegate.swift
//  My Do To  List
//
//  Created by Bekir Duran on 27.03.2020.
//  Copyright © 2020 info. All rights reserved.
//

import UIKit
import RealmSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {



    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // viewDidLoad'dan hemen önce çalışır
      //  print("\(NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true ).last!)")
     //   print(Realm.Configuration.defaultConfiguration.fileURL!)
        
        do{
         _ = try Realm()
        }catch{
            print("Error when realm!!!!\(error.localizedDescription)")
        }
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
    
    }




}

