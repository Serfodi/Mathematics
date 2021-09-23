//
//  ModelConroller.swift
//  MatApp
//
//  Created by Сергей Насыбуллин on 15/08/2020.
//  Copyright © 2020 NasybullinSergei. All rights reserved.
//

import Foundation

class ModelConrolle {
    
    var sign = Number(Int: 0)
    var oldSign = Number(Int: 0)
    
    var numbers = NumberArray(IntArray: [10,10])
    var levelNumber = Number(Int: 0)
    
    var random = Flag(bool: false)
    var workout = Flag(bool: false)
    
    
    
    deinit {
        print("Контроллер модели уничтожен")
    }
    
}
