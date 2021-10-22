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
    
    var theme = ThemeManager.shared.getThemeInstance()
    var themeSVGImages = [Node]()
    
    let centerX: [CGFloat] = [0.40, 0.60, 0.45, 0.62, 0.42, 0.65]
    let centerY: [CGFloat] = [0.17, 0.36, 0.49, 0.61, 0.76, 0.88]
    
    func setUnderWaterSVGs() {
        
        for idx in 1...centerX.count {
            let newView = UIView()
            let newSVGView = SVGView()
            
            let randSize: CGFloat = CGFloat.random(in: 35.0 ... 45.0)
            let randFigure: Float = Float.random(in: 0.0 ... 1.0)
            
            newView.frame.size = CGSize(width: randSize,
                                        height: randSize)
            newView.center = CGPoint(x: self.frame.width * centerX[idx - 1],
                                     y: self.frame.height * centerY[idx - 1])
            newView.backgroundColor = .clear
            newView.alpha = 1
            
            themeSVGImages = theme.instanceSVGImages()
            newSVGView.node = theme.getNodeByFigure(figure: randFigure, currentNode: nil, svgNodes: themeSVGImages) ?? Node()
            let fillShape = (newSVGView.node as! Group).contents.first as! Shape
            fillShape.fill = Color(CellTheme.shared.getCurrentColor(figure: randFigure))
            
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
            let randRange: Float = Float.random(in: 10 ... 20)
            
            UIView.animate(withDuration: randDuration, delay: randDelay, options: [.repeat, .autoreverse], animations: {
                [self] in
                
                self.underWaterSVGs[idx].frame.size = CGSize(width: self.underWaterSVGs[idx].frame.width * 1.1,
                                                             height: self.underWaterSVGs[idx].frame.height * 1.2)
                self.underWaterSVGs[idx].center = CGPoint(x: self.underWaterSVGs[idx].center.x, y: self.underWaterSVGs[idx].center.y - CGFloat(randRange))
                self.svgView[idx].frame.size = CGSize(width: self.underWaterSVGs[idx].frame.width * 1.1,
                                                      height: self.underWaterSVGs[idx].frame.height * 1.2)
                
            }) { (completed) in }
            
            underWaterSVGs[idx].transform = CGAffineTransform(rotationAngle: randAngle * CGFloat(Double.pi) / 180)
            self.addSubview(underWaterSVGs[idx])
        }
    }
    
    func addRemoveSVGByFigure(figure: Float) {
        
        
        for idx in 0...underWaterSVGs.count - 1 {
        
            if  centerY[idx]  < CGFloat(figure) + 0.1 {
                
                if underWaterSVGs[idx].alpha <= 1 && underWaterSVGs[idx].alpha >= 0.8 {
                    underWaterSVGs[idx].fadeOut(duration: 0.5)
                }
            } else {
                
                let randFigure: Float = Float.random(in: 0.0 ... 1.0)
                
                if underWaterSVGs[idx].alpha >= 0.0 && underWaterSVGs[idx].alpha <= 0.1 {
                    
                    svgView[idx].node = theme.getNodeByFigure(figure: randFigure, currentNode: nil, svgNodes: themeSVGImages) ?? theme.getNodeByFigure(figure: 0.5, currentNode: nil, svgNodes: themeSVGImages) ?? Node()
                    let fillShape = (svgView[idx].node as! Group).contents.first as! Shape
                    fillShape.fill = Color(CellTheme.shared.getCurrentColor(figure: randFigure))
                    underWaterSVGs[idx].customFadeIn(duration: 0.5)
                }
            }
        }
    }
}
