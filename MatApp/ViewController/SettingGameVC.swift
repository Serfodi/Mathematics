//
//  SettingViewController.swift
//  MatApp
//
//  Created by Сергей Насыбуллин on 13/08/2020.
//  Copyright © 2020 NasybullinSergei. All rights reserved.
//

import UIKit

enum StateWorkout:String {
    case open = "open"
    case half = "half"
    case closed = "closed"
}

enum Select {
    case select
    case notSelect
}

enum Size {
    case compact
    case regular
}

enum State {
    case open
    case closed
}

class SettingGameVC: UIViewController {

    // MARK: @IBOutlet
    
    // Главнй view для "operationButtons"
    @IBOutlet weak var operationView: UIView!
    // Ограничитель для высоты "operationView"
    @IBOutlet weak var heightConstraintOperationView: NSLayoutConstraint!
    // Кнопки действий: "+" "-" "×" "÷" "²"
    @IBOutlet var operationButtons: [UIButton]!
    // Верхний ограничитель для кнопки "+"
    @IBOutlet weak var topConstraintOperationZero: NSLayoutConstraint!
    
    
    // Кнопка "Workout"
    @IBOutlet weak var buttonWorkout: UIButton!
    @IBOutlet weak var labelWorkout: UILabel!
    // Ограничитель высоты
    @IBOutlet weak var heightConstraintButtonWorkout: NSLayoutConstraint!
    
    // Находятьс внутри "buttonWorkout"
    // view для обазначения 1 число и 2 число
    var viewNumber:[UIView] = []
    // кнопки для изменения чисел
    var buttonNumber:[UIButton] = []
    
    var viewNotification:UIView!
    var labelNotification:UILabel!
    
    // Кнопка "Случайные"
    @IBOutlet weak var buttonRandom: UIButton!
    // Нижний ограничитель для кнопи "RandomOperator"
    @IBOutlet weak var botonConstrainRandomOperation: NSLayoutConstraint!
    
    
    //  Состояние controllera
    var modelController:ModelConrolle!
    
    // Делегат для закрытия "Setting view"
    var delegate:ClosedProtocol!
    
    // Следит за нажатием на кнопки операций
    var buttonTag:Int = 1 {
        willSet {
            print("")
//            print("Новый знак: \(converSign(sign:newValue))")
            modelController.sign = Number(Int: newValue)
            operationButtons[newValue].isEnabled = false
            animationButtonOperationScale(to: operationButtons[newValue], State: .select)
            animationButtonWorkout(isOpen: flagWorkout)
        }
        didSet {
            operationButtons[oldValue].isEnabled = true
            animationButtonOperationScale(to: operationButtons[oldValue], State: .notSelect)
        }
    }
    
    var flagRandom:Bool = false {
        willSet { buttonRandom.isSelected = newValue }
    }
    
    var flagWorkout:Bool!
    
    var stateWorkout:StateWorkout = .closed
    
    var randomGenerate = RandomGenerator()
    
    var animationIsRan = false
    var animationRan = false
    
    let numbersInString:[Int:String] = [10:"10",100:"100",1000:"1 000",10000:"10 000"]
    
    let textNotification = ["Соревновательный включен", "Соревновательный выключен"]
    
