//
//  FloatingSVGVIew.swift
//  project-Emotion
//
//  Created by Junhong Park on 2021/09/27.
//

import UIKit
import Macaw

class FloatingSVGView: MacawView {
    
    private var SVGFloatNodeGroup: Group = Group()
    private var SVGFloatWidth: CGFloat = 50
    private var SVGFloatHeight: CGFloat = 50
    private var SVGFloatRangeX: CGFloat = 5
    private var SVGFloatRangeY: CGFloat = -40
    private var SVGDuration: TimeInterval = 0.5
    private var SVGDelay: TimeInterval = 0.0
    
    private var currentNode: Node?
    private var currentColor: Color?
    
    private let svgView = SVGView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
    
    private var svgNodes = [Node]()
    
    private var feedbackGenerator: UINotificationFeedbackGenerator?
        
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    @objc required convenience init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func startSVGanimation(node: Group,
                           width: CGFloat,
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
            
            self.SVGFloatNodeGroup = node
            
            svgNodes.append(self.SVGFloatNodeGroup.nodeBy(tag: "svg_1")!)
            svgNodes.append(self.SVGFloatNodeGroup.nodeBy(tag: "svg_2")!)
            svgNodes.append(self.SVGFloatNodeGroup.nodeBy(tag: "svg_3")!)
            svgNodes.append(self.SVGFloatNodeGroup.nodeBy(tag: "svg_4")!)
            svgNodes.append(self.SVGFloatNodeGroup.nodeBy(tag: "svg_5")!)
            
            
            self.frame.size = CGSize(width: CGFloat(width), height: CGFloat(height))
            self.center = CGPoint(x: (superview.frame.width / 2) + centerX,
                                  y: (superview.frame.height / 2) + centerY)
            self.backgroundColor = .clear
            self.alpha = 0.95
            self.SVGFloatWidth = width
            self.SVGFloatHeight = height
            self.SVGFloatRangeX = rangeX
            self.SVGFloatRangeY = rangeY
            self.SVGDelay = delay
            
            setStartingSVG()
            floatingAnimation(objCenterX: (superview.frame.width / 2) + centerX,
                              objCenterY: (superview.frame.height / 2) + centerY)
        }
    }
    
    private func setSVGColor(hex: Int) {
        
        let svgShape = (svgView.node as! Group).contents.first as! Shape
        svgShape.fill = Color(val: 0x5f4b8b)
    }
    
    private func setStartingSVG() {
        
        svgView.frame.size = CGSize(width: self.frame.width, height: self.frame.height)
        svgView.center = CGPoint(x: self.frame.width / 2, y: self.frame.width / 2)
        svgView.node = SVGFloatNodeGroup.nodeBy(tag: "svg_3")!
        self.currentNode = svgView.node
        svgView.backgroundColor = .clear
        setSVGColor(hex: 0x5f4b8b)
        self.addSubview(svgView)
    }
    
    private func floatingAnimation(objCenterX: CGFloat, objCenterY: CGFloat) {
        
        UIView.animate(withDuration: SVGDuration, delay: SVGDelay, options: [.repeat, .autoreverse], animations: { [self] in
            self.frame.size = CGSize(width: self.SVGFloatWidth * 1.3, height: self.SVGFloatHeight * 1.5)
            self.svgView.frame.size = CGSize(width: self.SVGFloatWidth * 1.3, height: self.SVGFloatHeight * 1.5)
            self.center = CGPoint(x: objCenterX + self.SVGFloatRangeX,
                                  y: objCenterY + self.SVGFloatRangeY)
        }) { (completed) in }
    }
    
    // MARK: - Model에 리팩토링 필요
    func changeSVGShape(figure: Float) {
        
        if let oldNode = currentNode {
            
            let newNode: Node!
            if figure <= 0.36 {
                if  oldNode != self.svgNodes[0] {
                    newNode = self.svgNodes[0]
                    changeShapeFeedback()
                } else {
                    return
                }
            } else if figure > 0.36 && figure <= 0.52 {
                if  oldNode != self.svgNodes[1] {
                    newNode = self.svgNodes[1]
                    changeShapeFeedback()
                } else {
                    return
                }
            } else if figure > 0.52 && figure <= 0.68 {
                if  oldNode != self.svgNodes[2] {
                    newNode = self.svgNodes[2]
                    changeShapeFeedback()
                } else {
                    return
                }
            } else if figure > 0.68 && figure <= 0.84 {
                if  oldNode != self.svgNodes[3] {
                    newNode = self.svgNodes[3]
                    changeShapeFeedback()
                } else {
                    return
                }
            } else {
                if  oldNode != self.svgNodes[4] {
                    newNode = self.svgNodes[4]
                    changeShapeFeedback()
                } else {
                    return
                }
            }
            svgView.node = newNode
            currentNode = newNode
            setSVGColor(hex: 0x5f4b8b)
        }
    }
    
    func changeShapeFeedback() {
        self.feedbackGenerator?.notificationOccurred(.success)
    }
}
