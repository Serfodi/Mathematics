//
//  CreatingExample.swift
//
//  Created by Сергей Насыбуллин on 16/08/2020.
//  Copyright © 2020 NasybullinSergei. All rights reserved.
//

import Foundation


class CreatingExample {
    
    
    
    private enum Operator {
        case binaryOperator( (Double,Double) -> Double, String)
        case square( (Double) -> (Double) )
    }
    
    
    
    open var result : Double = 0
    open var example : String = ""
    
    var random = RandomGenerator()
    var string = StringFormat()
    
    
    
    private let operation: [Int:Operator] = [
        0:Operator.binaryOperator( {$0 + $1}, "+"),
        1:Operator.binaryOperator( {$0 - $1}, "-"),
        2:Operator.binaryOperator( {$0 * $1}, "×"),
        3:Operator.square( {pow($0, 2)} ),
        4:Operator.binaryOperator( {$0 / $1}, "÷")
    ]
    
    
    
    open func createExample(sign:Int, range:[Int]) {
        guard let operationSign = operation[sign] else { return }
        switch operationSign {
        case .square(let instruction):
            example = squareComputation(instruction, range)
        case .binaryOperator(let instruction, let sign):
            computationExample(instruction, sign, range)
        }
    }
    
    
    
    private func testResult () -> Bool {
        let array = String(result).components(separatedBy: ".")
        if array[1].count != 1 { return true }
        if result < 0 { return true }
        if result == 0 { return true }
        return false
    }
    
    
    
    private func computationExample (_ operatorNumber:(Double,Double)->Double,_ sign:String,_ numberRange:[Int]) {
        
        let numbers = random.generationRandomNumber(numberRange: numberRange)
        
        let firstNumber = ( Double( numbers[0] ), string.separatedNumber(for: numbers[0]) )
        let secondNumber = ( Double( numbers[1] ), string.separatedNumber(for: numbers[1]) )
        
        result = operatorNumber(firstNumber.0,secondNumber.0)
        example = "\(firstNumber.1) \(sign) \(secondNumber.1)"
        
        if testResult() { computationExample(operatorNumber, sign, numberRange) }
    }
    
    
    
    private func squareComputation (_ operatorNumber:(Double)->Double,_ scatter:[Int]) -> String {
        let number = random.random(to: scatter[0] + 1)
        result = operatorNumber( Double(number) )
        return "\(string.separatedNumber(for: number))²"
    }
    
    
    
    var description: String {
        return "\(example) = \(result)"
    }
 
    
}



