//
//  AnimateView.swift
//  MatApp
//
//  Created by Сергей Насыбуллин on 09/10/2020.
//  Copyright © 2020 NasybullinSergei. All rights reserved.
//

import Foundation
import UIKit

class AnimateView {
    
    
    
    
    
    func showArrow(oldLevel:Int, newLevel:Int, arrayImage:[UIImageView]) {
        let difference = newLevel - oldLevel
        switch difference {
        case -1:
            arrowFalse.alpha = 1
            animateArrow(view: arrowFalse)
        case 1:
            arrowTrue.alpha = 1
            animateArrow(view: arrowTrue)
        case 0:
            animateEqually()
            
        default:
            break
        }
    }
    
    
    func animationArrowSnake(view:UIImageView) {
        
        let snake = CABasicAnimation(keyPath: "position")
        snake.duration = 0.3
        snake.repeatCount = 2
        snake.autoreverses = true
        
        let fromPoint = CGPoint(x: view.frame.midX, y: view.frame.midY + 7)
        let fromValue = NSValue(cgPoint: fromPoint)
        
        let toPoint = CGPoint(x:  view.frame.midX, y: view.frame.midY - 7)
        let toValue = NSValue(cgPoint: toPoint)
        
        snake.fromValue = fromValue
        snake.toValue = toValue
        
        view.layer.add(snake, forKey: nil)
    }
    
    
    func animateArrow(view:UIImageView) {
        UIView.animate(withDuration: 1, animations: {
            
            self.animationArrowSnake(view: view)
            view.alpha = 0.99
            
        }) { (true) in
            view.alpha = 0
        }
        
    }
    
    
    func animateEqually() {
        let animation = CABasicAnimation(keyPath: "opacity")
        animation.fromValue = 0
        animation.toValue = 1
        animation.duration = 0.5
        animation.autoreverses = true
        
        equally.layer.add(animation, forKey: nil)
    }
    
    
    
}

