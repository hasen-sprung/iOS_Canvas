import UIKit
import SwiftUI

class RecordView: UIView {
    var index: Int? // 각각의 인덱스를 확인하기 위해서
    var pos: Int?
}

protocol MainRecordsViewDelegate {
    func openRecordTextView(index: Int)
    func tapActionRecordView()
}

class MainRecordsView: UIView {
    var delegate: MainRecordsViewDelegate?
    private var recordViews: [RecordView] = [RecordView]()
    private var recordViewsCount: Int = defaultCountOfRecordInCanvas
    private var recordViewSize: CGFloat = UIScreen.main.bounds.width / 10
    private var positions: [Position] = [Position]()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    convenience init(in superview: UIView) {
        self.init(frame: superview.frame)
        
        let ratio: CGFloat = 6/7
        let newSize = CGSize(width: superview.frame.width * ratio,
                             height: superview.frame.width * ratio)
//                             height: superview.frame.height * ratio)
        let newCenter = CGPoint(x: superview.center.x - superview.frame.origin.x,
                                y: superview.center.y - superview.frame.origin.y)
        let gesture = UITapGestureRecognizer(target: self, action: #selector(tapRecordViewAction))
        
        self.positions = getPositionRatios()
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
    
    // TODO: 이전 데이터를 불러올 때, 위치 중복 -> Create, Delete + 10개 이상일 때, setPosition초기화;
    
    func setRecordViews(records: [Record], theme: Theme) {
        var views = [RecordView]()//[UIView]()
        
        for i in 0 ..< recordViewsCount {
            let view = RecordView()
            
            view.frame.size = CGSize(width: recordViewSize, height: recordViewSize)
            view.backgroundColor = .clear
            view.index = i
            
            if i < records.count {
                let level: Int = Int(records[i].gaugeLevel)
                
                setRecordPosition(view: view, records: records, index: i, bound: self.bounds)
                setShapeImageView(in: view,
                                  image: theme.getImageByGaugeLevel(gaugeLevel: level),
                                  color: theme.getColorByGaugeLevel(gaugeLevel: level))
            } else {
                setDefaultShapeImageView(in: view, index: i, bound: self.bounds, views)
            }
//            // Rotate Option
//            view.transform = CGAffineTransform(rotationAngle: CGFloat.random(in: 0.0...360.0))
            setTapGesture(view: view)
            self.addSubview(view)
            views.append(view)
        }
        recordViews = views
    }
    
    func setRecordViewsCount(to count: Int) {
        self.recordViewsCount = count
    }
    
    private func getPositionRatios() -> [Position] {
        let context = CoreDataStack.shared.managedObjectContext
        let request = Position.fetchRequest()
        var positions: [Position] = [Position]()
        
        do {
            positions = try context.fetch(request)
        } catch { print("context Error") }
        return positions
    }
}

// MARK: - Set Record View
extension MainRecordsView {
    // 저장된 포지션의 비율로 뷰의 위치를 놓아준다.
    private func setRecordPosition(view: RecordView, records: [Record], index: Int, bound superview: CGRect) {
        var idx: Int
        
        // record의 포지션이 nil이 아니면 가지고 있는 포지션의 인덱스의 비율과 함께 위치를 정한다.
        // and if 마지막에 들어온 친구가 동일한 좌표를 가진 경우 새로운 좌표 생성
        if let pos = records[index].setPosition, !isDuplicate(records, pos: pos, index) {
            idx = Int(truncating: pos)
        } else { // nil: 새로 생겼거나(index:0) or 기존 레코드가 삭제 후 이전 데이터들 (index:n...9)
            idx = getEmptyPosition(records: records)
            records[index].setPosition = NSNumber(value: idx)
            CoreDataStack.shared.saveContext()
        }
        view.pos = idx
        view.center = CGPoint(x: CGFloat(positions[idx].xRatio) * superview.width,
                              y: CGFloat(positions[idx].yRatio) * superview.height)
    }
    private func isDuplicate(_ records: [Record], pos: NSNumber, _ index: Int) -> Bool {
        for i in 0..<index {
            if records[i].setPosition == pos {
                return true
            }
        }
        return false
    }
    // records.setPosition의 값 중에서 중복되지 않는 친구를 찾아야한다.
    private func getEmptyPosition(records: [Record]) -> Int {
        var index = 0
        let max: Int = records.count < 10 ? records.count : 10
        var i = 0
        
        while (i < max) {
            if records[i].setPosition as! Int? == index {
                index += 1
                i = 0
            } else {
                i+=1
            }
        }
        return index
    }
    
    private func setShapeImageView(in view: UIView, image: UIImage?, color: UIColor) {
        let shapeImage: UIImageView = UIImageView()
        let size = view.bounds.width
        
        shapeImage.frame = CGRect(origin: .zero, size: CGSize(width: size, height: size))
        shapeImage.image = image
        shapeImage.tintColor = color
        view.addSubview(shapeImage)
    }
    
    private func setDefaultShapeImageView(in view: RecordView, index: Int, bound superview: CGRect, _ views: [RecordView]) {
        let shapeImage: UIImageView = UIImageView()
        let size = view.bounds.width
        let name = "default_\(index + 1)"
        let pos = getDefaultPos(views: views)
        
        shapeImage.frame = CGRect(origin: .zero, size: CGSize(width: size, height: size))
        shapeImage.image = UIImage(named: name)?.withRenderingMode(.alwaysTemplate)
        shapeImage.tintColor = .white
        view.center = CGPoint(x: CGFloat(positions[pos].xRatio) * superview.width,
                              y: CGFloat(positions[pos].yRatio) * superview.height)
        view.pos = pos
        view.addSubview(shapeImage)
    }
    
    private func getDefaultPos(views: [RecordView]) -> Int {
        var index = 0
        var i = 0
        
        while (i < views.count) {
            if views[i].pos == index {
                index += 1
                i = 0
            } else {
                i+=1
            }
        }
        return index
    }
}

// MARK: - Set Random Position

extension MainRecordsView {
    func setRandomPosition() {
        var views = [UIView]()
        
        for i in 0..<recordViewsCount {
            let view = UIView()
            
            view.frame.size = CGSize(width: recordViewSize, height: recordViewSize)
            repeatSetRandom(view: view, views: views, superview: self, index: i)
            views.append(view)
        }
    }
    
    private func repeatSetRandom(view: UIView, views: [UIView], superview: UIView, index: Int) {
        repeat {
            view.center = setRandomLocation(in: superview, index: index)
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
    
    private func setRandomLocation(in view: UIView, index: Int) -> CGPoint {
        let width = view.bounds.width// - recordViewSize - (recordViewSize / 2)
        let height = view.bounds.height// - recordViewSize - (recordViewSize / 2)
        
        let xRatio = CGFloat.random(in: 0.1...0.9)
        let yRatio = CGFloat.random(in: 0.1...0.9)
        
        let point = CGPoint(x: xRatio * width,
                            y: yRatio * height)
        
        // Save Ratio in Position
        positions[index].xRatio = Float(xRatio)
        positions[index].yRatio = Float(yRatio)
        CoreDataStack.shared.saveContext()
        return point
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
