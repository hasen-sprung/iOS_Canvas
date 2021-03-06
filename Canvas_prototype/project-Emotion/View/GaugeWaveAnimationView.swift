
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
    
    
    var gaugeColor = UIColor(hex: 0xE8AA8F)//UIColor(hex: 0xDE68A5)
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
        super.init(coder: coder)
        superviewFrame = self.frame
        
        touchedOutLocationY = superviewFrame.height / 2
        setPanGesture()
        setWaveView(frame: self.frame)
        self.addSubview(waveView)
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - 현재 물결 위치의 값을 0 ~ 1.0 사이로 전달
    func getGaugeValue() -> Float {
        let safeAreaHeight = superviewFrame.height * safeAreaInGaugeView
        let waveViewHeight = superviewFrame.height * (1.0 - safeAreaInGaugeView)
        
        let value = (touchedOutLocationY - safeAreaHeight) / waveViewHeight
        return Float(value)
    }
    
}

//MARK: - Wave Animation

extension GaugeWaveAnimationView {
    
    func setWaveView(frame: CGRect) {
        let resizedFrameWithSafeArea: CGRect = CGRect(origin: CGPoint(x: frame.origin.x, y: frame.origin.y), size: CGSize(width: frame.width, height: frame.height * (1.0 - safeAreaInGaugeView)))
        
        
        waveView = WaveAnimationView(frame: resizedFrameWithSafeArea, frontColor: gaugeColor, backColor: gaugeColor)
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
            // MARK: - 물결뷰의 프레임을 현재 터치 위치에 맞게 움직인다
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
        
        gradientLayer.colors = [gaugeColor]
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 1)
        gradientLayer.locations = [0.0, 0.5, 1.0]
        
    }
}

//MARK: - Animation

extension GaugeWaveAnimationView {
    
    // MARK: - 두 개의 그라데이션이 제스쳐의 위치에 따라 변경되는 액션을 설정해준다.
    func setGradientAnimation() {
        
        touchedOutLocationY = superviewFrame.height / 2
        waveView.frame.origin.y = touchedOutLocationY
    }
    
    func changedBackgroundColor(topColor: UIColor, topSubColor: UIColor, bottomColor: UIColor, bottomSubColor: UIColor, middleColor: UIColor, middleSubColor: UIColor) -> FiniteTimeAction {
        //scrubbable을 사용할 때는 딱 한번만 불림.
        let duration = 2.0
        
        // MARK: - First Action: Top -> Middle
        let changeGaugeColorTop = InterpolationAction(from: topColor,
                                                           to: topSubColor,
                                                           duration: duration,
                                                           easing: .linear,
                                                           update: { [unowned self] in self.gaugeColor = $0 })
        
        let changeGaugeColorBottom = InterpolationAction(from: bottomColor,
                                                              to: bottomSubColor,
                                                              duration: duration,
                                                              easing: .linear,
                                                              update: { [unowned self] in self.gaugeColor = $0 })
        
        let changeGaugeColorMiddle = InterpolationAction(from: middleColor,
                                                              to: middleSubColor,
                                                              duration: duration,
                                                              easing: .linear,
                                                              update: { [unowned self] in self.gaugeColor = $0 })
        
        let firstAction = ActionGroup(actions: changeGaugeColorTop, changeGaugeColorBottom, changeGaugeColorMiddle)
        
        // MARK: - Second Action: middle -> bottom
        let midToBotAtTopColor = InterpolationAction(from: middleColor,
                                              to: bottomColor,
                                              duration: duration,
                                              easing: .linear,
                                              update: { [unowned self] in self.gaugeColor = $0 })
        
        let midToBotAtBottomColor = InterpolationAction(from: bottomColor,
                                                 to: bottomSubColor,
                                                 duration: duration,
                                                 easing: .linear,
                                                 update: { [unowned self] in self.gaugeColor = $0 })
        
        let secondAction = ActionGroup(actions: midToBotAtTopColor, midToBotAtBottomColor)
        
        // Sequence action
        let sequenceAction = ActionSequence(actions: firstAction, secondAction)
    
        return sequenceAction
    }
}
