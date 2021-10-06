//
//  UnderWaterSVGView.swift
//  project-Emotion
//
//  Created by Junhong Park on 2021/10/06.
//

import UIKit
import Macaw

class UnderWaterSVGView: UIView {
    
    var underWaterSVGs = [UIView]()
    var svgView = [SVGView]()
    
    func setUnderWaterSVGs() {
        
        let centerX: [CGFloat] = [0.40, 0.60, 0.45, 0.62, 0.42, 0.65]
        let centerY: [CGFloat] = [0.21, 0.36, 0.47, 0.61, 0.76, 0.98]
        
        for idx in 1...6 {
            let newView = UIView()
            let newSVGView = SVGView()
            
            let randSize: CGFloat = CGFloat.random(in: 45.0 ... 55.0)
            let randFigure: Float = Float.random(in: 0.0 ... 1.0)
            
            newView.frame.size = CGSize(width: randSize,
                                        height: randSize)
            newView.center = CGPoint(x: self.frame.width * centerX[idx - 1],
                                     y: self.frame.height * 1.5 * centerY[idx - 1])
            newView.backgroundColor = .clear
            
            CellTheme.shared.setNodes()
            newSVGView.node = CellTheme.shared.getNodeByFigure(figure: randFigure, currentNode: nil) ?? CellTheme.shared.getStartingNode()
            let fillShape = (newSVGView.node as! Group).contents.first as! Shape
            fillShape.fill = Color(CellTheme.shared.getCurrentColor(figure: randFigure))
            fillShape.stroke = Stroke(fill: Color.white, width: 3)
            
            newSVGView.frame.size = CGSize(width: newView.frame.width, height: newView.frame.height)
            newSVGView.center = CGPoint(x: newView.frame.width / 2, y: newView.frame.height / 2)
            newSVGView.backgroundColor = .clear
            
            newView.addSubview(newSVGView)
            
            svgView.append(newSVGView)
            underWaterSVGs.append(newView)
        }
    }
        
    func startUnderWaterSVGAnimation() {
        
        for idx in 0...underWaterSVGs.count - 1 {
            
            let randAngle: CGFloat = CGFloat.random(in: 0.0 ... 360.0)
            let randDuration: TimeInterval = TimeInterval.random(in: 0.5 ... 1.0)
            let randDelay: TimeInterval = TimeInterval.random(in: 0.0 ... 0.5)
            
            UIView.animate(withDuration: randDuration, delay: randDelay, options: [.repeat, .autoreverse], animations: {
                [self] in
                
                self.underWaterSVGs[idx].frame.size = CGSize(width: self.underWaterSVGs[idx].frame.width * 1.1,
                                                             height: self.underWaterSVGs[idx].frame.height * 1.2)
                self.underWaterSVGs[idx].center = CGPoint(x: self.underWaterSVGs[idx].center.x, y: self.underWaterSVGs[idx].center.y - 30)
                self.svgView[idx].frame.size = CGSize(width: self.underWaterSVGs[idx].frame.width * 1.1,
                                                      height: self.underWaterSVGs[idx].frame.height * 1.2)
                
            }) { (completed) in }
            
            underWaterSVGs[idx].transform = CGAffineTransform(rotationAngle: randAngle * CGFloat(Double.pi) / 180)
            self.addSubview(underWaterSVGs[idx])
        }
        
        
    }
}
