//
//  Workout.swift
//  MatApp
//
//  Created by Сергей Насыбуллин on 10/10/2020.
//  Copyright © 2020 NasybullinSergei. All rights reserved.
//

import Foundation
import UIKit


class CreatureView {
    
    func creatureView () -> [UIView] {
        var arrayView:[UIView] = []
        for i in 0...1 {
            let view = UIView(frame: CGRect(x: 25, y: 74 + 105 * i, width: 80, height: 80))
            view.layer.cornerRadius = view.bounds.height / 2
            view.backgroundColor = #colorLiteral(red: 0.8531618118, green: 0.8806666732, blue: 0.9216126204, alpha: 1)
            view.tag = i
            
            let label = UILabel(frame: CGRect(x: 30, y: 16, width: 21, height: 49))
            label.font = UIFont(name: "OpenSans-Bold", size: 34)
            label.textColor = #colorLiteral(red: 0.6382058263, green: 0.6905008554, blue: 0.7645244002, alpha: 1)
            label.text = "\(i + 1)"
            view.addSubview(label)
            
            arrayView.append(view)
//            buttonWorkout.addSubview(view)
            
//            view.transform = CGAffineTransform.init(scaleX: 0.3, y: 0.3)
//            view.alpha = 0
        }
        
        return arrayView
    }
    
    /*
    func creatureButton() -> [UIButton] {
        let arrayButton:[UIButton] = []
        let numberString = arrayConvert(modelController.numbers.IntArray)
        for i in 0...1 {
            
            let button = UIButton(frame: CGRect(x: 25, y: 74 + 105 * i, width: 80, height: 80))
//            button.addTarget(self, action: #selector(buttonNumber(_:)), for: .touchUpInside)
            
            button.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            button.layer.cornerRadius = button.bounds.height / 2
            button.layer.borderWidth = 4
            button.layer.borderColor = #colorLiteral(red: 0.8531618118, green: 0.8806666732, blue: 0.9216126204, alpha: 1)
            
            
            button.titleLabel?.font = UIFont.init(name: "OpenSans-Bold", size: 34)
            button.setTitle(numberString[i], for: .normal)
            button.setTitleColor(#colorLiteral(red: 0.8531618118, green: 0.8806666732, blue: 0.9216126204, alpha: 1), for: .normal)
            button.titleLabel?.textAlignment = .center
            
            button.tag = i
            
            arrayButton.append(button)
//            buttonWorkout.addSubview(button)
            
//            button.transform = CGAffineTransform.init(scaleX: 1, y: 1)
//            button.alpha = 0
        }
        
        return arrayButton
    }
    */
    
    
    
    
    
}
