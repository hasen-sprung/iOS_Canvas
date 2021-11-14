import UIKit
import SnapKit

protocol GaugeWaveAnimationViewDelegate {
    func cancelGaugeView()
    func addMemo()
}

/*
 TODO: list
 - background color check (in dark mode)
 - get current color
 - 10 ~ 100 -> 1 ~ 100 level
 */
class GaugeWaveAnimationView: UIView {
    var delegate: GaugeWaveAnimationViewDelegate?
    
    private var waveView: WaveAnimationView = WaveAnimationView()
    private var cancelButton: UIView = UIView()
    private var shapeImage: UIImageView = UIImageView()
    
    private let bgColor = UIColor(red: 0.941, green: 0.941, blue: 0.953, alpha: 1)
    private let gradientColors: [CGColor] = [#colorLiteral(red: 0.947009027, green: 0.6707453132, blue: 0.8060829043, alpha: 1), #colorLiteral(red: 0.9500944018, green: 0.5744303465, blue: 0.5309768319, alpha: 1), #colorLiteral(red: 0.9510766864, green: 0.5234501958, blue: 0.3852519393, alpha: 1), #colorLiteral(red: 0.9529411765, green: 0.5215686275, blue: 0.3843137255, alpha: 1), #colorLiteral(red: 0.937254902, green: 0.737254902, blue: 0.5098039216, alpha: 1), #colorLiteral(red: 0.968627451, green: 0.8784313725, blue: 0.5803921569, alpha: 1), #colorLiteral(red: 0.8117647059, green: 0.862745098, blue: 0.7058823529, alpha: 1), #colorLiteral(red: 0.7019607843, green: 0.8431372549, blue: 0.7843137255, alpha: 1), #colorLiteral(red: 0.5058823529, green: 0.6862745098, blue: 0.7647058824, alpha: 1), #colorLiteral(red: 0.2549019608, green: 0.4549019608, blue: 0.662745098, alpha: 1)]
    private let changeCAColors: [CGColor] = [#colorLiteral(red: 0.9500944018, green: 0.5744303465, blue: 0.5309768319, alpha: 1), #colorLiteral(red: 0.9510766864, green: 0.5234501958, blue: 0.3852519393, alpha: 1), #colorLiteral(red: 0.9529411765, green: 0.5215686275, blue: 0.3843137255, alpha: 1), #colorLiteral(red: 0.937254902, green: 0.737254902, blue: 0.5098039216, alpha: 1), #colorLiteral(red: 0.968627451, green: 0.8784313725, blue: 0.5803921569, alpha: 1), #colorLiteral(red: 0.8117647059, green: 0.862745098, blue: 0.7058823529, alpha: 1), #colorLiteral(red: 0.7019607843, green: 0.8431372549, blue: 0.7843137255, alpha: 1), #colorLiteral(red: 0.5058823529, green: 0.6862745098, blue: 0.7647058824, alpha: 1), #colorLiteral(red: 0.2549019608, green: 0.4549019608, blue: 0.662745098, alpha: 1), #colorLiteral(red: 0.2549019608, green: 0.4549019608, blue: 0.662745098, alpha: 1)]
    private let colorAnimation = CABasicAnimation(keyPath: "colors")
    private var panGestureRecognizer: UIPanGestureRecognizer = UIPanGestureRecognizer()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = bgColor
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

// MARK: - Wave Animation View
extension GaugeWaveAnimationView {
    // MARK: - WaveAnimationView
    private func setWaveView() {
        waveView = WaveAnimationView(frame: self.frame, color: bgColor)
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
    
}

// MARK: - Cancel Button View
extension GaugeWaveAnimationView {
    private func setCancelButton() {
        let buttonSize = self.frame.width / 5
        cancelButton.backgroundColor = .white
        cancelButton.frame = CGRect(origin: .zero, size: CGSize(width: buttonSize, height: buttonSize))
        setShadows(cancelButton)
        setShapeImage()
        self.addSubview(cancelButton)
        cancelButton.snp.makeConstraints { make in
            make.top.equalTo(self.snp.top).offset(20)
            make.centerX.equalToSuperview().offset(-buttonSize / 2)
        }
    }
    private func setShadows(_ view: UIView) {
        let shadows = UIView()
        let buttonSize = self.frame.width / 5
        
        shadows.frame = view.frame
        shadows.clipsToBounds = false
        view.addSubview(shadows)
        setLayer(shadows: shadows, cornerRadius: buttonSize * 0.25, color: UIColor(red: 0, green: 0, blue: 0, alpha: 0.06), opacity: 1, radius: buttonSize / 2, size: buttonSize / 10)
        setLayer(shadows: shadows, cornerRadius: buttonSize * 0.25, color: UIColor(red: 1, green: 1, blue: 1, alpha: 1), opacity: 1, radius: buttonSize / 5, size: -buttonSize / 12)
        setLayer(shadows: shadows, cornerRadius: buttonSize * 0.25, color: UIColor(red: 0.682, green: 0.682, blue: 0.753, alpha: 0.1), opacity: 1, radius: buttonSize / 9, size: buttonSize / 12, blender: true)
        
        let shapes = UIView()
        
        shapes.frame = view.frame
        shapes.clipsToBounds = true
        view.addSubview(shapes)
        let layer = CALayer()
        layer.backgroundColor = UIColor(red: 0.941, green: 0.941, blue: 0.953, alpha: 1).cgColor
        layer.bounds = shapes.bounds
        layer.position = shapes.center
        shapes.layer.addSublayer(layer)
        shapes.layer.cornerRadius = buttonSize / 4
    }
    private func setLayer(shadows: UIView, cornerRadius: CGFloat, color: UIColor, opacity: Float, radius: CGFloat, size: CGFloat, blender: Bool = false) {
        let shadowPath = UIBezierPath(roundedRect: shadows.bounds, cornerRadius: cornerRadius)
        let layer = CALayer()
        
        layer.shadowPath = shadowPath.cgPath
        layer.shadowColor = color.cgColor
        layer.shadowOpacity = opacity
        layer.shadowRadius = radius
        layer.shadowOffset = CGSize(width: size, height: size)
        if blender == true {
            layer.compositingFilter = "multiplyBlendMode"
        }
        layer.bounds = shadows.bounds
        layer.position = shadows.center
        shadows.layer.addSublayer(layer)
    }
    private func setShapeImage() {
        let size = cancelButton.frame.width / 1.8
        shapeImage.frame = CGRect(origin: .zero,
                                  size: CGSize(width: size,
                                               height: size))
        shapeImage.center = cancelButton.center
        shapeImage.image = UIImage(named: "shape5")
        cancelButton.addSubview(shapeImage)
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
            shapeImage.image = UIImage(named: "closeBtn")
            if state == .ended {
                if let d = delegate { d.cancelGaugeView() }
            }
        } else if touchPoint > 1.0 {
            touchPoint = 1.0
            if state == .ended {
                if let d = delegate { d.addMemo() }
            }
        } else {
            changeImage(level: getCurrentGaugeLevel(point: touchPoint))
            if state == .ended {
                if let d = delegate { d.addMemo() }
            }
            waveView.frame.size.height = location.y + self.frame.height * 0.1
        }
    }
    
    private func getCurrentGaugeLevel(point: CGFloat) -> Int {
        let level: Int =  Int(point * 100)
        return abs(level - 100)
    }
    
    private func changeImage(level: Int) {
        switch level {
        case 1...10:
            shapeImage.image = UIImage(named: "shape1")
        case 11...20:
            shapeImage.image = UIImage(named: "shape2")
        case 21...30:
            shapeImage.image = UIImage(named: "shape3")
        case 31...40:
            shapeImage.image = UIImage(named: "shape4")
        case 41...50:
            shapeImage.image = UIImage(named: "shape5")
        case 51...60:
            shapeImage.image = UIImage(named: "shape6")
        case 61...70:
            shapeImage.image = UIImage(named: "shape7")
        case 71...80:
            shapeImage.image = UIImage(named: "shape8")
        case 81...90:
            shapeImage.image = UIImage(named: "shape9")
        case 91...100:
            shapeImage.image = UIImage(named: "shape10")
        default:
            print("범위를 벗어남")
        }
    }
}
