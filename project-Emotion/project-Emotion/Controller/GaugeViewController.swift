
import UIKit
import Macaw
import CoreData

class GaugeViewController: UIViewController {
    
    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    private let gaugeView = GaugeWaveAnimationView(frame: UIScreen.main.bounds)
    private let floatingAreaView: UIView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
    private var floatingSVGViews = [FloatingSVGView]()
    private let dismissArea = UIButton()
    private let underWaterView = UnderWaterSVGView()
    
    private var svgTextBackgroundView: SVGTextView!
    
    
    private let theme = ThemeManager.shared.getThemeInstance()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //        let backgroundImageView = UIImageView()
        //        backgroundImageView.frame = view.frame
        //        backgroundImageView.center = view.center
        //        backgroundImageView.image = UIImage(named: "simple")
        //        view.addSubview(backgroundImageView)
        
        
        // 테마 싱글톤의 기본 색상을 적용시킨다.
        //Theme.shared.colors = ThemeColors()
        // MARK: - under water view setting
        setUnderWaterView()
        // MARK: - floating svg 객체들을 생성
        createFloatingSVGViews()
        // MARK: - wave를 따라다닐 view setting
        setFloatingAreaView()
        // MARK: - dismissArea setting
        setDismissArea()
        
        // MARK: - view에 subview 추가
        view.addSubview(gaugeView)
        view.addSubview(underWaterView)
        underWaterView.setUnderWaterSVGs()
        
        view.addSubview(floatingAreaView)
        view.addSubview(dismissArea)
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
        view.backgroundColor = theme.getColor().view.gauge
        // MARK: - play underwater Animation
        underWaterView.startUnderWaterSVGAnimation()
        
        gaugeView.alpha = 0.8
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
        
        for _ in 1...2 {
            floatingSVGViews.append(FloatingSVGView(frame: CGRect(x: 0, y: 0, width: 0, height: 0)))
        }
    }
    
    private func initAndPlayFloatingSVGAnimation() {
        
        let svgSize: [CGFloat] = [65.0, 40.0, 50.0]
        let rangeX: [CGFloat] = [5.0, 14.0, -5.0]
        let rangeY: [CGFloat] = [-30.0, -40.0, -50.0]
        let centerX: [CGFloat] = [0.0, 150, -130]
        let centerY: [CGFloat] = [5.0, 23.0, 33.0]
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
    
    private func setUnderWaterView() {
        
        underWaterView.frame.size = CGSize(width: view.frame.width, height: view.frame.height * 0.8)
        underWaterView.frame.origin.x = 0.0
        underWaterView.frame.origin.y = view.frame.height * 0.2
        underWaterView.backgroundColor = .clear
        underWaterView.alpha = 1.0
        underWaterView.isUserInteractionEnabled = false
        underWaterView.clipsToBounds = true
    }
    
    // MARK: - [start] floating base View setting and moving
    private func setFloatingAreaView() {
        
        floatingAreaView.frame.size = CGSize(width: view.frame.width, height: view.frame.height * 0.2)
        floatingAreaView.center = CGPoint(x: view.frame.width / 2, y: (view.frame.height * 0.2) + (view.frame.height * 0.5) * 0.8)
        floatingAreaView.backgroundColor = .clear
        floatingAreaView.isUserInteractionEnabled = false
    }
    
    private func setFloatingAreaView(newFigure: Float = 0.50) {
        
        // 0.12초 후에 실행 (wave속도와 sync 조절용도)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.12) {
            
            let figure = newFigure
            self.floatingAreaView.frame.size = CGSize(width: self.view.frame.width, height: self.view.frame.height * 0.2)
            self.floatingAreaView.center = CGPoint(x: self.view.frame.width / 2, y: (self.view.frame.height * 0.2) + (self.view.frame.height * CGFloat(figure)) * 0.8)
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
        
        let fullHight = view.frame.size.height * 0.8
        let currentHeight = underWaterView.frame.size.height
        let newHeight = fullHight * CGFloat(1 - newFigure)
        let changedHeight = currentHeight - newHeight
        
        underWaterView.frame.size.height = currentHeight - changedHeight
        underWaterView.frame.origin.y = underWaterView.frame.origin.y + changedHeight
        underWaterView.bounds.origin.y = underWaterView.bounds.origin.y + changedHeight
        underWaterView.addRemoveSVGByFigure(figure: newFigure)
    }
    
    func actionTouchedUpOutside() {
        appearTextField()
    }
    
    func actionTouchedUpOutsideInSafeArea() {
        dismissArea.backgroundColor = .red
        self.dismissGaugeViewController()
    }
    
    func actionTouchedInCancelArea() {
        dismissArea.backgroundColor = .red
        
    }
    
    func actionTouchedOutCancelArea() {
        dismissArea.backgroundColor = .clear
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
    
    private func setDismissArea() {
        
        dismissArea.frame.size = CGSize(width: view.frame.width, height: view.frame.height * 0.1)
        dismissArea.center = CGPoint(x: view.frame.width / 2, y: view.frame.height * 0.05)
        dismissArea.backgroundColor = .clear
        dismissArea.setImage(UIImage.init(systemName: "xmark"), for: .normal)
        dismissArea.tintColor = .brown
        dismissArea.imageView?.frame.size = CGSize(width: dismissArea.frame.height / 2, height: dismissArea.frame.height / 2)
        if let imageView = dismissArea.imageView {
            imageView.center = CGPoint(x: dismissArea.frame.width / 2, y: dismissArea.frame.height + imageView.frame.height / 2)
        }
        
        dismissArea.alpha = 0.2
        dismissArea.addTarget(self, action: #selector(changeDismissAreaColor), for: .touchUpInside)
    }
    
    @objc func changeDismissAreaColor() {
        dismissArea.backgroundColor = .red
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
