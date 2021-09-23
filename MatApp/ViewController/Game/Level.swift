//
//  Level.swift
//  MatApp
//
//  Created by Сергей Насыбуллин on 20/09/2020.
//  Copyright © 2020 NasybullinSergei. All rights reserved.
//

import Foundation

class Level {
    
    let level: [[Int]] = [
        [10,10],
        [20,10],
        [50,20],
        [50,25],
        [100,25],
        [250,50],
        [500,100],
        [500,500],
        [1000,500],
        [1000,1000],
        [5000,1000],
        [10000,10000],
        [100000,100000]
    ]
    
    func levelUpDate(level:Int,speed:Double) -> ([Int],Int) {
        var levelNumber = level
        switch speed {
        case 0...4.8: // после 50
            guard levelNumber != 0 else { break }
            levelNumber -= 1
            print("Уровень понижен: \(levelNumber)")
        case 8...60: // после 30
            guard levelNumber != self.level.count - 1 else { break }
            levelNumber += 1
            print("Уровень повышен: \(levelNumber)")
        default:
            break
        }
        return (self.level[levelNumber], levelNumber)
    }
    
}
