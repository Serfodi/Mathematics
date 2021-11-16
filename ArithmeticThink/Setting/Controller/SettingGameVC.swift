//
//  SettingViewController.swift
//  MatApp
//
//  Created by Сергей Насыбуллин on 13/08/2020.
//  Copyright © 2020 NasybullinSergei. All rights reserved.
//

import UIKit


enum Select {
    case select
    case notSelect
}

enum State {
    case open
    case closed
}


class SettingGameVC: UIViewController {
    
    // MARK: @IBOutlet
    
    // Главнй view для "operationButtons"
    @IBOutlet weak var operationView: UIView!
    
    @IBOutlet weak var operationLabel: UILabel!
    // Кнопки действий: "+" "-" "×" "÷" "²"
    @IBOutlet var operationButtons: [UIButton]!
    
    // Кнопка "Workout"
    @IBOutlet weak var buttonWorkout: UIButton!
    // Кнопка "Случайные"
    @IBOutlet weak var buttonRandom: UIButton!
    
    
    // Находятся внутри "buttonWorkout"
    // view для обазначения 1 число и 2 число
    var viewNumber:[UIView] = []
    // кнопки для изменения чисел
    var buttonNumber:[UIButton] = []
    
    var viewNotification:UIView!
    var labelNotification:UILabel!
    
    
    // stack Veiw
    @IBOutlet weak var buttonHorizonStackView: UIStackView!
    
    // for layout
    
    // Constraint for stack View
    @IBOutlet weak var widthConstraintHorizontalStackView: NSLayoutConstraint!
    @IBOutlet weak var buttomConstraintHorizontalStackView: NSLayoutConstraint!
    
    
    @IBOutlet var heightConstraintsButtonOperator: [NSLayoutConstraint]!
    
    @IBOutlet weak var buttomContraintButtonPluseOperator: NSLayoutConstraint!
    
    @IBOutlet weak var topConstraintLabelOperator: NSLayoutConstraint!
    
    @IBOutlet var topConstraintButtonOperator: [NSLayoutConstraint]!
    
    
    // for Animation
    // View Operation
    @IBOutlet weak var heightConstraintOperationView: NSLayoutConstraint!
    //
    @IBOutlet weak var heightConstraintButtonWorkout: NSLayoutConstraint!
    
    
    
    
    
    
    //  Состояние controller
    var modelController : ModelController!

    
    // Следит за нажатием на кнопки операций
    var buttonTag:Int = -1 {
        willSet {
            modelController.sign = newValue
            operationButtons[newValue].isEnabled = false
            animationButtonOperationScale(to: operationButtons[newValue], State: .select)
            animationButtonWorkout(isOpen: flagWorkout)
        }
        didSet {
            if oldValue == -1 { return }
            operationButtons[oldValue].isEnabled = true
            animationButtonOperationScale(to: operationButtons[oldValue], State: .notSelect)
        }
    }
    
    
    var flagRandom:Bool = false {
        willSet { buttonRandom.isSelected = newValue }
    }
    
    var flagWorkout : Bool!
    var stateWorkout : State = .closed
    
    
    var animationIsRan = false
    var animationRan = false
    
    
    let textButtonWorkout = NSLocalizedString("workout", comment: "")
    let textNotification = [NSLocalizedString("competitive", comment: ""), NSLocalizedString("normal", comment: "")]
    let textNumberButtonWorkout = [NSLocalizedString("from", comment: ""), NSLocalizedString("to", comment: "")]
    
    
    var localOne:CGPoint!
    var localTwo:CGPoint!
    
    // color and fount
    
