//
//  AppDelegate.swift
//  MatApp
//
//  Created by Сергей Насыбуллин on 11/08/2020.
//  Copyright © 2020 NasybullinSergei. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        let model = ModelController(sign: 0, oldSign: 0, numberRange: [1,10], levelNumber: 0, randomFlag: false, workoutFlag: false)
        
//        let defaults = UserDefaults.standard
//
//        if defaults.object(forKey: "second") == nil {
//
//            defaults.set("No", forKey: "second")
//            defaults.synchronize()
//
//            let storyboard = UIStoryboard(name: "FirstStart", bundle: nil).instantiateInitialViewController() as? FirstStart
//
//            storyboard?.modelControl = model
//
//            window?.rootViewController = storyboard
//            window?.makeKeyAndVisible()
//
//        } else {
//        }
        
        if let GVC = window?.rootViewController as? GameVC {
            GVC.modelController = model
        }
        
        return true
    }

    
    // MARK: UISceneSession Lifecycle
    @available(iOS 13.0, *)
    
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    
    @available(iOS 13.0, *)
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

