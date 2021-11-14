import UIKit

protocol GaugeWaveAnimationViewDelegate {
    func cancelGaugeView()
    func addMemo()
}

class GaugeWaveAnimationView: UIView {
    var delegate: GaugeWaveAnimationViewDelegate?
    
    private var waveView: WaveAnimationView = WaveAnimationView()
    private var cancelButton: UIButton = UIButton()
    
    private let gradientColors: [CGColor] = [#colorLiteral(red: 0.947009027, green: 0.6707453132, blue: 0.8060829043, alpha: 1), #colorLiteral(red: 0.9500944018, green: 0.5744303465, blue: 0.5309768319, alpha: 1), #colorLiteral(red: 0.9510766864, green: 0.5234501958, blue: 0.3852519393, alpha: 1), #colorLiteral(red: 0.9529411765, green: 0.5215686275, blue: 0.3843137255, alpha: 1), #colorLiteral(red: 0.937254902, green: 0.737254902, blue: 0.5098039216, alpha: 1), #colorLiteral(red: 0.968627451, green: 0.8784313725, blue: 0.5803921569, alpha: 1), #colorLiteral(red: 0.8117647059, green: 0.862745098, blue: 0.7058823529, alpha: 1), #colorLiteral(red: 0.7019607843, green: 0.8431372549, blue: 0.7843137255, alpha: 1), #colorLiteral(red: 0.5058823529, green: 0.6862745098, blue: 0.7647058824, alpha: 1), #colorLiteral(red: 0.2549019608, green: 0.4549019608, blue: 0.662745098, alpha: 1)]
    private let changeCAColors: [CGColor] = [#colorLiteral(red: 0.9500944018, green: 0.5744303465, blue: 0.5309768319, alpha: 1), #colorLiteral(red: 0.9510766864, green: 0.5234501958, blue: 0.3852519393, alpha: 1), #colorLiteral(red: 0.9529411765, green: 0.5215686275, blue: 0.3843137255, alpha: 1), #colorLiteral(red: 0.937254902, green: 0.737254902, blue: 0.5098039216, alpha: 1), #colorLiteral(red: 0.968627451, green: 0.8784313725, blue: 0.5803921569, alpha: 1), #colorLiteral(red: 0.8117647059, green: 0.862745098, blue: 0.7058823529, alpha: 1), #colorLiteral(red: 0.7019607843, green: 0.8431372549, blue: 0.7843137255, alpha: 1), #colorLiteral(red: 0.5058823529, green: 0.6862745098, blue: 0.7647058824, alpha: 1), #colorLiteral(red: 0.2549019608, green: 0.4549019608, blue: 0.662745098, alpha: 1), #colorLiteral(red: 0.2549019608, green: 0.4549019608, blue: 0.662745098, alpha: 1)]
    private let colorAnimation = CABasicAnimation(keyPath: "colors")
    private var panGestureRecognizer: UIPanGestureRecognizer = UIPanGestureRecognizer()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setGradientLayer()
        setWaveView()
        setCancelButton()
        setPanGesture()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setGradientLayer() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = CGRect(origin: CGPoint(x: .zero,
                                                     y: self.frame.height * 0.07),
                                     size: CGSize(width: self.frame.width,
                                                  height: self.frame.height * 0.9))
        gradientLayer.colors = gradientColors.reversed()
        self.layer.addSublayer(gradientLayer)
        
        // animation layer
        let colors: [CGColor] = changeCAColors.reversed()
        colorAnimation.toValue = colors
        colorAnimation.duration = 2
        colorAnimation.autoreverses = true
        colorAnimation.repeatCount = .infinity
        gradientLayer.add(colorAnimation, forKey: "colorChangeAnimation")
    }
}

// MARK: - Set Views
extension GaugeWaveAnimationView {
    // MARK: - WaveAnimationView
    private func setWaveView() {
        waveView = WaveAnimationView(frame: self.frame, color: .white)
        waveView.transform = CGAffineTransform(rotationAngle: .pi)
        waveView.progress = 0.9 // 0 ~ 0.9
        waveView.waveDelay = 100.0
        waveView.waveHeight = 15.0
        waveView.frame.size.height = self.frame.height * 0.5 //0.2 ~ 1.0
        self.addSubview(waveView)
    }
    func startWaveAnimation() {
        waveView.startAnimation()
    }
    func stopWaveAnimation() {
        waveView.stopAnimation()
    }
    
    // MARK: - CancelButton
    private func setCancelButton() {
        
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
        let touchPoint: CGFloat = location.y / self.frame.height
        
        if touchPoint < 0.1  {
            // TODO: change image (X)
            if state == .ended {
                if let d = delegate { d.cancelGaugeView() }
            }
        } else {
            // TODO: change image
            if state == .ended {
                if let d = delegate { d.addMemo() }
            }
            print(touchPoint * 100)
            waveView.frame.size.height = self.frame.height * touchPoint + (self.frame.height * 0.1)
        }
    }
}
