//
//  SceneDelegate.swift
//  MatApp
//
//  Created by Сергей Насыбуллин on 11/08/2020.
//  Copyright © 2020 NasybullinSergei. All rights reserved.
//

import UIKit

@available(iOS 13.0, *)
class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        
        let model = ModelController(sign: 0, oldSign: 0, numberRange: [1,10], levelNumber: 0, randomFlag: false, workoutFlag: false)
        
//        let defaults = UserDefaults.standard
//
//        if defaults.object(forKey: "first") == nil {
//
//            defaults.set("No", forKey: "first")
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
//
        
        if let MMVC = window?.rootViewController as? GameVC {
            MMVC.modelController = model
        }
        
        guard let _ = (scene as? UIWindowScene) else { return }
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not neccessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }


}

