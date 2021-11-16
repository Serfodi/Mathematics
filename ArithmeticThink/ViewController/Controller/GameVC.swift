//
//  GameViewController.swift
//
//  Created by Сергей Насыбуллин on 16/08/2020.
//  Copyright © 2020 NasybullinSergei. All rights reserved.
//

import UIKit
import AudioToolbox



class GameVC: UIViewController {
    
    // MARK: - Outlet
    
    // main View
    @IBOutlet weak var outputView : UIView!
    @IBOutlet weak var inputNumberView : UIView!
    
    // menu button
    @IBOutlet weak var menuButton: UIButton!
    // level indicator
    @IBOutlet weak var levelRiseIndicatorImageView: UIImageView!
    
    // label
    @IBOutlet weak var outputExampleLabel: UILabel!
    @IBOutlet weak var inputNumberLabel: UILabel!
    
    // button number / input
    @IBOutlet var numberButton: [UIButton]!
    
    // stack for outputView and inputNumberView
    @IBOutlet weak var mainVerticalStackView: UIStackView!
    
    // stack for menu and level indicator
    @IBOutlet weak var statusVerticalStackView: UIStackView!
    
    // Vertical stack for input Button Horizontal Stack
    @IBOutlet weak var inputButtonStackView: UIStackView!
    // stack for button input
    @IBOutlet var inputButtonHorizontalStackView: [UIStackView]!
    
    
    // layout
    
    // for status Vertical Stack View
    @IBOutlet weak var leadingStatusStackConstraint: NSLayoutConstraint!
    @IBOutlet weak var topStatusStackConstraint: NSLayoutConstraint!
//    @IBOutlet weak var widthStatusStackConstraint: NSLayoutConstraint!
    
    
    // for mainVerticalStackView
//    @IBOutlet weak var topMainVerticalStackViewConstraint: NSLayoutConstraint!
    @IBOutlet weak var widthMainVerticalStackViewConstraint: NSLayoutConstraint!
    
    // for inputButtonStackView: top, leading, button
    @IBOutlet weak var bottomStackButtonConstraint: NSLayoutConstraint!
    @IBOutlet weak var leadingStackButtonConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var trailingStackButtonConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var topStackButtonConstraint: NSLayoutConstraint!
    
    
    // MARK: - Properties
    
    // bluerView
    let bluerView:UIVisualEffectView = {
        var view = UIVisualEffectView()
        return view
    }()
    
    
    
    //  input
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
    //  свойства "input"
    var inputAttribute : (Double,String) = (0,"")
    
    
    
    
    // general
    var modelController : ModelController!
    
    let game = Game()
    let level = Level()
    let stringFormat = StringFormat()
    
    
    // timer
    var timerPlay = Timer()
    var time = 0
    // count anser
    var countExample = 0
    
    
    //
    let parameterLayout = ParameterLayout()
    
    let layoutSizeFount = 36
    let spacingForButtonStack = 15
    let roundingRadiusForView = 40
    let spacingForStatusStack = 209
    
    let levelRiseIndicatorText = ["arrowLevelUp","arrowLevelDown","equally"]
    
    let colorAnimateAnswer = [#colorLiteral(red: 0.721568644, green: 0.8862745166, blue: 0.5921568871, alpha: 1),#colorLiteral(red: 0.9568627477, green: 0.6588235497, blue: 0.5450980663, alpha: 1),#colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)]
        
    
    
    // MARK: - View did load
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        creatureGame()
        startTimer()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        creatureView()
        layout(for: view.bounds.width)
    }
    
    
    override func viewWillLayoutSubviews() {

    }
    
    
    
    
    // MARK: - IBAction
    
    
    
    // Ввод числа
    @IBAction func numberInput(_ sender: UIButton) {
        if sender.tag == 10 {
            guard input.range(of: stringFormat.decimalSeparator) == nil && input != "" else { return }
            input += stringFormat.decimalSeparator
        } else {
            input += String(sender.tag)
        }
        result(answer: inputAttribute.0)
    }
    
    
    
