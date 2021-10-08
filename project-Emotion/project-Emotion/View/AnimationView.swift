
import UIKit
import TweenKit

class AnimationView: UIView {
    private let scheduler = ActionScheduler()

    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func actionMoveFrame(from: CGPoint, to: CGPoint, view: UIView, size: CGSize, option: Int) {
        
        let fromRect = CGRect(origin: from, size: size)
        let toRect = CGRect(origin: to, size: size)
        let duration = 1.0
        let action = InterpolationAction(from: fromRect, to: toRect, duration: duration, easing: .exponentialInOut) {
            view.frame = $0
        }
        if option == 0 {
            scheduler.run(action: action.repeatedForever())
        } else {
            scheduler.run(action: action.yoyo())
        }
        
    }
}

