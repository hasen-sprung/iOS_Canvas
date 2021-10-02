
import UIKit
import Macaw

class GaugeViewController: UIViewController {
    
    let gaugeView = GaugeWaveAnimationView(frame: UIScreen.main.bounds)
    let floatingAreaView: UIView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
    
    let textWritingView = UIView()
    let cancelTextFieldButton = UIButton()
    let textFieldBackgroundView = UIView()
    let textField = UITextView()
    
    var floatingSVGViews = [FloatingSVGView]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        gaugeView.delegate = self
        
        view.backgroundColor = .white
        
        // MARK: - [start] svg view 생성
        floatingSVGViews.append(FloatingSVGView(frame: CGRect(x: 0, y: 0, width: 0, height: 0)))
        floatingSVGViews.append(FloatingSVGView(frame: CGRect(x: 0, y: 0, width: 0, height: 0)))
        floatingSVGViews.append(FloatingSVGView(frame: CGRect(x: 0, y: 0, width: 0, height: 0)))
        floatingSVGViews.append(FloatingSVGView(frame: CGRect(x: 0, y: 0, width: 0, height: 0)))
        // [end] svg view 생성
        
        view.addSubview(gaugeView)
        view.addSubview(floatingAreaView)
        
        for idx in 1...floatingSVGViews.count {
            
            floatingAreaView.addSubview(floatingSVGViews[idx - 1])
        }
        
        
        setFloatingAreaView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // MARK: - [start] gaugeView 애니메이션 실행
        gaugeView.startWaveAnimation()
        
        // MARK: - [start] navigationBar 투명
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = true
        // [End] navigationBar 투명
        
        // MARK: - [start] SVG 초기화 후, 애니메이션 시작
        floatingSVGViews[0].startSVGanimation(width: 60,
                                              height: 60,
                                              rangeX: 5,
                                              rangeY: -30,
                                              centerX: 0,
                                              centerY: 15,
                                              duration: 0.9,
                                              delay: 0.2,
                                              isTextField: true )
        
        floatingSVGViews[1].startSVGanimation(width: 60,
                                              height: 60,
                                              rangeX: 5,
                                              rangeY: -30,
                                              centerX: 0,
                                              centerY: 15,
                                              duration: 0.9,
                                              delay: 0.2)
        
        floatingSVGViews[2].startSVGanimation(width: 40,
                                              height: 40,
                                              rangeX: 14,
                                              rangeY: -40,
                                              centerX: 150,
                                              centerY: 23,
                                              duration: 0.7,
                                              delay: 0)
        
        floatingSVGViews[3].startSVGanimation(width: 50,
                                              height: 50,
                                              rangeX: -5,
                                              rangeY: -50,
                                              centerX: -130,
                                              centerY: 33,
                                              duration: 1.1,
                                              delay: 0.1)
        // [end] SVG 초기화 후, 애니메이션 시작
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        gaugeView.setGradientLayer()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        gaugeView.stopWaveAnimation()
    }
    
    // MARK: - [start] floating base View setting and moving
    func setFloatingAreaView() {
        
        floatingAreaView.frame.size = CGSize(width: view.frame.width, height: view.frame.height * 0.2)
        floatingAreaView.center = CGPoint(x: view.frame.width / 2, y: view.frame.height * 0.5)
        floatingAreaView.backgroundColor = .clear
        floatingAreaView.isUserInteractionEnabled = false
    }
    
    func setFloatingAreaView(newFigure: Float = 0.50) {
        
        // 0.12초 후에 실행 (wave속도와 sync 조절용도)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.12) {
            
            let figure = newFigure
            self.floatingAreaView.frame.size = CGSize(width: self.view.frame.width, height: self.view.frame.height * 0.2)
            self.floatingAreaView.center = CGPoint(x: self.view.frame.width / 2, y: self.view.frame.height * CGFloat(figure))
            self.floatingAreaView.backgroundColor = .clear
            self.floatingAreaView.isUserInteractionEnabled = false
            
            for idx in 1...self.floatingSVGViews.count {
                self.floatingSVGViews[idx - 1].changeSVGShape(figure: figure)
            }
        }
    }
    // [end] floating object base View setting and moving
    
    // MARK: - [start] appear textField (when figure settled)
    @objc func appearTextField(settledFigure: Float) {
        
        floatingSVGViews[0].textFieldDelegate = self
        floatingSVGViews[0].createTextfield()
        floatingSVGViews[0].alpha = 0.95
        floatingSVGViews[1].alpha = 0.0
    }
    // [end] appear textField (when figure settled)
}

