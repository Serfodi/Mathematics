//
//  FirstStart.swift
//  MatApp
//
//  Created by Сергей Насыбуллин on 26/09/2020.
//  Copyright © 2020 NasybullinSergei. All rights reserved.
//

import UIKit

class FirstStart: UIViewController {

    @IBOutlet var substrates: [UIView]!
    
    @IBOutlet var buttons: [UIButton]!
    
//    @IBOutlet weak var example: UILabel!
    
//    @IBOutlet weak var answer: UILabel!
    
    
    @IBOutlet weak var butonConstaint: NSLayoutConstraint!
    
    @IBOutlet weak var topConstrant: NSLayoutConstraint!
    
    var modelControl:ModelConrolle!
    
    var delay:TimeInterval = 0
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        print("Первый запуск")
        
        setUp()
        animatonFirst()
    }
    
    
    
    func setUp () {
        
        if view.frame.height >= 736 {
            topConstrant.constant = 102
            butonConstaint.constant = 47
        }
        view.layoutIfNeeded()
        
        for button in buttons { button.alpha = 0 }
        
        for view in substrates {
            view.alpha = 0
            view.transform = CGAffineTransform.init(scaleX: 0.9, y: 0.9)
        }
        
        substrates = sorted(views: substrates)
        shadow(views: substrates)
    }

    
    func sorted (views:[UIView]) -> [UIView] {
        return views.sorted(by: {$0.tag < $1.tag})
    }
    
    
    func shadow(views:[UIView]) {
        for view in views {
            view.layer.shadowOffset = CGSize(width: 0, height: 0)
            view.layer.shadowColor = #colorLiteral(red: 0.9254901961, green: 0.9411764706, blue: 0.9529411765, alpha: 1)
            view.layer.shadowRadius = 15
            view.layer.shadowOpacity = 1
        }
    }
    
    
    
    func animatonFirst() {
        
        UIView.animate(withDuration: 0.6, delay: 0.5, options: .curveEaseOut, animations: {
            self.substrates[0].alpha = 1
            self.substrates[0].transform = CGAffineTransform(scaleX: 1, y: 1)
        }) { (true) in
            self.animatonButton()
        }
    }
    
    func animatonButton() {
        for tag in 0...7 {
            UIView.animate(withDuration: 0.3, delay: delay, options: .curveEaseOut, animations: {
                
                switch tag {
                case 0...5:
                    self.buttons[tag].alpha = 1
                case 6:
                    self.buttons[6].alpha = 1
                    self.buttons[7].alpha = 1
                case 7:
                    self.buttons[8].alpha = 1
                    self.buttons[9].alpha = 1
                    self.buttons[10].alpha = 1
                    
                    self.substrates[1].alpha = 1
                    self.substrates[1].transform = CGAffineTransform(scaleX: 1, y: 1)
                default:
                    return
                }
            }) { (true) in
                if tag == 7 { self.present() }
            }
            self.delay += 0.15
        }
    }
    
    func present() {
        print("Перемещение")
        let storybouard = UIStoryboard(name: "iPhone", bundle: nil).instantiateInitialViewController() as? GameVC
        storybouard?.modelConroller = modelControl
        if #available(iOS 13.0, *) {
            storybouard?.modalPresentationStyle = .fullScreen
        }
        self.present(storybouard!, animated: false, completion: self.removeFromParent)
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
}
