import UIKit
import SwiftUI

class RecordView: UIView {
    var index: Int? // 각각의 인덱스를 확인하기 위해서
}

protocol MainRecordsViewDelegate {
    func openRecordTextView(index: Int)
    func tapActionRecordView()
}

class MainRecordsView: UIView {
    var delegate: MainRecordsViewDelegate?
    private var recordViews: [RecordView] = [RecordView]()
    private var recordViewsCount: Int = defaultCountOfRecordInCanvas
    private var recordSize: CGFloat?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    convenience init(in superview: UIView) {
        self.init(frame: superview.frame)
        
        let ratio: CGFloat = 1
        let newSize = CGSize(width: superview.frame.width * ratio,
                             height: superview.frame.width * ratio)
        let newCenter = CGPoint(x: superview.center.x - superview.frame.origin.x,
                                y: superview.center.y - superview.frame.origin.y)
        let gesture = UITapGestureRecognizer(target: self, action: #selector(tapRecordViewAction))
        
        self.frame.size = newSize
        self.center = newCenter
        self.backgroundColor = .clear
        self.addGestureRecognizer(gesture)
        // TODO: set recordViewsCount by UserDefault
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func clearRecordViews() {
        for view in recordViews {
            view.removeFromSuperview()
        }
    }
    
    func setRecordViews(records: [Record], theme: Theme, idx: Int) {
        var views = [RecordView]()
        var width = setRecordSize(recordsCount: records.count)
        if UserDefaults.standard.bool(forKey: "guideAvail") {
            width = setRecordSize(recordsCount: defaultCountOfRecordInCanvas)
        }
        
        for i in 0 ..< recordViewsCount {
            if i < records.count {
                let view = RecordView()
                
                view.frame.size = CGSize(width: width, height: width)
                view.backgroundColor = .clear
                view.index = i
                
                setRecordViewCenter(view: view, views: views, superview: self, record: records[i])
                setShapeImageView(in: view,
                                  image: theme.getImageByGaugeLevel(gaugeLevel: Int(records[i].gaugeLevel)),
                                  color: theme.getColorByGaugeLevel(gaugeLevel: Int(records[i].gaugeLevel)))
                setTapGesture(view: view)
                self.addSubview(view)
                views.append(view)
            } else if idx == 0  && UserDefaults.standard.bool(forKey: "guideAvail") == true {
                // Default Record Views
                let view = RecordView()
                
                view.frame.size = CGSize(width: width, height: width)
                view.backgroundColor = .clear
                view.index = i
                
                setRandomCenter(view: view, views: views, superview: self, record: nil)
                let num = Int.random(in: 1...100)
                setShapeImageView(in: view,
                                  image: theme.getImageByGaugeLevel(gaugeLevel: num),
                                  color: .lightGray)
                self.addSubview(view)
                views.append(view)
            }
        }
        recordViews = views
        
        var index = 0
        for view in recordViews {
            if index < records.count {
                self.bringSubviewToFront(view)
            }
            index += 1
        }
    }
    
    func setRecordViewsCount(to count: Int) {
        self.recordViewsCount = count
    }
  
    func getRecordViews() -> [RecordView] {
        return self.recordViews
    }
    
    func getRecordSize() -> CGFloat? {
        return recordSize
    }
    private func setRecordSize(recordsCount: Int) -> CGFloat {
        var size = RecordViewRatio()
        size.ratio = CGFloat(recordsCount)
        let width: CGFloat = self.frame.width * size.ratio
        self.recordSize = width
        return width
    }
    
    func setRandomPosition(records: [Record]) {
        var views = [RecordView]()
        let width = setRecordSize(recordsCount: records.count)
        
        for i in 0..<recordViewsCount {
            if i < records.count {
                let view = RecordView()
                
                view.frame.size = CGSize(width: width, height: width)
                setRandomCenter(view: view, views: views, superview: self, record: records[i])
                views.append(view)
            }
        }
    }
}

// MARK: - Set Record View

extension MainRecordsView {
    private func setRecordViewCenter(view: RecordView, views: [RecordView], superview: UIView, record: Record) {
        if record.xRatio == 0 || record.yRatio == 0 {
            setRandomCenter(view: view, views: recordViews, superview: superview, record: record)
        } else {
            view.center = CGPoint(x: CGFloat(record.xRatio) * superview.frame.width,
                                  y: CGFloat(record.yRatio) * superview.frame.height)
        }
        if isOverlapedInRecordsView(view, in: views) {
            print("나중에 들어온 친구들이 먼저있던 애들과 중복될 경우 센터를 다시 랜덤하게 정한다.")
            setRandomCenter(view: view, views: views, superview: superview, record: record)
        }
    }
    
    // MARK: - Set Random Center
    
    private func setRandomCenter(view: RecordView, views: [RecordView], superview: UIView, record: Record?) {
        var overlapCount = 0
        
        repeat {
            print("random 좌표 찾기")
            view.center = setRandomRatio(in: superview, record: record)
            overlapCount += 1
            if overlapCount > 50 {
                print("위치 찾기가 50번을 초과")
                return
            }
        } while isOverlapedInRecordsView(view, in: views)
    }
    
    private func setRandomRatio(in view: UIView, record: Record?) -> CGPoint {
        let width = view.bounds.width
        let height = view.bounds.height
        let xRatio = CGFloat.random(in: 0.1...0.9)
        let yRatio = CGFloat.random(in: 0.1...0.9)
        let point = CGPoint(x: xRatio * width,
                            y: yRatio * height)
        
        if let record = record {
            record.xRatio = Float(xRatio)
            record.yRatio = Float(yRatio)
            CoreDataStack.shared.saveContext()
        }
        return point
    }
    
    private func isOverlapedInRecordsView(_ view: RecordView, in views: [RecordView]) -> Bool {
        let overlapRatio: CGFloat = recordViewOverlapRatio
        let target = CGRect(origin: view.frame.origin,
                            size: CGSize(width: view.frame.size.width * overlapRatio,
                                         height: view.frame.size.height * overlapRatio))
        
        for v in views {
            if target.intersects(v.frame) {
                return true
            }
        }
        return false
    }
    
    // MARK: - Set Shape and Color
    
    private func setShapeImageView(in view: UIView, image: UIImage?, color: UIColor) {
        let shapeImage: UIImageView = UIImageView()
        let size = view.bounds.width
        
        shapeImage.frame = CGRect(origin: .zero, size: CGSize(width: size, height: size))
        shapeImage.image = image
        shapeImage.tintColor = color
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
