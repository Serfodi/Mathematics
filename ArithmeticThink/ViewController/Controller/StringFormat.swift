//
//  StringFormat.swift
//  MatApp
//
//  Created by Сергей Насыбуллин on 10/09/2020.
//  Copyright © 2020 NasybullinSergei. All rights reserved.
//

import Foundation

class StringFormat {
    let decimalSeparator = "."
    
    func separatedNumber(for number: Any) -> String {
        guard let itIsANumber = number as? NSNumber else { return "Not a number" }
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.groupingSeparator = " "
        formatter.decimalSeparator = decimalSeparator
        return formatter.string(from: itIsANumber)!
    }
}




