//
//  Level.swift
//  MatApp
//
//  Created by Сергей Насыбуллин on 20/09/2020.
//  Copyright © 2020 NasybullinSergei. All rights reserved.
//

import Foundation



class Level {
    
    var level: Int = 0
    
    /*
     by the number of correct answers, a decision is made to increase, decrease or not change the level. level up: "upIndex" == 6 (correct answers)
     */
    let upIndex = 6
    let equal = 4
    let downIndex = 2
    
    // level
    // numbers range [min, max]
    let range: [[Int]] = [
        [1,10],
        [10,15],
        [10,20],
        [20,30],
        [20,40],
        [30,50],
        [50,100],
        [100,500],
        [250,1000],
        [500,1000],
        [1000,5000]
    ]
    
    
    func levelChanges(countAnswer: Int) {
        switch countAnswer {
        
        case 0...downIndex:
            
            guard level > 0 else { break }
            level -= 1
            print("Lowering the level \(level)")
            
        case downIndex...equal: //(downIndex+1)...equal
            
            print("without changes \(level)")
            
        case equal...upIndex: // (equal+1)...upIndex
            
            guard level < range.count - 1 else { break }
            level += 1
            print("Level up \(level)")
            
        default:
            print("Error level")
            break
        }
    }
    
    
    func levelRange() -> [Int] {
        guard level > 0 else { return range[0] }
        guard level < range.count else { return range[0] }
        return range[level]
    }
    
    
    var description : String {
        return "level: \(level)"
    }
    
}
