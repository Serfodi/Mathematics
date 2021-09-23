//
//  RandomGenerator.swift
//  MatApp
//
//  Created by Сергей Насыбуллин on 19/09/2020.
//  Copyright © 2020 NasybullinSergei. All rights reserved.
//

import Foundation


class RandomGenerator {
    
    fileprivate var oldNumbers:[Int] = []
    
    func random(to number:Int) -> Int {
        return Int(arc4random_uniform(UInt32(number)))
    }
    
    func generationRandomNumber(numbers:[Int]) -> [Int] {
        var arrayNumbers:[Int] = []
        
        for number in numbers {
            arrayNumbers.append( randomInt(number / 10, number) )
        }
        
        // не допускать повторов
        if oldNumbers == arrayNumbers { arrayNumbers = generationRandomNumber(numbers: numbers) }
        oldNumbers = arrayNumbers
        
        return arrayNumbers
    }
    
    fileprivate func randomInt(_ min: Int,_ max: Int) -> Int {
        guard max - min - 1 > 0 else { return 0 }
        return min + random(to: max - min - 1)
    }
    
}