    // Стирание
    @IBAction func deleteNumber(_ sender: UIButton) {
        if inputAttribute.1.count != 0 {
            inputAttribute.1.removeLast()
            input = inputAttribute.1
        }
    }
    
    
    
    
    // MARK:  Segue set
    
    
    @IBAction func closeUnwindSegue(unwindSegue: UIStoryboardSegue) {
        
        animateBlur(state: .closed)
        
        if unwindSegue.identifier == "closeSetting" {
            guard let SettingGameVC = unwindSegue.source as? SettingGameVC  else { return }
            modelController = SettingGameVC.modelController
        }
        
        // не запускать таймер
        if competitive() {
            stopTimer()
        } else {
            reStartCountAndTimer()
            modelController.numberRange = level.levels[modelController.levelNumber]
        }
        
        if modelController.oldSign != modelController.sign {
            modelController.levelNumber =  0
        }
        
        creatureGame()
        
    }
    
    
    
    
    // MARK: - Prepare segue
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        animateBlur(state: .open)
        
        //  Передача в Setting
        if segue.identifier == "settingSegue" {
            if let SVC = segue.destination as? SettingGameVC {
                SVC.modelController = modelController
            }
        }
        
    }
    
    
    
    
    // MARK: - Create game
    
    
    func creatureGame() {
        
        let randomGenerator = RandomGenerator()
        
        clearLabel()
        if modelController.randomFlag {
            //  случайный знак
            modelController.sign = randomGenerator.random(to: 5)
            
            // случайный уровень
            if !modelController.workoutFlag {
                modelController.numberRange = level.levels[randomGenerator.random(to: level.levels.count - 1)]
            }
        }
        
        game.createExample(sign: modelController.sign, numbers: modelController.numberRange)
        outputExampleLabel.text = game.example
    }
    
    
    func competitive() -> Bool {
        return modelController.randomFlag || modelController.workoutFlag
    }
    
    
    
    
    // MARK: - Ansver
    
    
    
    // Вызывает изменения примера и анимацию ответа
    func result(answer:Double) {
        
        guard testCount(inputAttribute.1, game.result) else { return }
        
        levelСhange(test: inputAttribute.0 == game.result)
        animatorAnswer(answer: inputAttribute.0 == game.result)
        
        /**
         проверяет количество введенных символов и сверяет их с символами в результате
         */
        func testCount(_ inputNumber:String,_ resultNumber:Double) -> Bool {
            // заменить на Double
            let resultArray = String(resultNumber).components(separatedBy: stringFormat.decimalSeparator)
            if resultArray[1] == "0" {
                return inputNumber.count == resultArray[0].count
            }
            return inputNumber.count == String(resultNumber).count
        }
        
    }
    
    
    
    
    
    // MARK: - Изменения уровня
    
    
    func levelСhange (test:Bool) {
        
        guard test else { return }
        countExample += 1
        guard !competitive() else { return }
        guard countExample == 4 else { return }
        
        let (numberRange,newLevel) = level.levelUpDate(level: modelController.levelNumber , speed: speed())
        showArrow(oldLevel: modelController.levelNumber, newLevel: newLevel)
        modelController.numberRange = numberRange
        modelController.levelNumber = newLevel
        reStartCountAndTimer()
    }
    
    
    func speed() -> Double {
        return Double(countExample) / Double(time) * 60
    }
    
    
    
    
    // MARK: - сброс
    
    
    func reStartCountAndTimer() {
        reStartTimer()
        countExample = 0
    }
    
    func clearLabel() {
        input = ""
        inputNumberLabel.text = " "
    }
    
    
    
    
    
    // MARK: - Timer
    
    
    func reStartTimer() {
        stopTimer()
        startTimer()
    }
    
    
    func startTimer() {
        timerPlay = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(timerUpdate), userInfo: NSDate(), repeats: true)
    }
    
    
    func stopTimer () {
        timerPlay.invalidate()
    }
    
    
    @objc func timerUpdate() {
        let elapsed = -(self.timerPlay.userInfo as! NSDate).timeIntervalSinceNow
        time = Int(elapsed)
    }
    
    
    

    
    
    // MARK: - setUpView
    
    
    func creatureView() {
        creatureShadowForView([outputView, inputNumberView])
        creatureEffectView()
        bluerView.alpha = 0
        levelRiseIndicatorImageView.alpha = 0
    }
    
    
    func creatureEffectView() {
        bluerView.frame = self.view.frame
        let bluerEffect = UIBlurEffect(style: .light)
        view.addSubview(bluerView)
        bluerView.effect = bluerEffect
    }
    
    
    func creatureShadowForView(_ viewArray:[UIView]) {
        for window in viewArray {
            window.layer.shadowOffset = CGSize(width: 0, height: 0)
            window.layer.shadowColor = #colorLiteral(red: 0.9254901961, green: 0.9411764706, blue: 0.9529411765, alpha: 1)
            window.layer.shadowRadius = 15
            window.layer.shadowOpacity = 1
        }
    }
    
   
    
    
    // MARK: - Layout

    
    
    func layout(for width: CGFloat) {
        let layout =  parameterLayout.layout(for: Int(width))
        
        // status Stack
//        widthStatusStackConstraint.constant *= CGFloat(layout)
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
        outputView.layer.cornerRadius = 40 * CGFloat(layout)
        inputNumberView.layer.cornerRadius = 40 * CGFloat(layout)
        
        view.layoutIfNeeded()
    }
    
    
    
    
    
    // MARK: - Animation

    
    
    // Aнимация ответа
    func animatorAnswer (answer:Bool) {
        UIView.animate(withDuration: 0.5, animations: {
            switch answer {
            case true:
                self.outputView.backgroundColor = self.colorAnimateAnswer[0]
            case false:
                self.animatorStakeAnswer()
                self.outputView.backgroundColor = self.colorAnimateAnswer[1]
            }
        } ) { (true) in
            switch answer {
            case true:
                self.creatureGame()
            case false:
                self.clearLabel()
            }
            self.animatorColor(color: self.colorAnimateAnswer[2])
        }
    }
    
    func animatorStakeAnswer() {
        let snake = CABasicAnimation(keyPath: "position")
        snake.duration = 0.1
        snake.repeatCount = 2
        snake.autoreverses = true
        
        let fromPoint = CGPoint(x: inputNumberLabel.frame.midX + 5, y: inputNumberLabel.frame.midY)
        let fromValue = NSValue(cgPoint: fromPoint)
        
        let toPoint = CGPoint(x:  inputNumberLabel.frame.midX - 5, y: inputNumberLabel.frame.midY)
        let toValue = NSValue(cgPoint: toPoint)
        
        snake.fromValue = fromValue
        snake.toValue = toValue
        
        inputNumberLabel.layer.add(snake, forKey: nil)
    }
    
    
    func animatorColor(color:UIColor) {
        UIView.animate(withDuration: 0.5) {
            self.outputView.backgroundColor = color
        }
    }
    
    // animation Arrow
    
    func showArrow(oldLevel:Int, newLevel:Int) {
        let difference = newLevel - oldLevel
        levelRiseIndicatorImageView.alpha = 1
        switch difference {
        case -1:
            levelRiseIndicatorImageView.image  = UIImage(named: levelRiseIndicatorText[1])
            animateArrow(view: levelRiseIndicatorImageView)
        case 1:
            levelRiseIndicatorImageView.image  = UIImage(named: levelRiseIndicatorText[0])
            animateArrow(view: levelRiseIndicatorImageView)
        case 0:
            levelRiseIndicatorImageView.image  = UIImage(named: levelRiseIndicatorText[2])
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
    
    
    
    // MARK: - StatusBar
    
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    
    
}

