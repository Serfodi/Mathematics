//
//  Game.swift
//  MatApp
//
//  Created by Сергей Насыбуллин on 16/08/2020.
//  Copyright © 2020 NasybullinSergei. All rights reserved.
//

import Foundation

class Game {
    
    private enum Operator {
        case binaryOperator( (Double,Double) -> Double, String)
        case square( (Double) -> (Double) )
    }
    
    // MARK: - var
    
    open var result:Double = 0
    open var exemple:String = ""
    
    var random = RandomGenerator()
    var string = StringFormat()
    
    // MARK: - let
    
    private let operation: [Int:Operator] = [
        0:Operator.binaryOperator( {$0 + $1}, "+"),
        1:Operator.binaryOperator( {$0 - $1}, "-"),
        2:Operator.binaryOperator( {$0 * $1}, "×"),
        3:Operator.square( {pow($0, 2)} ),
        4:Operator.binaryOperator( {$0 / $1}, "÷")
    ]
    
    
    // MARK: - func
    
    /**
     Генирирует пример
     - parameter sign: Int  индекс знака
     - parameter numbers: [Int] максимальные числа
     */
    open func createExemple(sign:Int, numbers:[Int]) {
        guard let operationSign = operation[sign] else { return }
        switch operationSign {
        case .square(let instruction):
            exemple = squareComputation(instruction, numbers)
        case .binaryOperator(let instruction, let sign):
            computationExemple(instruction, sign, numbers)
        }
        print("\(exemple) = \(result)")
    }
    
    
    private func testResult () -> Bool {
        let array = String(result).components(separatedBy: ".")
        if array[1].count != 1 {
            return true
        }
        if result < 0 {
            return true
        }
        if result == 0 {
            return true
        }
        return false
    }
    
    
    
    private func computationExemple (_ operatorNumber:(Double,Double)->Double,_ sign:String,_ scatter:[Int]) {
        // создает прмер с + - и тд
        let numbers = random.generationRandomNumber(numbers: scatter )
        
        let firstNumber = ( Double( numbers[0] ), string.separatedNumber(for: numbers[0]) )
        let secondNumber = ( Double( numbers[1] ), string.separatedNumber(for: numbers[1]) )
        
        result = operatorNumber(firstNumber.0,secondNumber.0)
        exemple = "\(firstNumber.1) \(sign) \(secondNumber.1)"
        
        if testResult() { computationExemple(operatorNumber, sign, scatter) }
    }
    
    
    
    private func squareComputation (_ operatorNumber:(Double)->Double,_ scatter:[Int]) -> String {
        // выводит пример для кводрата
        let number = random.random(to: scatter[0] + 1)
        result = operatorNumber( Double(number) )
        return "\(string.separatedNumber(for: number))²"
    }
    
    
}



