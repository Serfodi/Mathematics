//
//  GameViewController.swift
//
//  Created by Сергей Насыбуллин on 16/08/2020.
//  Copyright © 2020 NasybullinSergei. All rights reserved.
//

import UIKit
import AudioToolbox



class GameVC: UIViewController {
    
    
    
    
    
    
    // MARK: - @IBOutlet
    
    
    // Main View
    @IBOutlet weak var outputView : UIView!
    @IBOutlet weak var inputNumberView : UIView!
    
    // Menu button
    @IBOutlet weak var menuButton: UIButton!
    // level indicator
    @IBOutlet weak var levelRiseIndicatorImageView: UIImageView!
    
    // Label example and input. Inside "outputView"
    @IBOutlet weak var outputExampleLabel: UILabel!
    @IBOutlet weak var inputNumberLabel: UILabel!
    
    // Button number. Inside "inputNumberView"
    @IBOutlet var numberButton: [UIButton]!
    
    // Stack for outputView and inputNumberView
    @IBOutlet weak var mainVerticalStackView: UIStackView!
    
    // Horizontal stack for menu and level indicator
    @IBOutlet weak var statusVerticalStackView: UIStackView!
    
    // Vertical stack for input Button Horizontal Stack
    @IBOutlet weak var inputButtonStackView: UIStackView!
    // stack for button input
    @IBOutlet var inputButtonHorizontalStackView: [UIStackView]!
    
    
    
    
    // MARK:  layout
    
    // For "statusVerticalStackView"
    @IBOutlet weak var leadingStatusStackConstraint: NSLayoutConstraint!
    @IBOutlet weak var topStatusStackConstraint: NSLayoutConstraint!
    
    // For "mainVerticalStackView"
    @IBOutlet weak var widthMainVerticalStackViewConstraint: NSLayoutConstraint!
    
    // for "inputButtonStackView": top, leading, button, trailing
    @IBOutlet weak var bottomStackButtonConstraint: NSLayoutConstraint!
    @IBOutlet weak var leadingStackButtonConstraint: NSLayoutConstraint!
    @IBOutlet weak var trailingStackButtonConstraint: NSLayoutConstraint!
    @IBOutlet weak var topStackButtonConstraint: NSLayoutConstraint!
    
    
    
    
    // MARK:  UI
    
    // bluerView
    let bluerView:UIVisualEffectView = {
        var view = UIVisualEffectView()
        return view
    }()
    
    
    
    
    
    
    // MARK: - General
    
    
    
    var modelController : ModelController!
    
    
    //  input
    /*
     Input number. Used together with "inputAttribute". It stores the representation of the number in Double and String
     */
    var input : String {
        set {
            inputAttribute.1 = newValue
            inputAttribute.0 = Double(inputAttribute.1) ?? 0
            
            if inputAttribute.1.range(of: stringFormat.decimalSeparator) == nil {
                inputNumberLabel.text = stringFormat.separatedNumber(for: inputAttribute.0)
            } else {
                inputNumberLabel.text = inputAttribute.1
            }
        }
        get { return inputAttribute.1 }
    }
    //  "input"
    var inputAttribute : (Double,String) = (0,"")
    
    
    let creatingExample = CreatingExample()
    let level = Level()
    
    
    let stringFormat = StringFormat()
    let parameterLayout = ParameterLayout()
    
    
    var countCorrectAnswers : Int = 0
    var countExample : Int = 0
    
    
    let levelRiseIndicatorImageName = ["arrowLevelUp", "arrowLevelDown", "equally"]
    
    
    override var description: String {
        return ("""
                
                \(creatingExample.description)
                \(level.description)
                countCorrectAnswers: \(countCorrectAnswers)
                countExample: \(countExample) / \(level.upIndex)
                random: \(modelController.randomFlag)
                workout: \(modelController.workoutFlag)
                numberRange: \(modelController.numberRange)
                sign: \(modelController.sign)
                oldSign: \(modelController.oldSign)
                
                """)
    }
    
    let countOperation = 5
    
    // layout
    
    let layoutSizeFount = 36
    let spacingForButtonStack = 15
    let roundingRadiusForView = 40
    let spacingForStatusStack = 209
    let viewCornerRadius: Double = 40
    
    
    
    // MARK: Design
    
    let colorAnimateAnswer = [#colorLiteral(red: 0.721568644, green: 0.8862745166, blue: 0.5921568871, alpha: 1),#colorLiteral(red: 0.9568627477, green: 0.6588235497, blue: 0.5450980663, alpha: 1),#colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)]
        
    
    
    
    
    
    // MARK: - ViewDidLoad
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
        layout(for: view.bounds.width)
        startGame()
        
    }
    
    
    
