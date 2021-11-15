import UIKit

class CreateRecordView: UIView {
    
    private var CRBackgroundView: UIView!
    
    func initCreateRecordView() {
        
        self.backgroundColor = UIColor(r: 240, g: 240, b: 243)
        
        CRBackgroundView = UILabel()
        CRBackgroundView.frame.size =  CGSize(width: <#T##CGFloat#>, height: <#T##CGFloat#>)//CGRect(x: 0, y: 0, width: 314, height: 384)
        CRBackgroundView.backgroundColor = .clear
        setCRBackgroundViewShape()
        self.addSubview(CRBackgroundView)
        
    }
    
    func setCRBackgroundViewShape() {
        let shadows = UIView()
        let layer0 = CALayer()
        let layer1 = CALayer()
        let layer2 = CALayer()
        let layer3 = CALayer()
        let shadowPath0 = UIBezierPath(roundedRect: shadows.bounds, cornerRadius: 10)
        let shadowPath1 = UIBezierPath(roundedRect: shadows.bounds, cornerRadius: 10)
        let shadowPath2 = UIBezierPath(roundedRect: shadows.bounds, cornerRadius: 10)
        let shapes = UIView()
        
        shadows.frame = CRBackgroundView.frame
        shadows.clipsToBounds = false
        CRBackgroundView.addSubview(shadows)
        layer0.shadowPath = shadowPath0.cgPath
        layer0.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.06).cgColor
        layer0.shadowOpacity = 1
        layer0.shadowRadius = 36
        layer0.shadowOffset = CGSize(width: 6, height: 6)
        layer0.bounds = shadows.bounds
        layer0.position = shadows.center
        shadows.layer.addSublayer(layer0)
        layer1.shadowPath = shadowPath1.cgPath
        layer1.shadowColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1).cgColor
        layer1.shadowOpacity = 1
        layer1.shadowRadius = 13
        layer1.shadowOffset = CGSize(width: -4, height: -4)
        layer1.bounds = shadows.bounds
        layer1.position = shadows.center
        shadows.layer.addSublayer(layer1)
        layer2.shadowPath = shadowPath2.cgPath
        layer2.shadowColor = UIColor(red: 0.682, green: 0.682, blue: 0.753, alpha: 0.1).cgColor
        layer2.shadowOpacity = 1
        layer2.shadowRadius = 7
        layer2.shadowOffset = CGSize(width: 4, height: 4)
        layer2.compositingFilter = "multiplyBlendMode"
        layer2.bounds = shadows.bounds
        layer2.position = shadows.center
        shadows.layer.addSublayer(layer2)
        shapes.frame = CRBackgroundView.frame
        shapes.clipsToBounds = true
        CRBackgroundView.addSubview(shapes)
        layer3.backgroundColor = UIColor(red: 0.941, green: 0.941, blue: 0.953, alpha: 1).cgColor
        layer3.bounds = shapes.bounds
        layer3.position = shapes.center
        shapes.layer.addSublayer(layer3)
        shapes.layer.cornerRadius = 10
    }
    
}
