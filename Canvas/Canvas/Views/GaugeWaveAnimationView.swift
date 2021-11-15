import UIKit

protocol GaugeWaveAnimationViewDelegate {
    func cancelGaugeView()

    func addMemo(gaugeLevel: Int)
    func changedGaugeLevel()
    func touchInCancelArea()
}
/*
 TODO: list
 - get current color
 */
class GaugeWaveAnimationView: UIView {
    var delegate: GaugeWaveAnimationViewDelegate?
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
        self.backgroundColor = bgColor
        currentGaugeLevel = 50
        setGradientLayer()
        setAnimationLayer()
        setWaveView()
        setPanGesture()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func getCurrentGaugeLevel() -> Int {
       return currentGaugeLevel
    }
}

// MARK: - Set Gradient Layer
extension GaugeWaveAnimationView {
    private func setGradientLayer() {
        gradientLayer.frame = CGRect(origin: CGPoint(x: .zero,
                                                     y: self.frame.height * 0.07),
                                     size: CGSize(width: self.frame.width,
                                                  height: self.frame.height * 0.9))
        gradientLayer.colors = defaultGradientColors.reversed()
        self.layer.addSublayer(gradientLayer)
    }
    
    private func setAnimationLayer() {
        let colors: [CGColor] = defaultChangedGColors.reversed()

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
        waveView = WaveAnimationView(frame: self.frame, color: bgColor)
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
        var touchPoint: CGFloat = (location.y - self.frame.height * 0.1) / (self.frame.height * 0.9)
        
        if touchPoint < 0.0  {
            if let d = delegate {
                d.touchInCancelArea()
            }
            if state == .ended {
                if let d = delegate { d.cancelGaugeView() }
            }
        } else if touchPoint > 1.0 {
            touchPoint = 1.0
            if state == .ended {
                if let d = delegate { d.addMemo(gaugeLevel: 100) }
            }
        } else {
            currentGaugeLevel = calculateLevel(point: touchPoint)
            if state == .ended {
                if let d = delegate { d.addMemo(gaugeLevel: currentGaugeLevel) }
            }
            waveView.frame.size.height = location.y + self.frame.height * 0.1
        }
    }
    
    private func calculateLevel(point: CGFloat) -> Int {
        let level: Int =  Int(point * 100)
        return abs(level - 100)
    }
}
