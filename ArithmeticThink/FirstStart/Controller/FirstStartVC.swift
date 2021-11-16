//
//  FirstStart.swift
//  MatApp
//
//  Created by Сергей Насыбуллин on 26/09/2020.
//  Copyright © 2020 NasybullinSergei. All rights reserved.
//

/*

import UIKit

class FirstStart: UIViewController {

    @IBOutlet weak var menuButton: UIButton!
    
    @IBOutlet weak var levelRiseIndicatorImageView: UIImageView!
    
    @IBOutlet weak var outputExampleLabel: UILabel!
    @IBOutlet weak var inputNumberLabel: UILabel!
    
    @IBOutlet weak var outputView : UIView!
    @IBOutlet weak var inputNumberView : UIView!
    
    
    @IBOutlet weak var statusVerticalStackView: UIStackView!
    
    @IBOutlet weak var inputButtonStackView: UIStackView!
    @IBOutlet var inputButtonHorizontalStackView: [UIStackView]!
    
    
    @IBOutlet var numberButton: [UIButton]!
    
    
    @IBOutlet var inputButtonStackViewConstraints: [NSLayoutConstraint]!
    
    
    let layoutSizeFount = [30, 36, 40]
    let spacingForButtonStack = [13, 15, 20]
    
    let roundingRadiusForView = [36, 40, 48]
    let spacingForStatusStack = [150, 209, 209]
    
    
    
    
    var delay:TimeInterval = 0
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
        animatonFirst()
    }
    
    
    
    func setUp () {
        
        
        
//        if view.frame.height >= 736 {
//            topConstrant.constant = 102
//            butonConstaint.constant = 47
//        }
//        view.layoutIfNeeded()
        
        for button in buttons { button.alpha = 0 }
        
        for view in substrates {
            view.alpha = 0
            view.transform = CGAffineTransform.init(scaleX: 0.9, y: 0.9)
        }
        

        shadow(views: substrates)
    }

    
//    func sorted (views:[UIView]) -> [UIView] {
//        return views.sorted(by: {$0.tag < $1.tag})
//    }
    
    
    
    
    
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
        let storybouard = UIStoryboard(name: "iPhone", bundle: nil).instantiateInitialViewController() as? GameVC
        storybouard?.modelController = modelControl
        if #available(iOS 13.0, *) {
            storybouard?.modalPresentationStyle = .fullScreen
        }
        self.present(storybouard!, animated: false, completion: self.removeFromParent)
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
}
*/
