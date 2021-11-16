//
//  ParameterLayout.swift
//  ArithmeticThink
//
//  Created by Сергей Насыбуллин on 13.11.2021.
//  Copyright © 2021 NasybullinSergei. All rights reserved.
//

import Foundation

class ParameterLayout {
    
    private let scaleLayout = [0.85, 1, 1.1]
    
    open func layout(for width: Int) -> Double {
        
        switch width {
        case 0...320 :
            return scaleLayout[0]
        case 321...375 :
            return scaleLayout[1]
        case 376... :
           return scaleLayout[2]
        default:
            print("Нет такого размеры - \(width)")
            return 0
        }
    }
    
}
