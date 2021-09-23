//
//  GameViewController.swift
//  MatApp
//
//  Created by Сергей Насыбуллин on 16/08/2020.
//  Copyright © 2020 NasybullinSergei. All rights reserved.
//

import UIKit
import AudioToolbox

class GameVC: UIViewController {
    
    // выводит примера
    @IBOutlet weak var exempleLabel: UILabel!
    // ввод числа
    @IBOutlet weak var inputLabel: UILabel!
    
    // MARK: UIView
    @IBOutlet var viewArray: [UIView]!
    
    // Блюр
    var blureView:UIVisualEffectView = {
        var view = UIVisualEffectView()
        return view
    }()
    
    @IBOutlet weak var levelViewImage: UIImageView!
    let nameImage = ["arrowLevelUp","arrowLevelDown","equally"]
    
    @IBOutlet weak var layoutTopInputView: NSLayoutConstraint!
    @IBOutlet weak var layoutBottomNumberView: NSLayoutConstraint!
    
    // MARK: - Var
    
    // общии
    var modelConroller:ModelConrolle!
    var game = Game()
    var level = Level()
    
    //  обработка ввода
    
    var input: String {
        set {
            inputString = newValue
            inputNumber = Double(inputString) ?? 0
            if inputString.range(of: string.decimalSeparator) == nil {
                inputLabel.text = string.separatedNumber(for: inputNumber)
            } else {
                inputLabel.text = inputString
            }
        }
        get { return inputString }
    }
    
    //  свойства "input"
    var inputNumber:Double = 0
    var inputString:String = ""
    
    // timer
    var timerPlay = Timer()
    var time = 0
    
    // счётчикик решёных примеров
    var countExemple = 0
    
    // вспомагательные
    var random = RandomGenerator()
    var string = StringFormat()
    
    
    // MARK: - view
    
    override func viewDidLoad() {
        super.viewDidLoad()
        sortedNumber()
        creatureGame()
        startTimer()
    }
    
    override func viewWillAppear(_ animated: Bool) {
//        inputLabel.text = ""
        blureView.alpha = 0
        setUpView()
    }
    
    override func viewWillLayoutSubviews() {
        if view.frame.height >= 736 {
            layoutTopInputView.constant = 102
            layoutBottomNumberView.constant = 47
        }
        view.layoutIfNeeded()
        blureView.frame = self.view.frame
    }
    
    func sortedNumber() {
        // порядковый номер должен совподать с тэгом
        viewArray = viewArray.sorted(by: {$0.tag < $1.tag})
    }
    
    // MARK: - setUpView
    
    func setUpView () {
        shadow()
        creatureEffectView()
        levelViewImage.alpha = 0
    }
    
    func creatureEffectView () {
        blureView.frame = self.view.frame
        let bluerEffect = UIBlurEffect(style: .light)
        view.addSubview(blureView)
        blureView.effect = bluerEffect
    }
    
    func shadow() {
        for window in viewArray {
            window.layer.shadowOffset = CGSize(width: 0, height: 0)
            window.layer.shadowColor = #colorLiteral(red: 0.9254901961, green: 0.9411764706, blue: 0.9529411765, alpha: 1)
            window.layer.shadowRadius = 15
            window.layer.shadowOpacity = 1
        }
    }
    
    // MARK: - create Game
    
    func creatureGame() {
        clearLabel()
        if modelConroller.random.bool {
            //  случайный знак
            modelConroller.sign = Number(Int: random.random(to: 5))
            // случайный уровень
            if !modelConroller.workout.bool {
                let newRandomNumbers = level.level[random.random(to: level.level.count - 1)]
                modelConroller.numbers = NumberArray(IntArray: newRandomNumbers)
            }
        }
        game.createExemple(sign: modelConroller.sign.Int, numbers: modelConroller.numbers.IntArray)
        exempleLabel.text = game.exemple
    }
    
    func competitive() -> Bool {
        return modelConroller.random.bool || modelConroller.workout.bool
    }
    
    
    // MARK: - IBAction
    
    // Ввод числа
    @IBAction func numberInput(_ sender: UIButton) {
        if sender.tag == 10 {
            guard input.range(of: string.decimalSeparator) == nil && input != "" else { return }
            input += string.decimalSeparator
        } else {
            input += String(sender.tag)
        }
        result(ansver: inputNumber)
    }
    
    // Стирание
    @IBAction func deleteNumber(_ sender: UIButton) {
        if inputString.count != 0 {
            inputString.removeLast()
            input = inputString
        }
    }
    
    // MARK: - Ответ
    
    // Вызывает изменения примера и анимацию ответа
    func result(ansver:Double) {
        guard testCount(inputString, game.result) else { return }
        levelСhange(test: inputNumber == game.result)
        animatorAnsver(ansver: inputNumber == game.result)
    }
    
    
    // проверяет количесвто введенных символов и сверяет их с симвалами в резултате
    func testCount(_ inputNumber:String,_ resultNumber:Double) -> Bool {
        // заменить на Double
        let resultArray = String(resultNumber).components(separatedBy: string.decimalSeparator)
        if resultArray[1] == "0" {
            return inputNumber.count == resultArray[0].count
        }
        return inputNumber.count == String(resultNumber).count
    }
    
    
    // MARK: - Изменения уровня
    
