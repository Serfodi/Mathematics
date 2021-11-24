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
        
        let model = ModelController(sign: 0, oldSign: 0, numberRange: [1,10], randomFlag: false, workoutFlag: false)
                
        if let MMVC = window?.rootViewController as? GameVC {
            MMVC.modelController = model
        }
        
        guard let _ = (scene as? UIWindowScene) else { return }
    }

    func sceneDidDisconnect(_ scene: UIScene) {
 
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
 
    }

    func sceneWillResignActive(_ scene: UIScene) {

    }

    func sceneWillEnterForeground(_ scene: UIScene) {

    }

    func sceneDidEnterBackground(_ scene: UIScene) {

    }


}

