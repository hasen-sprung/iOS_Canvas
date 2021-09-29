//
//  FloatingSVGVIew.swift
//  project-Emotion
//
//  Created by Junhong Park on 2021/09/27.
//

import UIKit
import Macaw

class FloatingSVGView: MacawView {
    
    private var nodeGroup = geometricFigure()
    
    private var nodeWidth: CGFloat = 50
    private var nodeHeight: CGFloat = 50
    private var nodeRangeX: CGFloat = 5
    private var nodeRangeY: CGFloat = -40
    private var nodeDuration: TimeInterval = 0.5
    private var nodeDelay: TimeInterval = 0.0
    
    private var currentNode: Node?
    
    private let svgView = SVGView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
    
    private var feedbackGenerator: UINotificationFeedbackGenerator?
    private var feedbackIsEnable: Bool = true
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    @objc required convenience init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func startSVGanimation(width: CGFloat,
                           height: CGFloat,
                           rangeX: CGFloat,
                           rangeY: CGFloat,
                           centerX: CGFloat,
                           centerY: CGFloat,
                           duration: TimeInterval,
                           delay: TimeInterval) {
        
        if let superview = superview {
            
            self.feedbackGenerator = UINotificationFeedbackGenerator()
            self.feedbackGenerator?.prepare()
            
            self.nodeGroup.setNodes()
            
            self.frame.size = CGSize(width: CGFloat(width), height: CGFloat(height))
            self.center = CGPoint(x: (superview.frame.width / 2) + centerX,
                                  y: (superview.frame.height / 2) + centerY)
            self.backgroundColor = .clear
            self.alpha = 0.95
            self.nodeWidth = width
            self.nodeHeight = height
            self.nodeRangeX = rangeX
            self.nodeRangeY = rangeY
            self.nodeDelay = delay
            
            setStartingSVG()
            floatingAnimation(objCenterX: (superview.frame.width / 2) + centerX,
                              objCenterY: (superview.frame.height / 2) + centerY)
        }
    }
    
    func changeSVGShape(figure: Float) {
        
        let newNode: Node!
        
        newNode = nodeGroup.getNodeByFigure(figure: figure, currentNode: currentNode)
        if newNode != nil {
            svgView.node = newNode
            currentNode = newNode
            if feedbackIsEnable == true {
                feedbackGenerator?.notificationOccurred(.success)
            }
        }
        setSVGColor(hex: 0x5f4b8b)
    }
    
    func activateFeedback() {
        self.feedbackIsEnable = true
    }
    
    func deactivateFeedback() {
        self.feedbackIsEnable = false
    }
    
    private func changeShapeFeedback() {
        self.feedbackGenerator?.notificationOccurred(.success)
    }
    
    private func setSVGColor(hex: Int) {
        
        let svgShape = (svgView.node as! Group).contents.first as! Shape
        svgShape.fill = Color(val: 0x5f4b8b)
    }
    
    private func setStartingSVG() {
        
        svgView.frame.size = CGSize(width: self.frame.width, height: self.frame.height)
        svgView.center = CGPoint(x: self.frame.width / 2, y: self.frame.width / 2)
        svgView.node = nodeGroup.getStartingNode()
        self.currentNode = svgView.node
        svgView.backgroundColor = .clear
        setSVGColor(hex: 0x5f4b8b)
        self.addSubview(svgView)
    }
    
    private func floatingAnimation(objCenterX: CGFloat, objCenterY: CGFloat) {
        
        UIView.animate(withDuration: nodeDuration, delay: nodeDelay, options: [.repeat, .autoreverse], animations: { [self] in
            self.frame.size = CGSize(width: self.nodeWidth * 1.3, height: self.nodeHeight * 1.5)
            self.svgView.frame.size = CGSize(width: self.nodeWidth * 1.3, height: self.nodeHeight * 1.5)
            self.center = CGPoint(x: objCenterX + self.nodeRangeX,
                                  y: objCenterY + self.nodeRangeY)
        }) { (completed) in }
    }
    
    
}
