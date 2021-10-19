
import UIKit
import TweenKit
import Macaw

// MARK: - Delegate

protocol RecordAnimationViewDelegate {
    func openRecordTextView(index: Int)
    func tapActionRecordView()
}

// MARK: - Set Record Image, Animation, Size, Location, Rotate

class RecordAnimationView: UIView {
    
    var delegate: RecordAnimationViewDelegate?
    var recordViews: [UIView]?
    private let scheduler = ActionScheduler() //main view 애니메이션 관리자
    
    func stopAnimation() {
        clearSubviews(views: recordViews)
    }
    
    func runAnimation(records: [Record]) {
        scheduler.removeAll()
        recordViews = setAnimationAtRecordViews(records: records, randomRotate: true)
    }
    
    func reloadAnimation(records: [Record]) {
        clearSubviews(views: recordViews)
        scheduler.removeAll()
        recordViews = setAnimationAtRecordViews(records: records, randomRotate: true)
    }
    
    private func clearSubviews(views: [UIView]?) {
        if let views = views {
            for view in views {
                view.removeFromSuperview()
            }
        } else {
            print("생성된 서브뷰가 없어서 삭제할게 없습니다. = 해당 날짜에 아무런 데이터가 없어서 출력할게 없다.")
        }
    }
    
    // MARK: - set tap gesture
    private func setTapGesture(view: UIView) {
        let gesture = UITapGestureRecognizer(target: self, action: #selector(tapAction))
        view.addGestureRecognizer(gesture)
    }
    
    @objc func tapAction(_ sender: UITapGestureRecognizer) {
        if let view: RotateView = sender.view as? RotateView {
            view.fadeOut()
            view.fadeIn()
            if let d = delegate, let idx = view.recordIndex {
                d.openRecordTextView(index: idx)
            }
        }
    }
    
    @objc func tapRecordViewAction(_ sender: UITapGestureRecognizer) {
        if let d = delegate {
            d.tapActionRecordView()
        }
    }
    
    // MARK: - Record들에 적합한 사이즈와 이미지, 액션을 결정해준다
    private func setAnimationAtRecordViews(records: [Record], randomRotate: Bool) -> [UIView] {
        let theme = ThemeManager.shared.getThemeInstance()
        let gesture = UITapGestureRecognizer(target: self, action: #selector(tapRecordViewAction))
        self.addGestureRecognizer(gesture)
        
        var recordViews = [UIView]()
        
        for idx in 0 ..< records.count {
            let figure = records[idx].gaugeLevel
            
            // TODO: view의 크기는 Record가 생성된 시간에 따라 결정됨 private setRecordViewSize()
            let randCGFloat: CGFloat = CGFloat.random(in: 25.0...55.0)
            let randSize: CGSize = CGSize(width: randCGFloat, height: randCGFloat)
            
            // MARK: - Set SVG images by figure
            // TODO: figure에 따라 노드에서 적합한 이미지를 가져오는 함수가 필요함
            let svgImages = theme.instanceSVGImages()
            let newSVGView = SVGView(frame: CGRect(origin: .zero, size: randSize))
            newSVGView.backgroundColor = .clear
            newSVGView.node = theme.getNodeByFigure(figure: figure, currentNode: nil, svgNodes: svgImages)!
            let svgShape = (newSVGView.node as! Group).contents.first as! Shape
            svgShape.fill = Color(theme.getCurrentColor(figure: figure))
            
            setActionByFigure(view: newSVGView, figure: figure)
            
            // MARK: - set random location and rotate record view
            let rotateView = RotateView()
            rotateView.recordIndex = idx
            rotateView.frame.size = randSize
            setRandomLocationRecordView(view: rotateView, superView: self, recordViews: recordViews, overlapRatio: 0.5)
            setTapGesture(view: rotateView)
            
            // MARK: - random rotate
            if randomRotate {
                rotateView.transform = CGAffineTransform(rotationAngle: CGFloat.random(in: 0.0...360.0))
            }
            
            // MARK: - connect view
            rotateView.addSubview(newSVGView)
            self.addSubview(rotateView) //TODO: 현재는 메인뷰에 바로 서브뷰를 추가하지만 애니메이션 뷰에 추가하도록 수정
            recordViews.append(rotateView)
        }
        
        return recordViews
    }
    
    // MARK: - view의 랜덤 위치를 정한다 (중첩되는 부분을 관리할 수 있다.)
    
    private func setRandomLocationRecordView(view: UIView, superView: UIView, recordViews: [UIView], overlapRatio: CGFloat) {
        // TODO: 겹치는 부분에 대한 미세한 정의, 완전하게 겹치는건 안되지만 살짝 겹치는건 괜찮다.
        let maxX = superView.bounds.width
        let maxY = superView.bounds.height
        let minX: CGFloat = 0
        let minY: CGFloat = 0
        
        var isOverlap = true
        var ratio = overlapRatio
        var overlapCount = 0
        
        while isOverlap {
            view.center = CGPoint(x: CGFloat.random(in: minX...maxX), y: CGFloat.random(in: minY...maxY))
            if recordViews.count == 0 {
                break
            }
            for rv in recordViews {
                let checkViewBound = CGRect(origin: rv.frame.origin,
                                            size: CGSize(width: rv.frame.size.width * ratio,
                                                         height: rv.frame.size.height * ratio))
                if view.frame.intersects(checkViewBound) {
                    isOverlap = true
                    overlapCount += 1
                    // TODO: 더 elegant한 방법은 없을까?
                    if overlapCount > 10 {
                        ratio -= 0.1
                    }
                    break
                } else {
                    isOverlap = false
                }
            }
        }
    }
    
    // MARK: - figure에 따라 애니메이션 동작이 달라진다.
    
    private func setActionByFigure(view: UIView, figure: Float) {
        
        var action: FiniteTimeAction
        
        switch figure {
        default:
            action = moveUpDownAction(view: view, moveUpDownLen: 10, sizeMultiple: 1.2)
        }
        
        action = addDelayAction(action: action)
        scheduler.run(action: action.yoyo().repeatedForever())
    }
    
    private func addDelayAction(action: FiniteTimeAction) -> ActionSequence {
        // MARK: - delay: 액션이 실행되기전 잠깐 멈칫하는 시간을 앞 뒤 언제든 설정할 수 있음
        let delay = Double.random(in: 0.0...0.5)
        let sequence = ActionSequence(actions: DelayAction(duration: delay), action)
        
        return sequence
    }
}

// MARK: - Animation Actions
extension RecordAnimationView {
    
    private func fastMoveAction(view: UIView) -> FiniteTimeAction {
        
        let randomMoveDistanceX = CGFloat.random(in: 10...12) * CGFloat.random(in: -1...1)
        let randomMoveDistanceY = CGFloat.random(in: 10...12) * CGFloat.random(in: -1...1)
        
        let fromRect = CGRect(origin: view.center, size: view.frame.size)
        let toRect = CGRect(origin: CGPoint(x: view.center.x + randomMoveDistanceX, y: view.center.y + randomMoveDistanceY), size: view.frame.size)
        
        let duration = Double.random(in: 0.3...0.3)
        
        let action = InterpolationAction(from: fromRect, to: toRect, duration: duration, easing: .bounceIn) {
            view.frame = $0
        }
        
        return action
    }
    
    private func slowMoveAction(view: UIView) -> FiniteTimeAction {
        
        let randomMoveDistanceX = CGFloat.random(in: 20...30) * CGFloat.random(in: -1...1)
        let randomMoveDistanceY = CGFloat.random(in: 20...30) * CGFloat.random(in: -1...1)
        
        let fromRect = CGRect(origin: view.center, size: view.frame.size)
        let toRect = CGRect(origin: CGPoint(x: view.center.x + randomMoveDistanceX, y: view.center.y + randomMoveDistanceY), size: view.frame.size)
        let duration = Double.random(in: 1.5...2.0)
        
        let action = InterpolationAction(from: fromRect, to: toRect, duration: duration, easing: .linear) {
            view.frame = $0
        }
        
        return action
    }
    
    // MARK: - 크기와 위치를 조절해서 애니메이션 효과.
    
    private func moveUpDownAction(view: UIView, moveUpDownLen: CGFloat, sizeMultiple: CGFloat) -> FiniteTimeAction {
        
        let moveUpLength: CGFloat = moveUpDownLen
        let sizeUpFrame: CGFloat = sizeMultiple
        // 새로운 뷰의 가운데를 맞춰주기 위해 더 좋은 방법이 있으면 코드 수정해도 됨
        let newView = UIView(frame: CGRect(origin: view.center, size: CGSize(width: view.frame.size.width * sizeUpFrame, height: view.frame.size.height * sizeUpFrame)))
        newView.center = view.center
        
        let fromRect = CGRect(origin: view.frame.origin, size: view.frame.size)
        let toRect = CGRect(origin: CGPoint(x: newView.frame.origin.x, y: newView.frame.origin.y - moveUpLength), size: newView.frame.size)
        let duration = Double.random(in: 1.0...1.0)
        
        let action = InterpolationAction(from: fromRect, to: toRect, duration: duration, easing: .sineInOut) {
            view.frame = $0
        }
        
        return action
    }
}

class RotateView: UIView {
    var recordIndex: Int?
}
