import UIKit

protocol MainRecordsViewDelegate {
    func openRecordTextView(index: Int)
    func tapActionRecordView()
}

class MainRecordsView: UIView {
    var delegate: MainRecordsViewDelegate?
    private var recordViews: [UIView] = [UIView]()
    private var recordViewsCount: Int = 10
    private var recordViewSize: CGFloat = UIScreen.main.bounds.width / 10
    
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
        let gesture = UITapGestureRecognizer(target: self, action: #selector(tapRecordViewAction))
        
        self.frame.size = newSize
        self.center = newCenter
        self.backgroundColor = .clear
        self.addGestureRecognizer(gesture)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func clearRecordViews() {
        for view in recordViews {
            view.removeFromSuperview()
        }
    }
    
    func setRecordViews(records: [Record], theme: Theme) {
        var views = [UIView]()
        
        for i in 0 ..< recordViewsCount {
            if i < records.count {
                let level: Int = Int(records[i].gaugeLevel)
                let view = setRecordView(views: views, index: i)
                
                setShapeImageView(in: view,
                                  image: theme.getImageByGaugeLevel(gaugeLevel: level),
                                  color: theme.getColorByGaugeLevel(gaugeLevel: level))
                self.addSubview(view)
                views.append(view)
            } else {
                let view = setRecordView(views: views, index: i)
                
                setDefaultShapeImageView(in: view)
                self.addSubview(view)
                views.append(view)
            }
        }
        recordViews = views
    }
    
    func setRecordViewsCount(to count: Int) {
        self.recordViewsCount = count
    }
}

// MARK: - Set Record View
extension MainRecordsView {
    private func setRecordView(views: [UIView], index: Int) -> RecordView {
        let view = RecordView()
        
        view.frame.size = CGSize(width: recordViewSize, height: recordViewSize)
        view.backgroundColor = .clear
        view.index = index
        setRecordViewLocation(view: view, views: views)
        setTapGesture(view: view)
        view.transform = CGAffineTransform(rotationAngle: CGFloat.random(in: 0.0...360.0))
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
        let maxX = view.bounds.width - recordViewSize - (recordViewSize / 2)
        let maxY = view.bounds.height - recordViewSize - (recordViewSize / 2)
        let minX: CGFloat = recordViewSize / 2
        let minY: CGFloat = recordViewSize / 2
        let point = CGPoint(x: CGFloat.random(in: minX...maxX),
                            y: CGFloat.random(in: minY...maxY))
        
        return point
    }
    
    private func setShapeImageView(in view: UIView, image: UIImage?, color: UIColor) {
        let shapeImage: UIImageView = UIImageView()
        let size = view.bounds.width
        
        shapeImage.frame = CGRect(origin: .zero, size: CGSize(width: size, height: size))
        shapeImage.image = image
        shapeImage.tintColor = color
        view.addSubview(shapeImage)
    }
    
    private func setDefaultShapeImageView(in view: UIView) {
        let shapeImage: UIImageView = UIImageView()
        let size = view.bounds.width
        let index = Int.random(in: 1...10)
        let name = "default_\(index)"
        
        shapeImage.frame = CGRect(origin: .zero, size: CGSize(width: size, height: size))
        shapeImage.image = UIImage(named: name)?.withRenderingMode(.alwaysTemplate)
        shapeImage.tintColor = .systemGray
        view.addSubview(shapeImage)
    }
}

// MARK: - Set Tap Gesture
extension MainRecordsView {
    private func setTapGesture(view: UIView) {
        let gesture = UITapGestureRecognizer(target: self, action: #selector(tapAction))
        view.addGestureRecognizer(gesture)
    }
    
    @objc func tapAction(_ sender: UITapGestureRecognizer) {
        if let view: RecordView = sender.view as? RecordView {
            view.fadeOut()
            view.fadeIn()
            if let d = delegate, let idx = view.index {
                d.openRecordTextView(index: idx)
            }
        }
    }
    
    @objc func tapRecordViewAction(_ sender: UITapGestureRecognizer) {
        if let d = delegate {
            d.tapActionRecordView()
        }
    }
}

// MARK: - Record View
// 각각의 인덱스를 확인하기 위해서
class RecordView: UIView {
    var index: Int?
}
