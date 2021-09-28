//
//  FloatingSVGVIew.swift
//  project-Emotion
//
//  Created by Junhong Park on 2021/09/27.
//

import UIKit
import Macaw

class FloatingSVGView: MacawView {
    
    private var SVGFloatNode: Group = Group()
    private var SVGFloatWidth: CGFloat = 50
    private var SVGFloatHeight: CGFloat = 50
    private var SVGFloatCenterX: CGFloat = 0
    private var SVGFloatCenterY: CGFloat = 0
    private var SVGFloatRangeX: CGFloat = 5
    private var SVGFloatRangeY: CGFloat = -40
    private var SVGDuration: TimeInterval = 0.5
    
    let svgView = SVGView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
    
    
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
                           duration: TimeInterval) {
        
        if let superview = superview {
            
            self.SVGFloatNode = node
            self.frame.size = CGSize(width: CGFloat(width), height: CGFloat(height))
            self.center = CGPoint(x: (superview.frame.width / 2) + centerX,
                                  y: (superview.frame.height / 2) + centerY)
            self.backgroundColor = .clear
            self.alpha = 0.8
            self.SVGFloatRangeX = rangeX
            self.SVGFloatRangeY = rangeY
            
            svgView.frame.size = CGSize(width: self.frame.width, height: self.frame.height)
            svgView.center = CGPoint(x: self.frame.width / 2, y: self.frame.width / 2)
            svgView.fileName = "svg_3"
            svgView.backgroundColor = .clear
            self.addSubview(svgView)
            
            floatingAnimation(objCenterX: (superview.frame.width / 2) + centerX,
                              objCenterY: (superview.frame.height / 2) + centerY)
            
        }
    }
    
    private func floatingAnimation(objCenterX: CGFloat, objCenterY: CGFloat) {
        
        UIView.animate(withDuration: SVGDuration, delay: 0, options: [.repeat, .autoreverse] , animations: { [self] in
            self.frame.size = CGSize(width: self.SVGFloatWidth, height: self.SVGFloatHeight)
            self.svgView.frame.size = CGSize(width: self.SVGFloatWidth, height: self.SVGFloatHeight)
            self.center = CGPoint(x: objCenterX + self.SVGFloatRangeX,
                                  y: objCenterY + self.SVGFloatRangeY)
        }) { (completed) in }
    }
    
    func changeSVGShape() {
        
        
    }
}
