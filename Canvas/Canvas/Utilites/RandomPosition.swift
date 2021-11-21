import UIKit

func setRecordViewLocation(view: UIView, views: [UIView], superview: UIView) {
    repeat {
        view.center = setRandomLocation(in: superview)
    } while isOverlaped(view, in: views)
}

private func isOverlaped(_ view: UIView, in views: [UIView]) -> Bool {
    for v in views {
        if view.frame.intersects(v.frame) {
            return true
        }
    }
    return false
}

private func setRandomLocation(in view: UIView) -> CGPoint {
    let width = view.bounds.width// - recordViewSize - (recordViewSize / 2)
    let height = view.bounds.height// - recordViewSize - (recordViewSize / 2)
    
    let xRatio = CGFloat.random(in: 0.1...0.9)
    let yRatio = CGFloat.random(in: 0.1...0.9)
    
    let point = CGPoint(x: xRatio * width,
                        y: yRatio * height)
    
    // TODO: save ratio
    return point
}