    let buttonColor : UIColor = #colorLiteral(red: 0.6980392157, green: 0.7921568627, blue: 0.9333333333, alpha: 1)
    let boardColor : [CGColor] = [#colorLiteral(red: 0.6980392157, green: 0.7921568627, blue: 0.9333333333, alpha: 1),#colorLiteral(red: 0.2274509804, green: 0.3490196078, blue: 0.5215686275, alpha: 1)]
    let massageColor = [#colorLiteral(red: 0.1490196078, green: 0.1490196078, blue: 0.1490196078, alpha: 1),#colorLiteral(red: 0.721568644, green: 0.8862745166, blue: 0.5921568871, alpha: 1)]
    let textColor = [#colorLiteral(red: 0.9558615088, green: 0.971973598, blue: 0.9813905358, alpha: 1),#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1),#colorLiteral(red: 0.6980392157, green: 0.7921568627, blue: 0.9333333333, alpha: 1)]
    let fountName = "SFProRounded-Bold"
    
    
    // setting layout
    let parameterLayout = ParameterLayout()
    var scaleLayoutIndex : Double = 0
    

    
    
    // MARK: - ViewDidLoad
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scaleLayoutIndex = parameterLayout.layout(for: Int(view.bounds.width))
        // создания view
        setUpView()
        // настройка макета
        layout(view.bounds.width)
        // настройка модели
        settingViewModel()
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        viewNotification.alpha = 1
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        viewNotification.alpha = 0
    }
    
    
    
    
    
    
    // MARK: - Installations View
    
    /**
     Сustomizing the view from the model
     */
    func settingViewModel() {
        flagRandom = modelController.randomFlag
        flagWorkout = modelController.workoutFlag
        buttonTag = modelController.sign
        modelController.oldSign = modelController.sign
    }
    
    
    /**
     Создания View
     */
    func setUpView() {
        operationButtons = operationButtons.sorted(by: {$0.tag < $1.tag})
        setupBorderView()
        setupRoundedView()
        createButton()
        creatureLabelForButtonWorkout()
        creatureViewNotification()
    }
    
    func createButton() {
        creatureButton()
        creatureMinAndMaxView()
    }
    
    func setupBorderView() {
        border(buttonWorkout)
        border(buttonRandom)
    }

    func setupRoundedView() {
        roundedView(buttonWorkout)
        roundedView(buttonRandom)
        roundedView(operationView)
    }
    
    
    
    

    // MARK: - Buttons Action
    
    
    /**
     Mathematical operator selection buttons. 0 to 4
     */
    @IBAction func operation(_ sender: UIButton) {
        flagRandom = false
        buttonTag = sender.tag
        modelController.oldSign = buttonTag
        haptic()
    }
    
    
    
    @IBAction func randomOperation(_ sender: UIButton) {
        massageViewShowAndHide(randomFlag: !flagRandom, workoutFlag: false, oldRandom: flagRandom, oldWorkout: flagWorkout)
        flagRandom = !flagRandom
        flagWorkout = false
        animationButtonWorkout(isOpen: flagWorkout)
        buttonTag = flagRandom ? randomSignGenerate() : modelController.oldSign
        print(modelController.oldSign)
    }
    
    
    /**
     The workout button turns on the boundaries in which it can generate numbers
     */
    @IBAction func workout(_ sender: UIButton) {
        massageViewShowAndHide(randomFlag: false, workoutFlag: !flagWorkout, oldRandom: flagRandom, oldWorkout: flagWorkout)
        flagWorkout = !flagWorkout
        flagRandom = false
        
        animationButtonWorkout(isOpen: flagWorkout)
        
    }
    
    
    @objc func buttonNumber(_ sender:UIButton) {
        if modelController.numberRange[1] * 10 < 10000 {
            modelController.numberRange = modelController.numberRange.map{ $0 * 10 }
        } else {
            modelController.numberRange = [1,10]
        }
        let string = modelController.numberRange.map { String($0) }
        updatesButtonTitle(text: string)
    }
    
    
    
    
    // MARK:   Close View Action Pan
    
    
    @IBAction func exiteButton(_ sender: UIButton) { }
    
    
    @IBAction func panExite(_ sender: UIPanGestureRecognizer) {
        switch sender.state {
        case .began:
            localOne = sender.location(in: self.view)
        case .ended:
            localTwo = sender.location(in: self.view)
            if localOne.y - localTwo.y < -35 {
                print(localOne.y - localTwo.y)
                performSegue(withIdentifier: "closeSetting", sender: self)
            }
        default: ()
        }
    }
    
    
    
    
    
    // MARK: -  Prepare segue
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        modelController.randomFlag =  flagRandom
        modelController.workoutFlag =  flagWorkout
    }
    
    
    
    
    // MARK: - Metod
    
    /**
     updatesButtonTitle for buttonNumber
     */
    func updatesButtonTitle(text: [String]) {
        for (index,button) in buttonNumber.enumerated() {
            button.setTitle(text[index], for: .normal)
        }
    }
    
    
    func randomSignGenerate() -> Int {
        let randomGenerate = RandomGenerator()
        var randomTag = randomGenerate.random(to: 5)
        // не должен повторяться
        while randomTag == buttonTag {
            randomTag = randomGenerate.random(to: 5)
        }
        return randomTag
    }
    
    
    
    // MARK: - Motion
    
//    override func motionBegan(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
//        //        exite()
//    }
    
    
    // MARK: - FeedbackGenerator
    
    /**
     Vibration when pressing operation buttons
     */
    func haptic() {
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.impactOccurred()
    }
    
    
    // MARK: - System
    
    
    override var prefersStatusBarHidden: Bool { return true }
    
    
    
    
    
    
    
    
//    MARK: - Layout
    
    
    
    func layout(_ width: CGFloat) {
        // ширина стека
        widthConstraintHorizontalStackView.constant *= CGFloat(scaleLayoutIndex)
        
        // label size
        
        let sizeFount36 = CGFloat(36 * scaleLayoutIndex)
        operationLabel.font = UIFont(name: fountName, size: sizeFount36)
        
        let sizeFount24 = CGFloat(24 * scaleLayoutIndex)
        buttonRandom.titleLabel?.font = UIFont(name: fountName, size: sizeFount24)
        
        for button in operationButtons {
            button.titleLabel?.font = UIFont(name: fountName, size: sizeFount36)
        }
        
        // button operator
        for constraints in heightConstraintsButtonOperator {
            constraints.constant = CGFloat(80 * scaleLayoutIndex)
        }
        
        for constraints in topConstraintButtonOperator {
            constraints.constant = CGFloat(32 * scaleLayoutIndex)
        }
        
        
        buttomContraintButtonPluseOperator.constant = CGFloat(110 * scaleLayoutIndex)
        
    }
    
    
    
    
    
    
    // MARK: - View create
    
    
    func border(_ view:UIButton) {
        view.layer.borderWidth = CGFloat(4 * scaleLayoutIndex)
        view.layer.borderColor = boardColor[0]
    }
    
    
    func roundedView(_ view:UIView) {
        view.layer.cornerRadius = CGFloat(40 * scaleLayoutIndex)
    }
    
    
    
    // кружочки слева от выбора
    func creatureMinAndMaxView() {
        for i in 0...1 {
            
            let viewX = Int(25 * scaleLayoutIndex)
            let viewY = Int( Double(74 + 105 * i) * scaleLayoutIndex)
            let widthView = Int(80 * scaleLayoutIndex)
            let view = UIView(frame: CGRect(x: viewX, y: viewY, width: widthView, height: widthView))
            view.layer.cornerRadius = view.bounds.height / 2
            view.backgroundColor = buttonColor
            view.tag = i
            
            let labelX = CGFloat(15 * scaleLayoutIndex)
            let labelY = CGFloat(13 * scaleLayoutIndex)
            let widthLabel = CGFloat(50 * scaleLayoutIndex)
            let frame = CGRect(x: labelX, y: labelY, width: widthLabel, height: widthLabel)
            let label = UILabel(frame: frame)
            
            let sizeFount = CGFloat(26 * scaleLayoutIndex)
            label.font = UIFont(name: fountName, size: sizeFount)
            label.textColor = textColor[0]
            label.textAlignment = .center
            label.adjustsFontSizeToFitWidth = true
            label.minimumScaleFactor = 0.5
            label.text = textNumberButtonWorkout[i]
            
            view.addSubview(label)
            viewNumber.append(view)
            buttonWorkout.addSubview(view)
            
            view.transform = CGAffineTransform.init(scaleX: 0.3, y: 0.3)
            view.alpha = 0
        }
    }
    
    // кружочки с права  В них выбирают числа
    func creatureButton() {
        /**
         Converts int array to string
         */
        func arrayConvert(_ range:[Int]) -> [String] {
            var numbersString:[String] = []
            for number in range {
                numbersString.append(String(number))
            }
            return numbersString
        }
        
        let numberRangeString = arrayConvert(modelController.numberRange)
        
        for i in 0...1 {
            let viewX = CGFloat(25 * scaleLayoutIndex)
            let viewY = CGFloat( Double(74 + 105 * i) * scaleLayoutIndex)
            let width = CGFloat(80 * scaleLayoutIndex)
            let frame = CGRect(x: viewX, y: viewY, width: width, height: width)
            
            let button = UIButton(frame: frame)
            
            let sizeFount = CGFloat(36 * scaleLayoutIndex)
            button.titleLabel?.font = UIFont.init(name: fountName, size: sizeFount)
            button.setTitle(numberRangeString[i], for: .normal)
            button.setTitleColor(buttonColor, for: .normal)
            button.titleLabel?.textAlignment = .center
            
            button.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            button.layer.cornerRadius = button.frame.height / 2
            button.layer.borderWidth = 4
            button.layer.borderColor = boardColor[0]
            
            button.addTarget(self, action: #selector(buttonNumber(_:)), for: .touchUpInside)
            button.tag = i
            
            buttonNumber.append(button)
            buttonWorkout.addSubview(button)
            
            button.transform = CGAffineTransform.init(scaleX: 1, y: 1)
            button.alpha = 0
        }
    }
    
    
    func creatureLabelForButtonWorkout() {
        let width = CGFloat(220 * scaleLayoutIndex)
        let height = CGFloat(32 * scaleLayoutIndex)
        let labelX = CGFloat(40 * scaleLayoutIndex)
        let labelY = CGFloat(24 * scaleLayoutIndex)
        let frame = CGRect(x: labelX, y: labelY, width: width, height: height)
        let label = UILabel(frame: frame)
        let sizeFount = CGFloat( 24 * scaleLayoutIndex)
        label.font = UIFont(name: fountName, size: sizeFount)
        label.textColor = textColor[2]
        label.textAlignment = .center
        label.text = textButtonWorkout
        
        buttonWorkout.addSubview(label)
    }
    
    
    
    func creatureViewNotification() {
        
        let view = UIView(frame: CGRect(x: 0, y: -60, width: 264, height: 60))
        
        
        view.center.x = self.view.frame.width / 2
        view.backgroundColor = massageColor[0]
        view.layer.cornerRadius = 30
        let label = UILabel(frame: CGRect(x: 32, y: 19, width: 200, height: 22))
        label.font = UIFont(name: fountName, size: 16)
        label.textColor = textColor[1]
        label.text = textNotification[1]
        label.textAlignment = .center
        labelNotification = label
        view.addSubview(labelNotification)
        viewNotification = view
        self.view.addSubview(viewNotification)
        viewNotification.alpha = 0
    }
    
    
    
    
    
    
    
    
    
    
    
    // MARK: - ANIMATION
    
    
    
    // MARK: animatorButtonOperator
    
    
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
    
    
    
    // MARK:  animation for "buttonWorkout"
    
    /**
     Функция анимяироваиня кнопки Тренировка главная
     */
    open func animationButtonWorkout(isOpen:Bool) {
        if animationIsRan { animationRan = true }
        switch isOpen {
        case true:
            animationButtonWorkoutState(to: .open)
        case false:
            animationButtonWorkoutState(to: .closed)
        }
    }
    
    func animationButtonWorkoutState(to state: State) {
        stateWorkout = state
        
        switch state {
        case .open:
            animateOpenWorkout(views: viewNumber, buttons: buttonNumber, state: .open)
        case .closed:
            animateCloseWorkout(views: viewNumber, buttons: buttonNumber, state: .closed)
        }
        
        stateWorkout = state
    }
    
    
    
    //    1. Анимация высоты
    //    2. Анимация пявления view Numbers и появления button Numbers
    //    3. Анимация выхода кнопок button Numbers из-за viewNumbers
    
    
    // MARK:  Animate Open Workout
    
    /**
     Функция анимации кнопки
    */
    func animateOpenWorkout(views:[UIView], buttons:[UIButton], state: State) {
        
        animationIsRan = true
        
        func openButton() {
            let animator = creatureAnimate()
            layoutAnimation(state: state)
            animator.addAnimations { self.view.layoutIfNeeded() }
            animator.addCompletion { (s) in
                showView()
            }
            animator.startAnimation()
        }
        
        func showView() {
            let animator = creatureAnimate()
            animator.addAnimations {
                self.alpha(alpha: 1, views)
                for view in views { view.transform = .identity }
            }
            animator.addCompletion { (s) in
                movingButton()
            }
            animator.startAnimation()
        }
        
        func movingButton() {
            let animator = creatureAnimate()
            self.alpha(alpha: 1, buttons)
            animator.addAnimations {
                for button in buttons {
                    button.frame = self.newViewframe(state: .open, button)
                }
            }
            animator.addCompletion { (s) in
                self.animationIsRan = false
                if self.animationRan {
                    self.animationRan = false
                    self.animationButtonWorkout(isOpen: self.flagWorkout)
                }
            }
            animator.startAnimation()
        }
        
        openButton()
    }
    
    
    
    // MARK:  Animation closed Workout
    
    func animateCloseWorkout(views:[UIView], buttons:[UIButton], state: State) {
        animationIsRan = true
        
        func movingButton() {
            let animator = creatureAnimate()
            animator.addAnimations {
                for button in buttons {
                    button.frame = self.newViewframe(state: .closed, button)
                }
            }
            
            animator.addCompletion { (s) in
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
                closeButton()
            }
            animator.startAnimation()
        }
        
        func closeButton() {
            let animator = creatureAnimate()
            layoutAnimation(state: state)
            animator.addAnimations { self.view.layoutIfNeeded() }
            animator.addCompletion { (s) in
                self.animationIsRan = false
                if self.animationRan {
                    self.animationRan = false
                    self.animationButtonWorkout(isOpen: self.flagWorkout)
                }
            }
            animator.startAnimation()
        }
        
        movingButton()
        
        
    }
    
    
    
    
    
    // MARK:  Вспомогательные функци анимации
    
    
    func newViewframe(state:State ,_ view:UIView) -> CGRect {
        var frame = view.frame
        switch state {
        case .open:
            frame.origin.x = CGFloat(135 * scaleLayoutIndex)
            frame.size.width = CGFloat(140 * scaleLayoutIndex)
        case .closed:
            frame.origin.x = CGFloat(25 * scaleLayoutIndex)
            frame.size.width = CGFloat(80 * scaleLayoutIndex)
        }
        return frame
    }
    
    func creatureAnimate() -> UIViewPropertyAnimator {
        return UIViewPropertyAnimator(duration: 0.25, curve: .easeOut)
    }
    
    func scale(scale:CGFloat,_ views:[UIView]) {
        for view in views { view.transform = CGAffineTransform.init(scaleX: scale, y: scale) }
    }
    
    func alpha(alpha:CGFloat,_ views:[UIView]) {
        for view in views { view.alpha = alpha }
    }
    
    
    
    
    
    // MARK:  - layout for animation
    
    
    func layoutAnimation(state: State) {
        switch state {
        case .open:
            layoutWorkout(state: .open)
            if view.bounds.height <= 750 { layoutButtomStackView(state: .closed) }
            layoutViewOperator(state: .closed)
        case .closed:
            layoutWorkout(state: .closed)
            layoutViewOperator(state: .open)
            layoutButtomStackView(state: .open)
        }
    }
    
    func layoutWorkout(state: State) {
        switch state {
        case .open:
            self.heightConstraintButtonWorkout.constant = CGFloat(285 * scaleLayoutIndex)
        case .closed:
            self.heightConstraintButtonWorkout.constant = CGFloat(80 * scaleLayoutIndex)
        }
    }
    
    func layoutViewOperator(state: State) {
        switch state {
        case .open:
            self.heightConstraintOperationView.constant = CGFloat(375 * scaleLayoutIndex)
            self.buttomContraintButtonPluseOperator.constant = CGFloat(110 * scaleLayoutIndex)
        case .closed:
            self.heightConstraintOperationView.constant = CGFloat(305 * scaleLayoutIndex)
            self.buttomContraintButtonPluseOperator.constant = CGFloat(75 * scaleLayoutIndex)
        }
    }
    
    func layoutButtomStackView(state: State) {
        switch state {
        case .open:
            self.buttomConstraintHorizontalStackView.constant = 20
        case .closed:
            self.buttomConstraintHorizontalStackView.constant = -(CGFloat(80 * scaleLayoutIndex))
        }
    }
    
    
    
    
    
    // MARK: - Animation massage
    
    
    /**
     Notification about turning on and off training and randomness
     */
    func massageViewShowAndHide(randomFlag:Bool, workoutFlag:Bool, oldRandom:Bool, oldWorkout:Bool) {
        if (randomFlag || workoutFlag) && (!oldWorkout && !oldRandom)  {
            labelNotification.text = textNotification[1]
            viewNotification.backgroundColor = massageColor[0]
            animationShowNotification()
        } else if !randomFlag && !workoutFlag {
            labelNotification.text = textNotification[0]
            viewNotification.backgroundColor = massageColor[1]
            animationShowNotification()
        }
    }
    
    let animtionNotification:UIViewPropertyAnimator = {
        let animator = UIViewPropertyAnimator(duration: 0.3, curve: .easeOut)
        animator.isReversed = true
        return animator
    }()
    
    var animationNotification:UIViewPropertyAnimator!
    
    func animationShowNotification() {
        
        let translationY = view.bounds.height > 750 ? 110 : 70
        
        func show() {
            UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut, animations: {
                
                self.viewNotification.transform = CGAffineTransform(translationX: 0, y: CGFloat(translationY))
                
            }) { (true) in hied() }
        }
        
        func hied() {
            let animator = UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 0.3, delay: 0.8, options: .curveEaseIn, animations: {
                self.viewNotification.transform = .identity
            }) { (state) in  }
            animationNotification = animator
            animator.startAnimation()
        }
        
        show()
    }
    
    
    
    
    
}
