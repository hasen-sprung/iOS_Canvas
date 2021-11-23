import Foundation
import UIKit

func setShadows(_ view: UIView, firstRadius: CGFloat = 2, secondRadius: CGFloat = 2, thirdRadius: CGFloat = 2) {
    let shadows = UIView()
    
    shadows.frame = view.frame
    shadows.frame.origin = .zero
    shadows.clipsToBounds = false
    shadows.isUserInteractionEnabled = false
    view.addSubview(shadows)
    
    setLayer(shadows: shadows,
             cornerRadius: firstRadius,
             color: UIColor(red: 0, green: 0, blue: 0, alpha: 0.06),
             opacity: 1,
             radius: 36,
             offset: 8)
    setLayer(shadows: shadows,
             cornerRadius: secondRadius,
             color: UIColor(red: 1, green: 1, blue: 1, alpha: 1),
             opacity: 1,
             radius: 13,
             offset: -6)
    setLayer(shadows: shadows,
             cornerRadius: thirdRadius,
             color: UIColor(red: 0.682, green: 0.682, blue: 0.753, alpha: 0.1),
             opacity: 1,
             radius: 7,
             offset: 6,
             blender: true)
    
    let shapes = UIView()
    
    shapes.frame = view.frame
    shapes.frame.origin = .zero
    shapes.clipsToBounds = true
    shapes.isUserInteractionEnabled = false
    view.addSubview(shapes)
    
    let layer = CALayer()
    
    layer.backgroundColor = UIColor(red: 0.941, green: 0.941, blue: 0.953, alpha: 1).cgColor
    layer.bounds = shapes.bounds
    layer.position = shapes.center
    layer.masksToBounds = false
    shapes.layer.addSublayer(layer)
    shapes.layer.cornerRadius = firstRadius * 0.65
}

private func setLayer(shadows: UIView, cornerRadius: CGFloat, color: UIColor, opacity: Float, radius: CGFloat, offset: CGFloat, blender: Bool = false) {
    let shadowPath = UIBezierPath(roundedRect: shadows.bounds, cornerRadius: cornerRadius)
    let layer = CALayer()
    
    layer.shadowPath = shadowPath.cgPath
    layer.shadowColor = color.cgColor
    layer.shadowOpacity = opacity
    layer.shadowRadius = radius
    layer.shadowOffset = CGSize(width: offset, height: offset)
    if blender == true {
        layer.compositingFilter = "multiplyBlendMode"
    }
    layer.bounds = shadows.bounds
    layer.position = shadows.center
    shadows.layer.addSublayer(layer)
}
