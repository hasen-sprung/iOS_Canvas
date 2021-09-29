
import UIKit
import Macaw

class FloatingSVGView: MacawView {
    
    private var SVGGroup = geometricFigure()
    
    private var SVGWidth: CGFloat = 50.0
    private var SVGHeight: CGFloat = 50.0
    private var animationRangeX: CGFloat = 5.0
    private var animationRangeY: CGFloat = -40.0
    private var animationDuration: TimeInterval = 0.5
    private var animationDelay: TimeInterval = 0.0
    private var SVGCenterX: CGFloat = 0.0
    private var SVGCenterY: CGFloat = 0.0
    
    private var currentSVG: Node?
    
    private let svgView = SVGView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
    
    private var feedbackGenerator: UINotificationFeedbackGenerator?
    private var feedbackIsEnable: Bool = true
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    @objc required convenience init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func startSVGanimation(width: CGFloat,
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
            
            self.SVGGroup.setNodes()
            
            self.frame.size = CGSize(width: CGFloat(width), height: CGFloat(height))
            self.center = CGPoint(x: (superview.frame.width / 2) + centerX,
                                  y: (superview.frame.height / 2) + centerY)
            self.backgroundColor = .clear
            self.alpha = 0.95
            self.SVGWidth = width
            self.SVGHeight = height
            self.animationRangeX = rangeX
            self.animationRangeY = rangeY
            self.animationDelay = delay
            self.SVGCenterX = (superview.frame.width / 2) + centerX
            self.SVGCenterY = (superview.frame.height / 2) + centerY
            
            setStartingSVG()
            floatingAnimation(objCenterX: (superview.frame.width / 2) + centerX,
                              objCenterY: (superview.frame.height / 2) + centerY)
        }
    }
    
    func changeSVGShape(figure: Float) {
        
        let newNode: Node!
        
        newNode = SVGGroup.getNodeByFigure(figure: figure, currentNode: currentSVG)
        if newNode != nil {
            svgView.node = newNode
            currentSVG = newNode
            if feedbackIsEnable == true {
                feedbackGenerator?.notificationOccurred(.success)
            }
        }
        setSVGColor(hex: 0x5f4b8b)
    }
    
    func zoomSVGShape() {
        
    }
    
    
    func activateFeedback() {
        self.feedbackIsEnable = true
    }
    
    func deactivateFeedback() {
        self.feedbackIsEnable = false
    }
    
    private func setSVGColor(hex: Int) {
        
        let svgShape = (svgView.node as! Group).contents.first as! Shape
        svgShape.fill = Color(val: 0x5f4b8b)
    }
    
    private func setStartingSVG() {
        
        svgView.frame.size = CGSize(width: self.frame.width, height: self.frame.height)
        svgView.center = CGPoint(x: self.frame.width / 2, y: self.frame.width / 2)
        svgView.node = SVGGroup.getStartingNode()
        self.currentSVG = svgView.node
        svgView.backgroundColor = .clear
        setSVGColor(hex: 0x5f4b8b)
        self.addSubview(svgView)
    }
    
    private func floatingAnimation(objCenterX: CGFloat, objCenterY: CGFloat) {
        
        UIView.animate(withDuration: animationDuration, delay: animationDelay, options: [.repeat, .autoreverse], animations: { [self] in
            self.frame.size = CGSize(width: self.SVGWidth * 1.3, height: self.SVGHeight * 1.5)
            self.svgView.frame.size = CGSize(width: self.SVGWidth * 1.3, height: self.SVGHeight * 1.5)
            self.center = CGPoint(x: objCenterX + self.animationRangeX,
                                  y: objCenterY + self.animationRangeY)
        }) { (completed) in }
    }
}

public extension UIView {
    
    func fadeIn(duration: TimeInterval = 1.0) {
        UIView.animate(withDuration: duration, animations: {
            self.alpha = 1.0
        })
    }
    
    func fadeOut(duration: TimeInterval = 1.0) {
        UIView.animate(withDuration: duration, animations: {
            self.alpha = 0.0
        })
    }
}

extension NSObject {
    
    func copyObject<T:NSObject>() throws -> T? {
        let data = try NSKeyedArchiver.archivedData(withRootObject:self, requiringSecureCoding:false)
        return try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data) as? T
    }
}
