//
//  ViewController.swift
//  MatApp
//
//  Created by Сергей Насыбуллин on 11/08/2020.
//  Copyright © 2020 NasybullinSergei. All rights reserved.
//

import UIKit

class MainMenuViewController: UIViewController {

    // MARK: - Varialeble
    
    
    var modelConroller:ModelConrolle!
    
    
    // MARK: - Navigation

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        switch segue.identifier {
        case "setting":
            if let SVC = segue.destination as? SettingViewController {
                SVC.modelController = modelConroller
            }
        case "play":
            if let GVC = segue.destination as? GameViewController {
                GVC.modelConroller = modelConroller
            }
        default:
            break
        }
    }
    
    
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
}

