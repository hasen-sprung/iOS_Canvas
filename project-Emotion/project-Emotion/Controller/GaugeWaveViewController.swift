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
    private let svgImages = ThemeManager.shared.getThemeInstance().instanceSVGImages()
    private var currentIamge: Node?
    
    private let changeImageButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        setBackgroound()
        setChangeImageButton() // test용
        
    }

    private func setChangeImageButton() {
        
        changeImageButton.frame.size = CGSize(width: 100, height: 40)
        changeImageButton.center = CGPoint(x: view.frame.width / 2, y: view.frame.height * 0.9)
        changeImageButton.addTarget(self, action: #selector(changeImage), for: .touchUpInside)
        changeImageButton.backgroundColor = .cyan
        view.addSubview(changeImageButton)
    }
    
    var index = 3
    @objc func changeImage() {
        
        let images: [Float] = [0.1, 0.3, 0.5, 0.7, 0.9]
        
        if backgroundShapes.count > 0 {
            let newImage = theme.getNodeByFigure(figure: images[index], currentNode: nil, svgNodes: svgImages)
            setImageColor(image: newImage ?? Node(), figure: images[index])
            
            for idx in 0 ..< backgroundShapes.count {
                backgroundShapes[idx].node = newImage ?? Node()
            }
            
            index += 1
            if index > 4 {
                index = 0
            }
        }
    }
    
    private func setBackgroound() {
        
        setShapes()
    }
    
    
    private func setShapes() {
        
        let centerX: [CGFloat] = [10.0, 30.0, 50.0, 70.0, 90.0]
        let centerY: [CGFloat] = [20.0, 40.0, 60.0, 80.0]
        
        currentIamge = theme.getNodeByFigure(figure: 0.5, currentNode: nil, svgNodes: svgImages)
        
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
                newView.node = currentIamge ?? Node()
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
