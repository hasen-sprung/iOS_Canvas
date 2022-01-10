import UIKit

protocol MainInfoViewDelegate: AnyObject {
    func getLastRecord() -> Record?
    func getInfoDateString() -> String
    func getCurrentIndex() -> Int
}

class MainInfoView: UIView {
    
    weak var delegate: MainInfoViewDelegate?
//    let canvasUserLabel = UILabel()
//    let canvasShapesView = UIView()
    let lastTimeView = UILabel()
    let lastMemoView = UITextViewFixed()
    let images = DefaultTheme.shared.instanceImageSet()

    override init(frame: CGRect) {
        super.init(frame: frame)
//        setTitleLabelUI()
//        setUserLabelUI()
//        self.addSubview(canvasUserLabel)
//        self.addSubview(canvasShapesView)
        self.addSubview(lastTimeView)
        self.addSubview(lastMemoView)
    }
    
//    private func setUserLabelUI() {
//        canvasUserLabel.text = UserDefaults.shared.string(forKey: "userID") ?? "User"
//        canvasUserLabel.font = UIFont(name: "Cardo-Regular", size: 14)
//        canvasUserLabel.textColor = UIColor(r: 103, g: 114, b: 120)
//    }
    
    func setLastMemoView() {
        
        if let lastRecord = delegate?.getLastRecord() {
            lastTimeView.frame.size = CGSize(width: self.frame.width * 0.9, height: self.frame.height * 0.2)
            lastTimeView.center = CGPoint(x: self.frame.width / 2, y: self.frame.height * 1 / 9)
            lastMemoView.frame.size = CGSize(width: self.frame.width * 0.9, height: self.frame.height * 0.7)
            lastMemoView.center = CGPoint(x: self.frame.width / 2, y: self.frame.height * 5.5 / 9)
            lastTimeView.backgroundColor = .clear
            lastMemoView.backgroundColor = .clear
            lastTimeView.text = getTimeString(date: lastRecord.createdDate ?? Date())
            lastMemoView.text = lastRecord.memo ?? ""
            lastTimeView.textColor = UIColor(r: 103, g: 114, b: 120)
            lastMemoView.textColor = UIColor(r: 103, g: 114, b: 120)
            lastTimeView.font = UIFont(name: "Cardo-Regular", size: 12)
            lastMemoView.font = UIFont(name: "Pretendard-Regular", size: 13)
            lastMemoView.isEditable = false
            lastMemoView.isSelectable = false
        }
    }
    
    private func getTimeString(date: Date) -> String {
        let df = DateFormatter()
        if UserDefaults.shared.bool(forKey: "canvasMode") == true {
            df.dateFormat = "a hh:mm"
        } else {
            df.dateFormat = "M.dd. a hh:mm"
        }
        df.locale = Locale(identifier:"ko_KR")
        return df.string(from: date)
    }
    
//    func setShapesView(records: [Record]) {
//        for subview in canvasShapesView.subviews {
//            subview.removeFromSuperview()
//        }
//        let recordCount = records.count
//        var idx = records.count
//        var count = records.count
//        if recordCount > 10 {
//            idx = 10
//        }
//        if recordCount < 10 {
//            count = 10
//        }
//        for _ in 1 ... 10  {
//            let shapeView = UIImageView()
//            shapeView.frame.size = CGSize(width: canvasShapesView.frame.width * 0.1 * 0.8,
//                                      height: canvasShapesView.frame.width * 0.1 * 0.8)
//            shapeView.center = CGPoint(x: canvasShapesView.frame.width * (0.05 + (0.1 * CGFloat(10 - count))),
//                                       y: canvasShapesView.frame.height / 2)
//            if idx > 0 {
//                shapeView.image = DefaultTheme.shared.getImageByGaugeLevel(gaugeLevel: Int(records[idx - 1].gaugeLevel))
//                shapeView.tintColor = DefaultTheme.shared.getColorByGaugeLevel(gaugeLevel: Int(records[idx - 1].gaugeLevel))
//                idx -= 1
//            } else if (delegate?.getCurrentIndex() ?? 1) == 0  && UserDefaults.shared.bool(forKey: "guideAvail") == true {
//                shapeView.image = DefaultTheme.shared.getImageByGaugeLevel(gaugeLevel: Int.random(in: 1 ..< 100))
//                shapeView.tintColor = .lightGray
//            }
//            count -= 1
//            canvasShapesView.addSubview(shapeView)
//        }
//    }
    
    
    // 따로 해주어야 함.
    
//    func setInfoViewContentSize() {
//        canvasUserLabel.frame.size = CGSize(width: canvasUserLabel.intrinsicContentSize.width,
//                                             height: self.frame.height * 0.2)
//        canvasShapesView.frame.size = CGSize(width: self.frame.width,
//                                         height: self.frame.height * 0.5)
//    }
//
//    func setInfoViewContentLayout() {
//        canvasUserLabel.frame.origin = CGPoint(x: 10,
//                                               y: .zero)
//        canvasShapesView.frame.origin = CGPoint(x: .zero,
//                                            y: self.frame.height * 0.5)
//    }
        
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
