//
//  GaugeWaveViewController.swift
//  project-Emotion
//
//  Created by Junhong Park on 2021/10/29.
//

import UIKit
import Macaw

class GaugeWaveViewController: UIViewController {
    
    private var backgroundShapes = [UIView]()
    
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
        let centerY: [CGFloat] = [10.0, 30.0, 50.0, 70.0, 90.0]
        
        for y in 0 ..< centerY.count {
            
            for x in 0 ..< centerX.count {
                
                let newWidth = CGFloat.random(in: 20 ... 40)
                let newHeight = CGFloat.random(in: 20 ... 40)
                
                let newView = SVGView()
                newView.frame.size = CGSize(width: newWidth, height: newHeight)
                newView.center = CGPoint(x: getRatioLen(ratio: centerX[x], tag: 0) + getRatioLen(ratio: CGFloat.random(in: -3 ... 3), tag: 0),
                                         y: getRatioLen(ratio: centerY[y], tag: 1) + getRatioLen(ratio: CGFloat.random(in: -3 ... 3), tag: 1))
                newView.backgroundColor = .blue
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
}
