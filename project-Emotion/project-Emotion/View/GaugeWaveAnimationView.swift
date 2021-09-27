//
//  GaugeWaveAnimationView.swift
//  emo-proto
//
//  Created by Jaeyoung Lee on 2021/09/23.
//

import UIKit
import WaveAnimationView
import TweenKit

class GaugeWaveAnimationView: UIView {
    
    //MARK: - properties
    var panGestureRecognizer: UIPanGestureRecognizer = UIPanGestureRecognizer()
    var waveView: WaveAnimationView = WaveAnimationView()
    var superviewFrame: CGRect = CGRect()
    var touchedOutLocationY: CGFloat = CGFloat()
    
    private var actionScrubber: ActionScrubber?
    private let gradientLayer: CAGradientLayer = {
        let layer = CAGradientLayer()
        return layer
    }()
    private var backgroundColorTop = defaultBackgroundColorTop {
        didSet{ updateBackgroundGradient() }
    }
    private var backgroundColorBottom = defaultBackgroundColorBottom {
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
    
    func getGaugeValue() -> Float {
        let value = touchedOutLocationY / superviewFrame.height
        
        return Float(value)
    }
    
}

//MARK: - Wave Animation

extension GaugeWaveAnimationView {
    
    func setWaveView(frame: CGRect) {
        waveView = WaveAnimationView(frame: frame, frontColor: defaultBackgroundColorBottom, backColor: defaultBackgroundColorTop)
        waveView.progress = Float(touchedOutLocationY / superviewFrame.height)
        
        waveView.layer.addSublayer(gradientLayer)
    }
    func startWaveAnimation() {
        waveView.startAnimation()
        setGradientAnimation()
    }
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
        let state = sender.state.rawValue
        let location = sender.location(in: self)
        let gaugeMaxOneValue = location.y / superviewFrame.height
        // TODO: 화면 전체로 설정할 경우 다시 내리기가 불가능하므로 safeArea설정
        touchedOutLocationY = location.y
        if state == 3 {
            let value = getGaugeValue()
            print("Now Gauge Value : ", value)
        }
        waveView.progress = Float(1 - gaugeMaxOneValue)
        actionScrubber?.update(t: Double(gaugeMaxOneValue))
    }
}

//MARK: - Gradient Layer

extension GaugeWaveAnimationView {
    
    func setGradientLayer() {
        gradientLayer.frame = waveView.bounds
        updateBackgroundGradient()
    }
    
    private func updateBackgroundGradient() {
        
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        
        gradientLayer.colors = [backgroundColorTop.cgColor, backgroundColorBottom.cgColor]
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 1)
        gradientLayer.locations = [0.0, 1.0]
        gradientLayer.frame.origin.y = touchedOutLocationY + 20
        
        waveView.backColor = backgroundColorTop
        waveView.frontColor = backgroundColorBottom
        
        CATransaction.commit()
        
    }
}

//MARK: - Animation

extension GaugeWaveAnimationView {
    
    func setGradientAnimation() {
        let action = changedBackgroundColor()
        
        actionScrubber = ActionScrubber(action: action)
    }
    
    func changedBackgroundColor() -> FiniteTimeAction {
        //scrubbable을 사용할 때는 딱 한번만 불림.
        let duration = 2.0
        // Change background color
        let changeBackgroundColorTop = InterpolationAction(from: defaultBackgroundColorTop,
                                                           to: sampleBlueTop,
                                                           duration: duration,
                                                           easing: .linear,
                                                           update: { [unowned self] in self.backgroundColorTop = $0 })
        
        let changeBackgroundColorBottom = InterpolationAction(from: defaultBackgroundColorBottom,
                                                              to: sampleBlueBottom,
                                                              duration: duration,
                                                              easing: .linear,
                                                              update: { [unowned self] in self.backgroundColorBottom = $0 })
        // Create group
        let group = ActionGroup(actions: changeBackgroundColorTop, changeBackgroundColorBottom)
        
        return group
    }
}
