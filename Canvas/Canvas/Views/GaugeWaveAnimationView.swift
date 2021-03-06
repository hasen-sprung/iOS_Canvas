import UIKit

protocol GaugeWaveAnimationViewDelegate: AnyObject {
    func cancelGaugeView()
    func createRecord()
    func changedGaugeLevel()
    func touchInCancelArea()
}

class GaugeWaveAnimationView: UIView {
    weak var delegate: GaugeWaveAnimationViewDelegate?
    private var waveView: WaveAnimationView = WaveAnimationView()
    private let colorAnimation = CABasicAnimation(keyPath: "colors")
    private let gradientLayer = CAGradientLayer()
    private var panGestureRecognizer: UIPanGestureRecognizer = UIPanGestureRecognizer()
    private var currentGaugeLevel: Int = Int() {
        didSet {
            if let delegate = delegate {
                delegate.changedGaugeLevel()
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = Const.Color.background
        currentGaugeLevel = 60
        setPanGesture()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func getCurrentGaugeLevel() -> Int {
       return currentGaugeLevel
    }
    
    func setGaugeWaveView(with gradientColors: [CGColor], with animationColors: [CGColor]) {
        setGradientLayer(gradientColors: gradientColors)
        setAnimationLayer(changedColors: animationColors)
        setWaveView()
    }
}

// MARK: - Set Gradient Layer

extension GaugeWaveAnimationView {
    private func setGradientLayer(gradientColors: [CGColor]) {
        gradientLayer.frame = CGRect(origin: CGPoint(x: .zero,
                                                     y: self.frame.height * 0.07),
                                     size: CGSize(width: self.frame.width,
                                                  height: self.frame.height * 0.9))
        gradientLayer.colors = gradientColors.reversed()
        self.layer.addSublayer(gradientLayer)
    }
    
    private func setAnimationLayer(changedColors: [CGColor]) {
        let colors: [CGColor] = changedColors.reversed()

        colorAnimation.toValue = colors
        colorAnimation.duration = 1.5
        colorAnimation.autoreverses = true
        colorAnimation.repeatCount = .infinity
    }
    
    private func startLayerAnimation() {
        gradientLayer.add(colorAnimation, forKey: "colorChangeAnimation")
    }
}

// MARK: - Wave Animation View

extension GaugeWaveAnimationView {
    private func setWaveView() {
        waveView = WaveAnimationView(frame: self.frame, color: Const.Color.background)
        waveView.transform = CGAffineTransform(rotationAngle: .pi)
        waveView.progress = 0.9 // 0 ~ 0.9 Warning!
        waveView.waveDelay = 100.0
        waveView.waveHeight = 15.0
        waveView.frame.size.height = self.frame.height * (CGFloat(currentGaugeLevel) / 100)//0.2 ~ 1.0
        self.addSubview(waveView)
    }
    
    func startWaveAnimation() {
        waveView.startAnimation()
        startLayerAnimation()
    }
    
    func stopWaveAnimation() {
        waveView.stopAnimation()
    }
}

// MARK: - PanGesture

extension GaugeWaveAnimationView {
    private func setPanGesture() {
        panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(gaugeViewPanGesture))
        self.addGestureRecognizer(panGestureRecognizer)
    }
    
    @objc func gaugeViewPanGesture(sender: UIPanGestureRecognizer) {
        let state = sender.state
        let location = sender.location(in: self)
        var touchPoint: CGFloat = (location.y - self.frame.height * 0.15) / (self.frame.height * 0.85)
        guard let delegate = delegate else { return }
        var isCancelArea: Bool = false
        
        switch touchPoint {
        case ..<(-0.06):
            delegate.touchInCancelArea()
            isCancelArea = true
        case ..<0.0:
            touchPoint = 0.0
            currentGaugeLevel = calculateLevel(point: touchPoint)
        case ...1.0:
            currentGaugeLevel = calculateLevel(point: touchPoint)
            waveView.frame.size.height = location.y + self.frame.height * 0.1
        default:
            touchPoint = 1.0
        }
        if state == .ended {
            if isCancelArea {
                delegate.cancelGaugeView()
            } else {
                delegate.createRecord()
            }
        }
    }
    
    private func calculateLevel(point: CGFloat) -> Int {
        let level: Int =  Int(point * 100)
        return abs(level - 100)
    }
}
