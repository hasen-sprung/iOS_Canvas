import UIKit

protocol MainRecordsViewDelegate {
    
}

// MARK: - 특정 프레임 안에서 n개의 뷰들을 출력해준다
class MainRecordsView: UIView {
    var delegate: MainRecordsViewDelegate?
    
    private var recordViews: [UIView] = [UIView]()
    private var recordsViewCount: Int = 10 // 아이패드에서는 더 커질 수 있음 or 커스텀 todo:getset
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    convenience init(in superview: UIView) {
        self.init(frame: superview.frame)
        
        let ratio: CGFloat = 6/7
        let newSize = CGSize(width: superview.frame.width * ratio,
                             height: superview.frame.height * ratio)
        let newCenter = CGPoint(x: superview.center.x - superview.frame.origin.x,
                                y: superview.center.y - superview.frame.origin.y)
        
        self.frame.size = newSize
        self.center = newCenter
        self.backgroundColor = .black
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func clearRecordViews() {
        for view in recordViews {
            view.removeFromSuperview()
        }
    }
    // 사용전 레코드 업데이트
    func setRecordViews(records: [Record], theme: Theme) {
        var views = [UIView]()
        
        for i in 0 ..< recordsViewCount {
            if i < records.count {
                let view = setRecordView(views: views, color: theme.getColorByGaugeLevel(gaugeLevel: Int(records[i].gaugeLevel)))
                
                self.addSubview(view)
                views.append(view)
            } else {
                let view = setRecordView(views: views)
                
                self.addSubview(view)
                views.append(view)
            }
        }
        recordViews = views
    }
    
    private func setRecordView(views: [UIView], color: UIColor = .systemGray) -> UIView {
        let view = UIView()
        let viewSize = UIScreen.main.bounds.width / 10
        
        view.frame.size = CGSize(width: viewSize, height: viewSize)
        view.backgroundColor = color
        setRecordViewLocation(view: view, views: views)
        return view
    }
    
    private func setRecordViewLocation(view: UIView, views: [UIView]) {
        repeat {
            view.frame.origin = setRandomLocation(in: self)
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
        let maxX = view.bounds.width
        let maxY = view.bounds.height
        let minX: CGFloat = 0
        let minY: CGFloat = 0
        let point = CGPoint(x: CGFloat.random(in: minX...maxX),
                            y: CGFloat.random(in: minY...maxY))
        
        return point
    }
}