    func levelСhange(test:Bool) {
        guard test else { return }
        countExemple += 1
        guard !competitive() else { return }
        guard countExemple == 4 else { return }
        
        let (numbers,newLevel) = level.levelUpDate(level: modelConroller.levelNumber.Int , speed: speed())
        showArrow(oldLevel: modelConroller.levelNumber.Int, newLevel: newLevel)
        modelConroller.numbers = NumberArray(IntArray: numbers)
        modelConroller.levelNumber = Number(Int: newLevel)
        reStartCountAndTimer()
    }
    
    func speed() -> Double {
        return Double(countExemple) / Double(time) * 60
    }
    
    
    // MARK: - сброс
    
    func reStartCountAndTimer() {
        reStartTimer()
        countExemple = 0
    }
    
    func clearLabel() {
        input = ""
        inputLabel.text = ""
    }
    
    // MARK: - Timer
    
    func reStartTimer() {
//        print("Перезапуск таймера")
        stopTimer()
        startTimer()
    }
    
    func startTimer() {
//        print("Запуск таймера")
        timerPlay = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(timerUpdate), userInfo: NSDate(), repeats: true)
    }
    
    func stopTimer () {
//        print("Остановка таймера")
        timerPlay.invalidate()
    }
    
    @objc func timerUpdate() {
        let elepsed = -(self.timerPlay.userInfo as! NSDate).timeIntervalSinceNow
        time = Int(elepsed)
    }
    
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        animateBlure(state: .open)
        switch segue.identifier {
        case "Setting":
            if let SVC = segue.destination as? SettingGameVC {
                SVC.modelController = modelConroller
                SVC.delegate = self
            }
        default: break
        }
    }
    
    
    // MARK: - Animation

    // Aнимация ответа
    func animatorAnsver(ansver:Bool) {
        UIView.animate(withDuration: 0.5, animations: {
            switch ansver {
            case true:
                self.viewArray[1].backgroundColor = #colorLiteral(red: 0.721568644, green: 0.8862745166, blue: 0.5921568871, alpha: 1)
            case false:
                self.animatorStakeAnsver()
                self.viewArray[1].backgroundColor = #colorLiteral(red: 0.9568627477, green: 0.6588235497, blue: 0.5450980663, alpha: 1)
            }
        } ) { (true) in
            switch ansver {
            case true:
                self.creatureGame()
            case false:
                self.clearLabel()
            }
            self.animatorColor(color: #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0))
        }
    }
    
    func animatorStakeAnsver() {
        let snake = CABasicAnimation(keyPath: "position")
        snake.duration = 0.1
        snake.repeatCount = 2
        snake.autoreverses = true
        
        let fromPoint = CGPoint(x: inputLabel.frame.midX + 5, y: inputLabel.frame.midY)
        let fromValue = NSValue(cgPoint: fromPoint)
        
        let toPoint = CGPoint(x:  inputLabel.frame.midX - 5, y: inputLabel.frame.midY)
        let toValue = NSValue(cgPoint: toPoint)
        
        snake.fromValue = fromValue
        snake.toValue = toValue
        
        inputLabel.layer.add(snake, forKey: nil)
    }
    
    
    func animatorColor(color:UIColor) {
        UIView.animate(withDuration: 0.5) {
            self.viewArray[1].backgroundColor = color
        }
    }
    
    // animation Arrow
    
    func showArrow(oldLevel:Int, newLevel:Int) {
        let difference = newLevel - oldLevel
        levelViewImage.alpha = 1
        switch difference {
        case -1:
            levelViewImage.image  = UIImage(named: nameImage[1])
            animateArrow(view: levelViewImage)
        case 1:
            levelViewImage.image  = UIImage(named: nameImage[0])
            animateArrow(view: levelViewImage)
        case 0:
            levelViewImage.image  = UIImage(named: nameImage[2])
            animateEqually(view: levelViewImage)
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
    
    
    // Animate Blure
    
    func animateBlure (state:State) {
        UIView.animate(withDuration: 0.4) {
            switch state {
            case .open: self.blureView.alpha = 0.9
            case .closed: self.blureView.alpha = 0
            }
        }
    }
    
    
    // MARK: - UIFeedbackGenerator
    
    func haptic () {
        let generator = UIImpactFeedbackGenerator(style:.light)
        generator.impactOccurred()
    }
    
    
    // MARK: - system
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
}

extension GameVC: ClosedProtocol {
    func reStart(controller: SettingGameVC ) {
        print("ПЕРЕЗАПУСК")
        animateBlure(state: .closed)
        // не запускать таймер
        if competitive() {
            print("Казуалка")
            stopTimer()
        } else {
            print("Обычный")
            reStartCountAndTimer()
            let newNumbers = level.level[modelConroller.levelNumber.Int]
            modelConroller.numbers = NumberArray(IntArray: newNumbers)
        }
        if modelConroller.oldSign.Int != modelConroller.sign.Int {
            print("Сброс уровня до нуля")
            modelConroller.levelNumber = Number(Int: 0)
        }
        creatureGame()
    }
}
