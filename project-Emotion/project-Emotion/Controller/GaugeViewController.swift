
import UIKit
import Macaw
import CoreData

class CompleteRecordButton: UIButton {
    
    var date: Date?
    var figure: Float?
}

extension UIColor {
    func toColor(_ color: UIColor, percentage: CGFloat) -> UIColor {
        let percentage = max(min(percentage, 100), 0) / 100
        switch percentage {
               case 0: return self
               case 1: return color
               default:
                   var (r1, g1, b1, a1): (CGFloat, CGFloat, CGFloat, CGFloat) = (0, 0, 0, 0)
                   var (r2, g2, b2, a2): (CGFloat, CGFloat, CGFloat, CGFloat) = (0, 0, 0, 0)
                   guard self.getRed(&r1, green: &g1, blue: &b1, alpha: &a1) else { return self }
                   guard color.getRed(&r2, green: &g2, blue: &b2, alpha: &a2) else { return self }

                   return UIColor(red: CGFloat(r1 + (r2 - r1) * percentage),
                                  green: CGFloat(g1 + (g2 - g1) * percentage),
                                  blue: CGFloat(b1 + (b2 - b1) * percentage),
                                  alpha: CGFloat(a1 + (a2 - a1) * percentage))
        }
    }
}

class GaugeViewController: UIViewController {
    let myView = UIView(frame: .init(x: 0, y: 0, width: 200, height: 200))
    
    let gaugeView = GaugeWaveAnimationView(frame: UIScreen.main.bounds)
    let floatingAreaView: UIView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
    
    let textWritingView = UIView()
    let cancelTextFieldButton = UIButton()
    let textFieldBackgroundView = UIView()
    let textField = UITextView()
    
    let dateLabel = UILabel()
    let completeButton = CompleteRecordButton()
    
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
        view.addSubview(myView)
        myView.backgroundColor = .red
        
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
        floatingSVGViews[0].changeSVGToTextField(settledFigure: settledFigure)
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
        myView.backgroundColor = defaultBackgroundColorTop.toColor(sampleBlueTop, percentage: CGFloat(newFigure * 100))
    }
    
    func actionTouchedUpOutside() {
        
        let settledFigure = gaugeView.getGaugeValue()
        appearTextField(settledFigure: settledFigure)
    }
    
    func actionTouchedUpOutsideInSafeArea() {
        print("in safe area touched out")
    }
}

// MARK: - TextFieldDelegate
extension GaugeViewController: TextFieldDelegate {
    
    func loadTextWritingView() {
        
        let boldConfig = UIImage.SymbolConfiguration(weight: .bold)
        let backImage = UIImage(systemName: "arrow.backward", withConfiguration: boldConfig)
        
        textWritingView.frame.size = CGSize(width: view.frame.width, height: view.frame.height)
        textWritingView.center = view.center
        textWritingView.backgroundColor = UIColor(hex: 0xb2b2ff)
        textWritingView.alpha = 0.0
        textWritingView.fadeIn(duration: 1.5)
        view.addSubview(textWritingView)
        
        cancelTextFieldButton.frame.size = CGSize(width: 50.0, height: 50.0)
        cancelTextFieldButton.frame.origin = CGPoint(x: 30, y: 80)
        cancelTextFieldButton.tintColor = .white
        cancelTextFieldButton.setImage(backImage, for: .normal)
        
        cancelTextFieldButton.addTarget(self, action: #selector(dismissTextField), for: .touchUpInside)
        
    }
    
    func createTextField(settledFigure: Float) {
        
        let date = Date()
        let df = DateFormatter()
        df.dateFormat = "yyyy년 M월 d일 a h시 mm분"
        df.locale = Locale(identifier:"ko_KR")
        let dateString = df.string(from: date)
        
        textFieldBackgroundView.frame.size = CGSize(width: textWritingView.frame.width * 0.8, height: textWritingView.frame.height * 0.40)
        textFieldBackgroundView.center = CGPoint(x: textWritingView.frame.width / 2, y: textWritingView.frame.height * 0.35)
        textFieldBackgroundView.backgroundColor = .white
        textFieldBackgroundView.layer.cornerRadius = 15.0
        
        dateLabel.frame.size = CGSize(width: textFieldBackgroundView.frame.width * 0.75, height: 15)
        dateLabel.center = CGPoint(x: textFieldBackgroundView.frame.width / 2, y: 30)
        dateLabel.text = dateString
        dateLabel.textColor = .black
        dateLabel.textAlignment = .center
        dateLabel.font = UIFont.systemFont(ofSize: 13, weight: .bold)
        
        textField.frame.size = CGSize(width: textFieldBackgroundView.frame.width * 0.80, height: textFieldBackgroundView.frame.height * 0.75)
        textField.center = CGPoint(x: textFieldBackgroundView.frame.width / 2, y: textFieldBackgroundView.frame.height / 2)
        textField.textColor = .black
        textField.backgroundColor = .clear
        textField.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        
        completeButton.frame.size = CGSize(width: textFieldBackgroundView.frame.width * 0.4, height: 50)
        completeButton.center = CGPoint(x: textFieldBackgroundView.frame.width / 2, y: textFieldBackgroundView.frame.height * 0.9)
        completeButton.setTitle("완료", for: .normal)
        completeButton.setTitleColor(.black, for: .normal)
        completeButton.backgroundColor = .white
        completeButton.layer.cornerRadius = 15
        completeButton.addTarget(self, action: #selector(completeTextField), for: .touchUpInside)
        completeButton.date = date
        completeButton.figure = settledFigure
        
        
        view.addSubview(cancelTextFieldButton)
        textWritingView.addSubview(textFieldBackgroundView)
        textFieldBackgroundView.addSubview(textField)
        textFieldBackgroundView.addSubview(dateLabel)
        textFieldBackgroundView.addSubview(completeButton)
        
        
        textField.becomeFirstResponder()
        
        textFieldBackgroundView.alpha = 0.0
        textFieldBackgroundView.fadeIn()
    }
    
    func textFieldToSVGShape() {
        
        floatingSVGViews[0].alpha = 0.0
        floatingSVGViews[1].alpha = 0.95
        textWritingView.removeFromSuperview()
    }
    
    @objc func dismissTextField(_ sender: UIButton) {
        
        textWritingView.fadeOut()
        textField.removeFromSuperview()
        textField.text = nil
        dateLabel.text = nil
        textFieldBackgroundView.removeFromSuperview()
        cancelTextFieldButton.removeFromSuperview()
        floatingSVGViews[0].zoomOutSVGShape()
    }
    
    @objc func completeTextField(_ sender: CompleteRecordButton) {
        
        
        print("saved")
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let newRecord = Record(context: context)
        
        
        if sender.date != nil { newRecord.date = sender.date }
        if sender.figure != nil { newRecord.figure = sender.figure! }
        if textField.text != nil { newRecord.text = textField.text }
        do { try context.save() } catch { print("Error saving context \(error)") }
        
        let paths = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)
        print(paths[0])
    }
}
