//
//  Level.swift
//  MatApp
//
//  Created by Сергей Насыбуллин on 20/09/2020.
//  Copyright © 2020 NasybullinSergei. All rights reserved.
//

import Foundation

class Level {
    
    // numbers range [min, max]
    let levels: [[Int]] = [
        [1,10],
        [10,20],
        [10,50],
        [20,50],
    ]
    
    func levelUpDate(level:Int,speed:Double) -> ([Int],Int) {
        var levelNumber = level
        switch speed {
        case 0...4.8: // после 50
            guard levelNumber != 0 else { break }
            levelNumber -= 1
            print("Уровень понижен: \(levelNumber)")
        case 8...60: // после 30
            guard levelNumber != self.levels.count - 1 else { break }
            levelNumber += 1
            print("Уровень повышен: \(levelNumber)")
        default:
            break
        }
        return (self.levels[levelNumber], levelNumber)
    }
    
}
