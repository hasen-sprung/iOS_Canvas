//
//  GaugeWaveViewController.swift
//  project-Emotion
//
//  Created by Junhong Park on 2021/10/29.
//

import UIKit
import Macaw

class GaugeWaveViewController: UIViewController {
    
    private var backgroundShapes = [SVGView]()
    private let gaugeView = GaugeWaveAnimationView(frame: UIScreen.main.bounds)
    
    private let theme = ThemeManager.shared.getThemeInstance()
    private let svgImages = ThemeManager.shared.getThemeInstance().instanceSVGImages()
    private var currentImage: [Node]?
    
    private var animationEndTag: [Bool]?
    private var feedbackGenerator: UINotificationFeedbackGenerator?
    
    @IBOutlet weak var dismissButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.feedbackGenerator = UINotificationFeedbackGenerator()
        self.feedbackGenerator?.prepare()
        
        gaugeView.delegate = self
        view.backgroundColor = UIColor(hex: 0xFAEBD7)
        setDismissButton()
        setBackground()
        view.addSubview(gaugeView)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        gaugeView.startWaveAnimation()
    }
    
    
    private func changeImage(figure: Float) {
        
        let ignoreAnimationImage = theme.getNodeByFigure(figure: 0.9, currentNode: nil, svgNodes: svgImages)
        
        if backgroundShapes.count > 0 {
            
            for idx in 0 ..< backgroundShapes.count {
                if let newImage = theme.getNodeByFigure(figure: figure, currentNode: currentImage?[idx], svgNodes: svgImages) {
                    setImageColor(image: newImage, figure: figure)
                    
                    if animationEndTag?[idx] == true {
                        if currentImage?[idx] != ignoreAnimationImage && newImage != ignoreAnimationImage {
                            
                            animationEndTag?[idx] = false
                            self.currentImage?[idx] = newImage
                            let rootGroup = [backgroundShapes[idx].node].group()
                            backgroundShapes[idx].node = rootGroup
                            let animation = rootGroup.contentsVar.animation(to: [newImage], during: 0.2).onComplete {
                                self.animationEndTag?[idx] = true
                                self.backgroundShapes[idx].node = newImage
                            }
                            animation.play()
                        } else {
                            self.currentImage?[idx] = newImage
                            self.backgroundShapes[idx].node = newImage
                        }
                    }
                    if idx == 0 {
                        feedbackGenerator?.notificationOccurred(.success)
                    }
                    
                }
            }
        }
    }
    
    private func setBackground() {
        
        let centerX: [CGFloat] = [10.0, 30.0, 50.0, 70.0, 90.0]
        let centerY: [CGFloat] = [20.0, 40.0, 60.0, 80.0]
        
        setShapes(centerX: centerX, centerY: centerY)
        setAnimationEndTag(centerX: centerX, centerY: centerY)
    }
    
    
    private func setShapes(centerX: [CGFloat], centerY: [CGFloat]) {
        
        currentImage = [Node]()
        
        for _ in 0 ..< (centerX.count * centerY.count) {
            
            currentImage?.append(theme.getNodeByFigure(figure: gaugeView.getGaugeValue(), currentNode: nil, svgNodes: svgImages) ?? Node())
        }
        
        for y in 0 ..< centerY.count {
            
            for x in 0 ..< centerX.count {
                
                let newWidth = CGFloat.random(in: 20 ... 40)
                let newHeight = CGFloat.random(in: 20 ... 40)
                let randAngle: CGFloat = CGFloat.random(in: 0.0 ... 360.0)
                
                let newView = SVGView()
                newView.frame.size = CGSize(width: newWidth, height: newHeight)
                newView.center = CGPoint(x: getRatioLen(ratio: centerX[x], tag: 0),
                                         y: getRatioLen(ratio: centerY[y], tag: 1))
                //                newView.center = CGPoint(x: getRatioLen(ratio: centerX[x], tag: 0) + getRatioLen(ratio: CGFloat.random(in: -3 ... 3), tag: 0),
                //                                         y: getRatioLen(ratio: centerY[y], tag: 1) + getRatioLen(ratio: CGFloat.random(in: -6 ... 6), tag: 1))
                newView.backgroundColor = .clear
                newView.node = currentImage?[y * centerX.count + x] ?? Node()
                setImageColor(image: newView.node, figure: 0.5)
                newView.transform = CGAffineTransform(rotationAngle: randAngle * CGFloat(Double.pi) / 180)
                backgroundShapes.append(newView)
                view.addSubview(newView)
            }
        }
    }
    
    private func setAnimationEndTag(centerX: [CGFloat], centerY: [CGFloat]) {
        
        animationEndTag = [Bool]()
        for _ in 0 ..< (centerX.count * centerY.count) {
            animationEndTag?.append(true)
        }
    }
    
    private func getRatioLen(ratio: CGFloat, tag: Int) -> CGFloat {
        
        if tag == 0 {
            return (view.frame.width * ratio) / 100
        } else {
            return (view.frame.height * ratio) / 100
        }
    }
    
    private func setImageColor(image: Node, figure: Float) {
        
        let fillShape = (image as! Group).contents.first as! Shape
        fillShape.fill = Color(theme.getCurrentColor(figure: figure))
    }
    
    private func setDismissButton() {
        
        dismissButton.backgroundColor = .clear
        dismissButton.setTitle("", for: .normal)
        dismissButton.alpha = 0.6
    }
    
    private func dismissGaugeViewController() {
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.dismiss(animated: true, completion: nil)
        }
    }
}

extension GaugeWaveViewController: GaugeWaveAnimationViewDelegate {
    
    func sendFigureToGaugeViewController() {
        
        let newFigure = gaugeView.getGaugeValue()
        changeImage(figure: newFigure)
        
    }
    
    func actionTouchedUpOutside() {
        
    }
    
    func actionTouchedUpOutsideInSafeArea() {
        
        dismissButton.backgroundColor = UIColor(hex: 0xDE68A5)
        dismissGaugeViewController()
    }
    
    func actionTouchedInCancelArea() {
        
        dismissButton.backgroundColor = UIColor(hex: 0xDE68A5)
    }
    
    func actionTouchedOutCancelArea() {
        
        dismissButton.backgroundColor = .clear
    }
}