    // MARK: - View
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        print("Открыли настройки")
        setUp()
        setting()
    }
    
    override func viewWillLayoutSubviews() {
        layoutAraund(at: stateWorkout)
        view.layoutIfNeeded()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        viewNotification.alpha = 1
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        viewNotification.alpha = 0
    }
    
    // MARK: - setUp
    
    
    func setUp() {
        sortedNumber()
        setupView()
        setupButtonWorout()
        creatureViewTwo()
    }
    
    func sortedNumber() {
        // порядковый номер должен совподать с тэгом
        operationButtons = operationButtons.sorted(by: {$0.tag < $1.tag})
    }
    
    func setting() {
        flagRandom = modelController.random.bool
        flagWorkout = modelController.workout.bool
        buttonTag = modelController.sign.Int
        modelController.oldSign = modelController.sign
    }
    
    func setupView() {
        border(buttonWorkout)
        border(buttonRandom)
    }
    
    func setupButtonWorout() {
        creatureButton()
        creatureView()
    }
    
    func border(_ view:UIButton) {
        view.layer.borderWidth = 4
        view.layer.borderColor = #colorLiteral(red: 0.2863302529, green: 0.3575156629, blue: 0.4799464345, alpha: 1)
    }
    
    func creatureButton() {
        func arrayConvert(_ numbers:[Int]) -> [String] {
            var numberString = ["10","10"] // дефолт
            for (index,number) in numbers.enumerated() {
                guard let str = numbersInString[number] else { return ["10","10"] }
                numberString[index] = str
            }
            return numberString
        }
        let numberString = arrayConvert(modelController.numbers.IntArray)
        for i in 0...1 {
            let button = UIButton(frame: CGRect(x: 25, y: 74 + 105 * i, width: 80, height: 80))
            button.addTarget(self, action: #selector(buttonNumber(_:)), for: .touchUpInside)
            button.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            button.layer.cornerRadius = button.bounds.height / 2
            button.layer.borderWidth = 4
            button.layer.borderColor = #colorLiteral(red: 0.2863302529, green: 0.3575156629, blue: 0.4799464345, alpha: 1)
            button.titleLabel?.font = UIFont.init(name: "OpenSans-Bold", size: 34)
            button.setTitle(numberString[i], for: .normal)
            button.setTitleColor(#colorLiteral(red: 0.2863302529, green: 0.3575156629, blue: 0.4799464345, alpha: 1), for: .normal)
            button.titleLabel?.textAlignment = .center
            button.tag = i
            buttonNumber.append(button)
            buttonWorkout.addSubview(button)
            button.transform = CGAffineTransform.init(scaleX: 1, y: 1)
            button.alpha = 0
        }
    }
    
    func creatureView() {
        for i in 0...1 {
            let view = UIView(frame: CGRect(x: 25, y: 74 + 105 * i, width: 80, height: 80))
            view.layer.cornerRadius = view.bounds.height / 2
            view.backgroundColor = #colorLiteral(red: 0.2863302529, green: 0.3575156629, blue: 0.4799464345, alpha: 1)
            view.tag = i
            let label = UILabel(frame: CGRect(x: 30, y: 16, width: 21, height: 49))
            label.font = UIFont(name: "OpenSans-Bold", size: 34)
            label.textColor = #colorLiteral(red: 0.9558615088, green: 0.971973598, blue: 0.9813905358, alpha: 1)
            label.text = "\(i + 1)"
            view.addSubview(label)
            viewNumber.append(view)
            buttonWorkout.addSubview(view)
            view.transform = CGAffineTransform.init(scaleX: 0.3, y: 0.3)
            view.alpha = 0
        }
    }
    
    func creatureViewTwo() {
        let view = UIView(frame: CGRect(x: 0, y: -60, width: 300, height: 60))
        view.center.x = self.view.frame.width / 2
        view.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        view.layer.cornerRadius = 25
        let label = UILabel(frame: CGRect(x: 20, y: 19, width: 260, height: 22))
        label.font = UIFont(name: "OpenSans-Bold", size: 16)
        label.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        label.text = "Cоревновательный режим выключен"
        label.textAlignment = .center
        labelNotification = label
        view.addSubview(labelNotification)
        viewNotification = view
        self.view.addSubview(viewNotification)
        viewNotification.alpha = 0
    }
    
    
    // MARK: - Buttons Action
    
    @IBAction func operation(_ sender: UIButton) {
        flagRandom = false
        buttonTag = sender.tag
        haptic()
        changeNumber()
    }
    
    @IBAction func randomOperation(_ sender: UIButton) {
        competitiveMode(random: !flagRandom, workout: false, oldRanomdom: flagRandom, oldWorkout: flagWorkout)
        flagRandom = !flagRandom
        flagWorkout = false
        animationButtonWorkout(isOpen: flagWorkout)
        buttonTag = flagRandom ? randomTag() : modelController.oldSign.Int
    }
    
    @IBAction func workout(_ sender: UIButton) {
        competitiveMode(random: false, workout: !flagWorkout, oldRanomdom: flagRandom, oldWorkout: flagWorkout)
        flagWorkout = !flagWorkout
        flagRandom = false
        animationButtonWorkout(isOpen: flagWorkout)
        modelController.numbers = NumberArray(IntArray: [10,10])
        upDataLabelButtonNumber(modelController.numbers.IntArray)
    }
    
    // для "buttonWorkout" которые внутри
    @objc func buttonNumber(_ sender:UIButton) {
        var array = modelController.numbers.IntArray
        var number = array[sender.tag]
        number *= 10
        if number == 100000 { number = 10 }
        array[sender.tag] = number
        modelController.numbers = NumberArray(IntArray: array)
        upDataLabelButtonNumber(array)
    }
    
    func upDataLabelButtonNumber(_ numbers:[Int]) {
        for (index,button) in buttonNumber.enumerated() {
            button.setTitle(numbersInString[numbers[index]], for: .normal)
        }
    }
    
    
    // MARK:  - func
    
    func randomTag() -> Int {
        var randomTag = randomGenerate.random(to: 5)
        // не должен повторяться
        while randomTag == buttonTag {
            randomTag = randomGenerate.random(to: 5)
        }
        return randomTag
    }
    
    func changeNumber() {
        guard buttonTag == 1 else { return }
        var array = modelController.numbers.IntArray
        if array[0] < array[1] {
//            print("Смена мест")
            let one = array[1]
            array[1] = array[0]
            array[0] = one
        }
        modelController.numbers = NumberArray(IntArray: array)
    }
    
    func converSign(sign:Int) -> String {
        switch sign {
        case 0:
            return "+"
        case 1:
            return "−"
        case 2:
            return "×"
        case 3:
            return "x²"
        case 4:
            return "÷"
        default:
            return "нет такого знака"
        }
    }
    
    
    // MARK: Уведомление
    // показывать уведомления если до этого было false false
    func competitiveMode(random:Bool, workout:Bool, oldRanomdom:Bool, oldWorkout:Bool) {
        if (random || workout) && (!oldWorkout && !oldRanomdom)  {
            labelNotification.text = textNotification[1]
            viewNotification.backgroundColor = #colorLiteral(red: 0.1490196078, green: 0.1490196078, blue: 0.1490196078, alpha: 1)
            animationShowNotification()
        } else if !random && !workout {
            labelNotification.text = textNotification[0]
            viewNotification.backgroundColor = #colorLiteral(red: 0.721568644, green: 0.8862745166, blue: 0.5921568871, alpha: 1)
            animationShowNotification()
        }
    }
    
    
    
    // MARK: - Exite
    
    func exite() {
        print("Выход из настроек")
        // изменения в настройках игры
        modelController.random = Flag(bool: flagRandom)
        modelController.workout = Flag(bool: flagWorkout)
        changeNumber()
        // код для GVC
        self.delegate.reStart(controller: self)
        dismiss(animated: true, completion: nil)
    }
    
    
    // MARK: - ANIMATION
    
    // AnimatorButtonOperator
    
    func animationButtonOperationScale(to button: UIButton, State:Select) {
        UIView.animate(withDuration: 0.2) {
            switch State {
            case .select:
                button.transform = CGAffineTransform.init(scaleX: 0.9, y: 0.9)
            case .notSelect:
                button.transform = .identity
            }
        }
    }
    
    let animtionNotification:UIViewPropertyAnimator = {
        let animator = UIViewPropertyAnimator(duration: 0.3, curve: .easeOut)
        animator.isReversed = true
        return animator
    }()
    
    var animationNotification:UIViewPropertyAnimator!
    
    func animationShowNotification() {
        func show() {
            UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut, animations: {
                
                self.viewNotification.transform = CGAffineTransform(translationX: 0, y: 70)
                print("Начало")
                
            }) { (true) in hied() }
        }
        func hied() {
            let animator = UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 0.3, delay: 0.8, options: .curveEaseIn, animations: {
                self.viewNotification.transform = .identity
            }) { (state) in print("Конец") }
            animationNotification = animator
            animator.startAnimation()
        }
        show()
    }
    
    
    
    // Animation for "buttonWorkout"
    
    func animationButtonWorkout(isOpen:Bool) {
        if animationIsRan {
            animationRan = true
//            print("Повторная анимация")
            return
        }
//        print("")
//        print("Анимация кнопки")
        switch isOpen {
        case true:
            isOneNumber() ? animationButtonWorkoutState(to: .half) : animationButtonWorkoutState(to: .open)
        case false:
            animationButtonWorkoutState(to: .closed)
        }
    }
    
    func animationButtonWorkoutState(to state:StateWorkout) {
        let oldState = stateWorkout
        stateWorkout = state
//        print("")
//        print("Animation State: \(state)")
        switch state {
        case .open:
            animateOpenWorkout(views: viewNumber, buttons: buttonNumber, state: .open)
        case .closed:
            animateCloseWorkout(views: viewNumber, buttons: buttonNumber, state: .closed)
        case .half:
            if oldState == .open {
                animateCloseWorkout(views: [viewNumber[1]], buttons: [buttonNumber[1]], state: .half)
            }
            if oldState == .closed {
                animateOpenWorkout(views: [viewNumber[0]], buttons: [buttonNumber[0]], state: .half)
            }
        }
        stateWorkout = state
    }
    
