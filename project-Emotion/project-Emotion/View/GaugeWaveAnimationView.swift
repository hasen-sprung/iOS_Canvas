
import UIKit
import WaveAnimationView
import TweenKit

protocol GaugeWaveAnimationViewDelegate {
    func sendFigureToGaugeViewController()
    func actionTouchedUpOutside()
    func actionTouchedUpOutsideInSafeArea()
    func actionTouchedInCancelArea()
    func actionTouchedOutCancelArea()
}

class GaugeWaveAnimationView: UIView {
    
    //MARK: - properties
    var cancelAreaInGaugeView: CGFloat = CGFloat(cancelAreaRatio)
    var safeAreaInGaugeView: CGFloat = CGFloat(safeAreaRatio)
    var delegate: GaugeWaveAnimationViewDelegate?
    var panGestureRecognizer: UIPanGestureRecognizer = UIPanGestureRecognizer()
    var waveView: WaveAnimationView = WaveAnimationView()
    var gradientView: UIView = UIView()
    var superviewFrame: CGRect = CGRect()
    var touchedOutLocationY: CGFloat = CGFloat() {
        didSet {
            if let delegate = delegate {
                delegate.sendFigureToGaugeViewController()
            }
        }
    }
    
    private var actionScrubber: ActionScrubber?
    private let gradientLayer: CAGradientLayer = {
        let layer = CAGradientLayer()
        return layer
    }()
    // TODO: 외부 의존성을 줄이기 위해서 싱글톤 사용안하고 테마값 적용 + willAppear에서 리셋
    private var backgroundColorTop = ThemeManager.shared.colors.gaugeColor.top {
        didSet{ updateBackgroundGradient() }
    }
    private var backgroundColorBottom = ThemeManager.shared.colors.gaugeColor.bottom {
        didSet{ updateBackgroundGradient() }
    }
    
    //MARK: - init
    override init(frame : CGRect) {
        super.init(frame: frame)
        superviewFrame = frame
        
        touchedOutLocationY = superviewFrame.height / 2
        setPanGesture()
        setWaveView(frame: frame)
        self.addSubview(waveView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - 현재 물결 위치의 값을 0 ~ 1.0 사이로 전달
    func getGaugeValue() -> Float {
        let safeAreaHeight = superviewFrame.height * safeAreaInGaugeView
        let waveViewHeight = superviewFrame.height * (1.0 - safeAreaInGaugeView)
        
        let value = (touchedOutLocationY - safeAreaHeight) / waveViewHeight
        return Float(value)
    }
    
    func initGaugeView() {
        touchedOutLocationY = superviewFrame.height / 2
        waveView.frame.origin.y = touchedOutLocationY
    }
    
}

//MARK: - Wave Animation

extension GaugeWaveAnimationView {
    
    func setWaveView(frame: CGRect) {
        let resizedFrameWithSafeArea: CGRect = CGRect(origin: frame.origin, size: CGSize(width: frame.width, height: frame.height * (1.0 - safeAreaInGaugeView)))
        
        waveView = WaveAnimationView(frame: resizedFrameWithSafeArea, frontColor: backgroundColorBottom, backColor: backgroundColorTop)
        waveView.progress = 1
        
        // MARK: - set gradient view
        waveView.addSubview(gradientView)
        gradientView.frame = CGRect(origin: CGPoint(x: 0.0, y: waveView.frame.origin.y + 20), size: waveView.frame.size)//waveView.frame
        gradientView.layer.addSublayer(gradientLayer)
        
        waveView.frame.origin.y = touchedOutLocationY
    }
    
    func startWaveAnimation() {
        waveView.startAnimation()
        setGradientAnimation()
    }
    // MARK: - 뷰가 전환될 때 애니메이션을 정지해야 메모리 누수가 발생하지 않는다.
    func stopWaveAnimation() {
        waveView.stopAnimation()
    }
    
}

//MARK: - Pan Gesture

extension GaugeWaveAnimationView {
    
    func setPanGesture() {
        panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(gaugeViewPanGesture))
        self.addGestureRecognizer(panGestureRecognizer)
    }
    
    @objc func gaugeViewPanGesture(sender: UIPanGestureRecognizer) {
        let state = sender.state
        let location = sender.location(in: self)
        let touchedPointRelativeRatio = location.y / superviewFrame.height
        
        if touchedPointRelativeRatio < cancelAreaInGaugeView  {
            if let d = delegate { d.actionTouchedInCancelArea() }
            if state == .ended {
                if let d = delegate { d.actionTouchedUpOutsideInSafeArea() }
            }
        } else if touchedPointRelativeRatio < safeAreaInGaugeView {
            if let d = delegate { d.actionTouchedOutCancelArea() }
            if state == .ended {
                if let d = delegate { d.actionTouchedUpOutside() }
            }
        } else {
            if state == .ended {
                if let d = delegate { d.actionTouchedUpOutside() }
            }
            touchedOutLocationY = location.y
            waveView.frame.origin.y = touchedOutLocationY
            actionScrubber?.update(t: Double(touchedPointRelativeRatio))
        }
    }
}

//MARK: - Gradient Layer

extension GaugeWaveAnimationView {
    
    func setGradientLayer() {
        gradientLayer.frame = gradientView.bounds
        updateBackgroundGradient()
        
        // MARK: - 현재 물결 게이지의 위치를 색깔에 맞춰서 초기화
        actionScrubber?.update(t: Double(getGaugeValue()))
    }
    
    private func updateBackgroundGradient() {
        
        gradientLayer.colors = [backgroundColorTop.cgColor, backgroundColorBottom.cgColor]
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 1)
        gradientLayer.locations = [0.0, 1.0]
        
        waveView.backColor = backgroundColorTop
        waveView.frontColor = backgroundColorBottom
        
    }
}

//MARK: - Animation

extension GaugeWaveAnimationView {
    
    // MARK: - 두 개의 그라데이션이 제스쳐의 위치에 따라 변경되는 액션을 설정해준다.
    func setGradientAnimation() {
        let action = changedBackgroundColor(topColor: backgroundColorTop,
                                            topSubColor: backgroundColorBottom,
                                            bottomColor: backgroundColorBottom,
                                            bottomSubColor: backgroundColorBottom)
        
        actionScrubber = ActionScrubber(action: action)
        initGaugeView()
    }
    
    func changedBackgroundColor(topColor: UIColor, topSubColor: UIColor, bottomColor: UIColor, bottomSubColor: UIColor) -> FiniteTimeAction {
        //scrubbable을 사용할 때는 딱 한번만 불림.
        let duration = 2.0
        // Change background color
        let changeBackgroundColorTop = InterpolationAction(from: topColor,
                                                           to: topSubColor,
                                                           duration: duration,
                                                           easing: .linear,
                                                           update: { [unowned self] in self.backgroundColorTop = $0 })
        
        let changeBackgroundColorBottom = InterpolationAction(from: bottomColor,
                                                              to: bottomSubColor,
                                                              duration: duration,
                                                              easing: .linear,
                                                              update: { [unowned self] in self.backgroundColorBottom = $0 })
        // Create group
        let group = ActionGroup(actions: changeBackgroundColorTop, changeBackgroundColorBottom)
        
        return group
    }
}
