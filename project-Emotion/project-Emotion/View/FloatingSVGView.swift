//
//  FloatingSVGVIew.swift
//  project-Emotion
//
//  Created by Junhong Park on 2021/09/27.
//

import UIKit
import Macaw

class FloatingSVGView: MacawView {

    
    var animation: Animation!
    var animations = [Animation]()
    
    
    var SVGFloatRange: CGFloat = 40

    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    @objc required convenience init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setFloatingSVGView(node: [Node], width: Float, height: Float, range: CGFloat
    ) {
        
        if let superview = superview {
            
            self.frame.size = CGSize(width: CGFloat(width), height: CGFloat(height))
            self.center = CGPoint(x: superview.frame.width / 2, y: superview.frame.height / 2)
            self.backgroundColor = .blue
            self.alpha = 0.5
            self.SVGFloatRange = range
            floatingAnimation(x: superview.frame.width / 2,
                              y: superview.frame.height / 2,
                              width: CGFloat(width),
                              height: CGFloat(height))
        }
    }
    
    private func floatingAnimation(x: CGFloat, y: CGFloat, width: CGFloat, height: CGFloat) {
        
        UIView.animate(withDuration: 0.5, delay: 0, options: [.repeat, .autoreverse] , animations: {
            self.frame.size = CGSize(width: width, height: height)
            self.center = CGPoint(x: x, y: y - self.SVGFloatRange)
        }) { (completed) in

        }
    }
}