//    1. Анимация высоты
//    2. Анимация пявления view Numbers и появления button Numbers
//    3. Анимация выхода кнопок button Numbers из-за viewNumbers
    
    // animate Open Workout
    
    // для Для каких чисел показать только одно число
    func isOneNumber() -> Bool {
        return modelController.sign.Int == 3
    }
    
    func creatureAnimate() -> UIViewPropertyAnimator {
        return UIViewPropertyAnimator(duration: 0.25, curve: .easeOut)
    }
    
    func animateOpenWorkout(views:[UIView], buttons:[UIButton], state:StateWorkout) {
        animationIsRan = true
        
        func openButton() {
            let animator = creatureAnimate()
            layout(state: state)
            animator.addAnimations { self.view.layoutIfNeeded() }
            animator.addCompletion { (s) in
//                print("Open openButton: \(state.rawValue)")
                showView()
            }
            animator.startAnimation()
        }
        
        func showView() {
//            guard self.stateWorkout == state else { return }
            let animator = creatureAnimate()
            animator.addAnimations {
                self.alpha(alpha: 1, views)
                for view in views { view.transform = .identity }
            }
            animator.addCompletion { (s) in
//                print("Open showView: \(state.rawValue)")
                moveingButton()
            }
            animator.startAnimation()
        }
        
        func moveingButton() {
//            guard self.stateWorkout == state else { return }
            let animator = creatureAnimate()
            self.alpha(alpha: 1, buttons)
            animator.addAnimations {
                for button in buttons {
                    button.frame = self.newViewframe(state: .open, button)
                }
            }
            animator.addCompletion { (s) in
//                print("Open moveingButton: \(state.rawValue)")
                self.animationIsRan = false
                if self.animationRan {
                    self.animationRan = false
                    self.animationButtonWorkout(isOpen: self.flagWorkout)
//                    print("Новая анимация")
                }
            }
            animator.startAnimation()
        }
        
        openButton()
    }
    
    
    // Animation closed
    
    func animateCloseWorkout(views:[UIView], buttons:[UIButton], state:StateWorkout) {
        animationIsRan = true
        
        func moveingButton() {
            let animator = creatureAnimate()
            animator.addAnimations {
                for button in buttons {
                    button.frame = self.newViewframe(state: .closed, button)
                }
            }
            animator.addCompletion { (s) in
//                print("Close moveingButton: \(state.rawValue)")
                hideView()
            }
            animator.startAnimation()
        }
        
        func hideView() {
            let animator = creatureAnimate()
            self.alpha(alpha: 0, buttons)
            animator.addAnimations {
                self.scale(scale: 0.3, views)
                self.alpha(alpha: 0, views)
            }
            
            animator.addCompletion { (s) in
//                print("Close hideView: \(state.rawValue)")
                closeButton()
            }
            animator.startAnimation()
        }
        
        func closeButton() {
            let animator = creatureAnimate()
            layout(state: state)
            animator.addAnimations { self.view.layoutIfNeeded() }
            animator.addCompletion { (s) in
//                print("Close closeButton: \(state.rawValue)")
                self.animationIsRan = false
                if self.animationRan {
                    self.animationRan = false
                    self.animationButtonWorkout(isOpen: self.flagWorkout)
//                    print("Новая анимация")
                }
            }
            animator.startAnimation()
        }
        
        moveingButton()
    }
    
    
       
    // MARK: - Layout
    
    
    func layout(state:StateWorkout) {
        switch state {
        case .open , .half:
            layoutWorkuot(state: state)
            layoutAraund(at: state)
        case .closed:
            layoutWorkuot(state: .closed)
            layoutViewOperator(size: .regular)
            layotRandomButton(size: .regular)
        }
    }
    
    
    // настраивает окружения под workuto
    func layoutAraund(at state:StateWorkout) {
        switch view.frame.height {
        case 0...700:
            if state != .closed { layotRandomButton(size: .compact) }
            if state == .open { layoutViewOperator(size: .compact) }
            if state == .half { layoutViewOperator(size: .regular) }
        case 736:
            if state == .half { layotRandomButton(size: .regular) }
            if state == .open { layotRandomButton(size: .compact) }
        case 768...812:
            if state == .half { layoutViewOperator(size: .regular) }
            if state == .open { layoutViewOperator(size: .compact) }
        case 896...:
            layoutViewOperator(size: .regular)
            layotRandomButton(size: .regular)
        default:
            print("Нет такого размера")
        }
    }
    
    func layoutWorkuot(state:StateWorkout) {
        switch state {
        case .open:
            self.heightConstraintButtonWorkout.constant = 284
        case .half:
            self.heightConstraintButtonWorkout.constant = 179
        case .closed:
            self.heightConstraintButtonWorkout.constant = 80
        }
    }
    func layoutViewOperator(size:Size) {
        switch size {
        case .compact:
            self.heightConstraintOperationView.constant = 307
            self.topConstraintOperationZero.constant = 159
        case .regular:
            self.heightConstraintOperationView.constant = 375
            self.topConstraintOperationZero.constant = 185
        }
    }
    func layotRandomButton(size:Size) {
        switch size {
        case .compact:
            self.botonConstrainRandomOperation.constant = -80
        case .regular:
            self.botonConstrainRandomOperation.constant = 20
        }
    }
    
    
    func scale(scale:CGFloat,_ views:[UIView]) {
        for view in views { view.transform = CGAffineTransform.init(scaleX: scale, y: scale) }
    }
    
    func alpha(alpha:CGFloat,_ views:[UIView]) {
        for view in views { view.alpha = alpha }
    }
    
    func newViewframe(state:State ,_ view:UIView) -> CGRect {
        var frame = view.frame
        switch state {
        case .open:
            frame.origin.x = 135
            frame.size.width = 140
        case .closed:
            frame.origin.x = 25
            frame.size.width = 80
        }
        return frame
    }
    
    
    
    // MARK: - закрытие шторки
    
    
    @IBAction func exiteButton(_ sender: UIButton) {
        exite()
    }
    
    var localOne:CGPoint!
    var localTwo:CGPoint!
    
    @IBAction func panExite(_ sender: UIPanGestureRecognizer) {
        switch sender.state {
        case .began:
            localOne = sender.location(in: self.view)
        case .ended:
            localTwo = sender.location(in: self.view)
            if localOne.y - localTwo.y < -35 {
                print(localOne.y - localTwo.y)
                self.exite()
            }
        default:
            ()
        }
    }
    
    
    // MARK: - FeedbackGenerator
    
    func haptic () {
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.impactOccurred()
    }
    
    
    // MARK: - Motion
    
    override func motionBegan(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        exite()
    }
    
    
    // MARK: - System
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
}
