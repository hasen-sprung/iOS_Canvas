
import UIKit
import Macaw
import CoreData

class GaugeViewController: UIViewController {
    
    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    private let gaugeView = GaugeWaveAnimationView(frame: UIScreen.main.bounds)
    private let floatingAreaView: UIView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
    private var floatingSVGViews = [FloatingSVGView]()
    
    private var svgTextBackgroundView: SVGTextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        // 테마 싱글톤의 기본 색상을 적용시킨다.
        Theme.shared.colors = ThemeColors()
        // MARK: - floating svg 객체들을 생성
        createFloatingSVGViews()
        // MARK: - wave를 따라다닐 view setting
        setFloatingAreaView()
        
        // MARK: - view에 subview 추가
        view.addSubview(gaugeView)
        view.addSubview(floatingAreaView)
        for idx in 1...floatingSVGViews.count {
            floatingAreaView.addSubview(floatingSVGViews[idx - 1])
        }
        
        // MARK: - Delegate 위임
        gaugeView.delegate = self
        floatingSVGViews[0].floatingSVGViewDelegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        // MARK: - Make Navigation Bar Transparent
        changeNavigationBarTransparent()
        // MARK: - Play Wave Animation
        gaugeView.startWaveAnimation()
        // MARK: - init Floating SVG and Play Animation
        initAndPlayFloatingSVGAnimation()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
    }
    override func viewWillDisappear(_ animated: Bool) {

    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        // MARK: - set Gauge color Gradient
        gaugeView.setGradientLayer()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        // MARK: - Stop wave Animation
        gaugeView.stopWaveAnimation()
    }
    
    private func changeNavigationBarTransparent() {
        
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = true
    }
    
    private func createFloatingSVGViews() {
        
        floatingSVGViews.append(FloatingSVGView(frame: CGRect(x: 0, y: 0, width: 0, height: 0)))
        floatingSVGViews.append(FloatingSVGView(frame: CGRect(x: 0, y: 0, width: 0, height: 0)))
        floatingSVGViews.append(FloatingSVGView(frame: CGRect(x: 0, y: 0, width: 0, height: 0)))
        floatingSVGViews.append(FloatingSVGView(frame: CGRect(x: 0, y: 0, width: 0, height: 0)))
    }
    
    private func initAndPlayFloatingSVGAnimation() {
        
        let svgSize: [CGFloat] = [60.0, 40.0, 50.0]
        let rangeX: [CGFloat] = [5.0, 14.0, -5.0]
        let rangeY: [CGFloat] = [-30.0, -40.0, -50.0]
        let centerX: [CGFloat] = [0.0, 150, -130]
        let centerY: [CGFloat] = [15.0, 23.0, 33.0]
        let duration: [TimeInterval] = [0.9, 0.7, 1.1]
        let delay: [TimeInterval] = [0.2, 0, 0.1]
        
        for idx in 0...(floatingSVGViews.count - 1) {
            
            if idx == 0 {
                floatingSVGViews[idx].startSVGanimation(width: svgSize[idx],
                                                        height: svgSize[idx],
                                                        rangeX: rangeX[idx],
                                                        rangeY: rangeY[idx],
                                                        centerX: centerX[idx],
                                                        centerY: centerY[idx],
                                                        duration: duration[idx],
                                                        delay: delay[idx],
                                                        isTextField: true)
                
            } else {
                floatingSVGViews[idx].startSVGanimation(width: svgSize[idx - 1],
                                                        height: svgSize[idx - 1],
                                                        rangeX: rangeX[idx - 1],
                                                        rangeY: rangeY[idx - 1],
                                                        centerX: centerX[idx - 1],
                                                        centerY: centerY[idx - 1],
                                                        duration: duration[idx - 1],
                                                        delay: delay[idx - 1])
            }
        }
    }
    
    // MARK: - [start] floating base View setting and moving
    private func setFloatingAreaView() {
        
        floatingAreaView.frame.size = CGSize(width: view.frame.width, height: view.frame.height * 0.2)
        floatingAreaView.center = CGPoint(x: view.frame.width / 2, y: view.frame.height * 0.5)
        floatingAreaView.backgroundColor = .clear
        floatingAreaView.isUserInteractionEnabled = false
    }
    
    private func setFloatingAreaView(newFigure: Float = 0.50) {
        
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
    @objc func appearTextField() {
        
        floatingSVGViews[0].changeSVGToTextField()
        floatingSVGViews[0].alpha = 0.95
        floatingSVGViews[1].alpha = 0.0
    }
    // [end] appear textField (when figure settled)
    
    private func dismissGaugeViewController() {
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.dismiss(animated: true, completion: nil)
        }
    }
}

// MARK: - GaugeWaveAnimationViewDelegate
extension GaugeViewController: GaugeWaveAnimationViewDelegate {
    
    func sendFigureToGaugeViewController() {
        
        let newFigure = gaugeView.getGaugeValue()
        setFloatingAreaView(newFigure: newFigure)
    }
    
    func actionTouchedUpOutside() {
        
        appearTextField()
    }
    
    func actionTouchedUpOutsideInSafeArea() {
        print("in safe area touched out")
    }
}

// MARK: - SVGTextViewDelegate
extension GaugeViewController: SVGTextViewDelegate {
    
    func dismissTextViewSVG() {
        
        svgTextBackgroundView.fadeOut()
        floatingSVGViews[0].zoomOutSVGShape()
    }
    
    func saveRecord(date: Date, figure: Float, text: String?) {

        let newRecord = Record(context: context)
        
        newRecord.createdDate = date
        newRecord.gaugeLevel = figure
        newRecord.memo = text
        
        (UIApplication.shared.delegate as! AppDelegate).saveContext()
        
        let paths = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)
        print(paths[0])
    }
    
    func finishGaugeEvent() {
        
        floatingSVGViews[0].minimalizeSVGShape()
        svgTextBackgroundView.fadeOut()
        self.dismissGaugeViewController()
    }
    
}

// MARK: - FloatingSVGViewDelegate
extension GaugeViewController: FloatingSVGViewDelegate {
    
    func setSVGTextView() {
        
        svgTextBackgroundView = SVGTextView()
        svgTextBackgroundView.svgTextViewDelegate = self
        
        let figure = gaugeView.getGaugeValue()
        
        svgTextBackgroundView.frame.size = CGSize(width: view.frame.width, height: view.frame.height)
        svgTextBackgroundView.center = CGPoint(x: view.frame.width / 2, y: view.frame.height / 2)
        svgTextBackgroundView.backgroundColor = UIColor(hex: CellTheme.shared.getCurrentColor(figure: figure))
        svgTextBackgroundView.alpha = 0.0
        
        view.addSubview(svgTextBackgroundView)
        svgTextBackgroundView.fadeIn(duration: 1.0)
    }
    
    func setSVGTextViewField() {
        
        let figure = gaugeView.getGaugeValue()
        
        svgTextBackgroundView.setTextViewProperties(figure: figure)
    }
    
    func textViewToFloatingSVG() {
        
        svgTextBackgroundView.removeFromSuperview()
        floatingSVGViews[0].alpha = 0.0
        floatingSVGViews[1].alpha = 0.95
    }
    
}