    // MARK: - Action
    
    
    
    // Input number
    @IBAction func numberInput(_ sender: UIButton) {
        if sender.tag == 10 {
            guard input.range(of: stringFormat.decimalSeparator) == nil && input != "" else { return }
            input += stringFormat.decimalSeparator
        } else {
            input += String(sender.tag)
        }
        // validates the entered answer
        result()
    }
    
    
    // Clear action button
    @IBAction func deleteNumber(_ sender: UIButton) {
        if inputAttribute.1.count != 0 {
            inputAttribute.1.removeLast()
            input = inputAttribute.1
        }
    }
    
    
    
    
    // MARK:  Unwind Segue
    
    
    @IBAction func closeUnwindSegue(unwindSegue: UIStoryboardSegue) {
        
        animateBlur(state: .closed)
        
        switch unwindSegue.identifier {
        case "closeSetting":
            guard let SettingGameVC = unwindSegue.source as? SettingGameVC  else { return }
            modelController = SettingGameVC.modelController
        default:
            break
        }
        
        levelReset()
        startGame()
    }
    
    
    
    
    
    
    // MARK: - Prepare segue
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        animateBlur(state: .open)
        
        if segue.identifier == "settingSegue" {
            if let SVC = segue.destination as? SettingGameVC {
                SVC.modelController = modelController
            }
        }
        
    }
    
    
    
    
    
    
    // MARK: - Start game
    
    
    
    func startGame() {
        if competitive() || modelController.randomFlag {
            random()
        }
        createExample()
        print(description)
    }
    
    
    func createExample() {
        countExample += 1
        clearLabel()
        creatingExample.createExample(sign: modelController.sign, range: modelController.numberRange)
        outputExampleLabel.text = creatingExample.example
    }
    
    func competitive() -> Bool {
        return modelController.randomFlag || modelController.workoutFlag
    }
    
    func random() {
        let randomGenerator = RandomGenerator()
        let randomLevel = randomGenerator.random(to: level.range.count - 1)
        modelController.sign = randomGenerator.random(to: countOperation)
        modelController.numberRange = level.range[randomLevel]
    }
    
    func clearLabel() {
        input = ""
        inputNumberLabel.text = " "
    }
    
    
    
    
    
    
    // MARK: - Ansver
    
    
    
    func result() {
        // checks the number of characters
        guard testCount(inputAttribute.1, creatingExample.result) else { return }
        
        let answer = inputAttribute.0 == creatingExample.result
        
        if !competitive() {
            if answer {
                countCorrectAnswers += 1
            }
            if countExample % level.upIndex == 0 {
                levelChange()
                countCorrectAnswers = 0
            }
        }
        
        animatorAnswer(answer: answer, completion: startGame)
    }
    
    
    /**
     Checks the number of characters input
     */
    func testCount(_ inputNumber:String,_ resultNumber:Double) -> Bool {
        let resultArray = String(resultNumber).components(separatedBy: stringFormat.decimalSeparator)
        if resultArray[1] == "0" {
            if inputNumber.count == resultArray[0].count {
            }
            return inputNumber.count == resultArray[0].count
        }
        return inputNumber.count == String(resultNumber).count
    }
    
    
    
    
    
    
    // MARK: - Level change
    
    /**
     Changes the level
     */
    func levelChange() {
        let oldLevel = level.level
        level.levelChanges(countAnswer: countCorrectAnswers)
        let difference = level.level - oldLevel
        modelController.numberRange = level.levelRange()
        showArrow(difference: difference)
    }
    
    func levelReset() {
        if modelController.sign != modelController.oldSign {
            countExample = 0
            countCorrectAnswers = 0
            level.level = 0
            if !competitive() {
                modelController.numberRange = level.levelRange()
            }
        }
    }
    
    
    
    
    
    
    // MARK: - setUpView
    
    
    
    func setUpView() {
        addShadowView([outputView, inputNumberView])
        setUpBluerEffectView()
        bluerView.alpha = 0
        levelRiseIndicatorImageView.alpha = 0
    }
    
    func setUpBluerEffectView() {
        bluerView.frame = self.view.frame
        let bluerEffect = UIBlurEffect(style: .light)
        view.addSubview(bluerView)
        bluerView.effect = bluerEffect
    }
    
    func addShadowView(_ viewArray:[UIView]) {
        for view in viewArray {
            view.layer.shadowOffset = CGSize(width: 0, height: 0)
            view.layer.shadowColor = #colorLiteral(red: 0.9254901961, green: 0.9411764706, blue: 0.9529411765, alpha: 1)
            view.layer.shadowRadius = 15
            view.layer.shadowOpacity = 1
        }
    }
    
    
    
    
    
    

    // MARK: - Layout

    
    
    func layout(for width: CGFloat) {
        let layout =  parameterLayout.layout(for: Int(width))
        
        // status Stack
        topStatusStackConstraint.constant *= CGFloat(layout)
        leadingStatusStackConstraint.constant *= CGFloat(layout)
        statusVerticalStackView.spacing *= CGFloat(layout)
        
        // main Stack
        widthMainVerticalStackViewConstraint.constant *= CGFloat(layout)
        mainVerticalStackView.spacing *= CGFloat(layout)
        
        // input button Stack
        inputButtonStackView.spacing *= CGFloat(layout)
        for stack in inputButtonHorizontalStackView {
            stack.spacing *= CGFloat(layout)
        }
        
        bottomStackButtonConstraint.constant *= CGFloat(layout)
        leadingStackButtonConstraint.constant *= CGFloat(layout)
        trailingStackButtonConstraint.constant *= CGFloat(layout)
        topStackButtonConstraint.constant *= CGFloat(layout)
        
        // view
        outputView.layer.cornerRadius = CGFloat(viewCornerRadius * layout)
        inputNumberView.layer.cornerRadius = CGFloat(viewCornerRadius * layout)
        
        view.layoutIfNeeded()
    }
    
    
    
    
    
    
    // MARK: - Animation

    
    
    func animatorAnswer (answer:Bool, completion: @escaping () -> () ) {
        // create animator
        UIView.animate(withDuration: 0.5, animations: {
            // animator color
            switch answer {
            case true:
                self.outputView.backgroundColor = self.colorAnimateAnswer[0]
            case false:
                self.animatorSnake(label: self.inputNumberLabel)
                self.outputView.backgroundColor = self.colorAnimateAnswer[1]
            }
        } ) { (end) in
            completion()
            self.animatorColor(color: self.colorAnimateAnswer[2])
        }
    }
    
    func animatorSnake(label : UILabel) {
        let snake = CABasicAnimation(keyPath: "position")
        snake.duration = 0.1
        snake.repeatCount = 2
        snake.autoreverses = true
        
        let fromPoint = CGPoint(x: label.frame.midX + 5, y: label.frame.midY)
        let fromValue = NSValue(cgPoint: fromPoint)
        
        let toPoint = CGPoint(x:  label.frame.midX - 5, y: label.frame.midY)
        let toValue = NSValue(cgPoint: toPoint)
        
        snake.fromValue = fromValue
        snake.toValue = toValue
        
        label.layer.add(snake, forKey: nil)
    }
    
    
    func animatorColor(color:UIColor) {
        UIView.animate(withDuration: 0.5) {
            self.outputView.backgroundColor = color
        }
    }
    
    
    // animation Arrow
    
    func showArrow(difference:Int) {
        levelRiseIndicatorImageView.alpha = 1
        switch difference {
        case -1:
            levelRiseIndicatorImageView.image  = UIImage(named: levelRiseIndicatorImageName[1])
            animateArrow(view: levelRiseIndicatorImageView)
        case 1:
            levelRiseIndicatorImageView.image  = UIImage(named: levelRiseIndicatorImageName[0])
            animateArrow(view: levelRiseIndicatorImageView)
        case 0:
            levelRiseIndicatorImageView.image  = UIImage(named: levelRiseIndicatorImageName[2])
            animateEqually(view: levelRiseIndicatorImageView)
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
    
    func animateEqually(view:UIImageView) {
        UIView.animate(withDuration: 1, animations: {
            view.alpha = 0.99
        }) { (true) in
            view.alpha = 0
        }
    }
    
    
    // Animate Blur
    
    func animateBlur(state:State) {
        UIView.animate(withDuration: 0.4) {
            switch state {
            case .open: self.bluerView.alpha = 0.9
            case .closed: self.bluerView.alpha = 0
            }
        }
    }
    
    
    
    // MARK: - UIFeedbackGenerator
    
    
    func haptic () {
        let generator = UIImpactFeedbackGenerator(style:.light)
        generator.impactOccurred()
    }
    
    
    
    
}