//MARK: - GaugeWaveAnimationViewDelegate

extension GaugeViewController: GaugeWaveAnimationViewDelegate {
    
    func sendFigureToGaugeViewController() {
        
        let newFigure = gaugeView.getGaugeValue()
        setFloatingAreaView(newFigure: newFigure)
    }
    
    func actionTouchedUpOutside() {
        
        let settledFigure = gaugeView.getGaugeValue()
        appearTextField(settledFigure: settledFigure)
    }
    
}

extension GaugeViewController: TextFieldDelegate {
    
    func loadTextWritingView() {
    
        let boldConfig = UIImage.SymbolConfiguration(weight: .bold)
        let backImage = UIImage(systemName: "arrow.backward", withConfiguration: boldConfig)
        
        textWritingView.frame.size = CGSize(width: view.frame.width, height: view.frame.height)
        textWritingView.center = view.center
        textWritingView.backgroundColor = UIColor(hex: 0x5f4b8b)
        textWritingView.alpha = 0.0
        textWritingView.fadeIn(duration: 1.5)
        view.addSubview(textWritingView)
        
        cancelTextFieldButton.frame.size = CGSize(width: 50.0, height: 50.0)
        cancelTextFieldButton.frame.origin = CGPoint(x: 30, y: 80)
        cancelTextFieldButton.tintColor = .white
        cancelTextFieldButton.setImage(backImage, for: .normal)        
        view.addSubview(cancelTextFieldButton)
        
        cancelTextFieldButton.addTarget(self, action: #selector(dismissTextField), for: .touchUpInside)

    }
    
    func createTextField() {

        textFieldBackgroundView.frame.size = CGSize(width: textWritingView.frame.width * 0.8, height: textWritingView.frame.height * 0.5)
        textFieldBackgroundView.center = CGPoint(x: textWritingView.frame.width / 2, y: textWritingView.frame.height * 0.4)
        textFieldBackgroundView.backgroundColor = .white
        textFieldBackgroundView.layer.cornerRadius = 15.0
        textWritingView.addSubview(textFieldBackgroundView)

        
        textField.frame.size = CGSize(width: textFieldBackgroundView.frame.width * 0.85, height: textFieldBackgroundView.frame.height * 0.85)
        textField.center = CGPoint(x: textFieldBackgroundView.frame.width / 2, y: textFieldBackgroundView.frame.height / 2)
        textField.textColor = .gray
        textField.backgroundColor = .clear
        textField.font?.withSize(17)
        textField.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        textFieldBackgroundView.addSubview(textField)
        textField.becomeFirstResponder()
        
        textFieldBackgroundView.alpha = 0.0
        textFieldBackgroundView.fadeIn()
    }
    
    @objc func dismissTextField(_ sender: UIButton) {
        
        textWritingView.fadeOut()
        textField.removeFromSuperview()
        textFieldBackgroundView.removeFromSuperview()
        cancelTextFieldButton.removeFromSuperview()
        floatingSVGViews[0].zoomOutSVGShape()
    }
    
    func textFieldToSVGShape() {
        
        floatingSVGViews[0].alpha = 0.0
        floatingSVGViews[1].alpha = 0.95
        textWritingView.removeFromSuperview()
    }
    
}
