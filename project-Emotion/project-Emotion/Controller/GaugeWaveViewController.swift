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
    
    private let theme = ThemeManager.shared.getThemeInstance()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setBackgroound()
        
    }

    
    private func setBackgroound() {
        
        setShapes()
    }
    
    
    private func setShapes() {
        
        let centerX: [CGFloat] = [10.0, 30.0, 50.0, 70.0, 90.0]
        let centerY: [CGFloat] = [20.0, 40.0, 60.0, 80.0]
        let svgImages: [Node] = theme.instanceSVGImages()
        
        
        for y in 0 ..< centerY.count {
            
            for x in 0 ..< centerX.count {
                
                let newWidth = CGFloat.random(in: 20 ... 40)
                let newHeight = CGFloat.random(in: 20 ... 40)
                let randAngle: CGFloat = CGFloat.random(in: 0.0 ... 360.0)
                
                let newView = SVGView()
                newView.frame.size = CGSize(width: newWidth, height: newHeight)
                newView.center = CGPoint(x: getRatioLen(ratio: centerX[x], tag: 0) + getRatioLen(ratio: CGFloat.random(in: -3 ... 3), tag: 0),
                                         y: getRatioLen(ratio: centerY[y], tag: 1) + getRatioLen(ratio: CGFloat.random(in: -6 ... 6), tag: 1))
                newView.backgroundColor = .clear
                newView.node = theme.getNodeByFigure(figure: 0.5, currentNode: nil, svgNodes: svgImages) ?? Node()
                setImageColor(image: newView.node, figure: 0.5)
                newView.transform = CGAffineTransform(rotationAngle: randAngle * CGFloat(Double.pi) / 180)
                backgroundShapes.append(newView)
                view.addSubview(newView)
            }
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
}
