import UIKit

protocol MainInfoViewDelegate {
    func getInfoDateString() -> String
    func getCurrentIndex() -> Int
}

class MainInfoView: UIView {
    
    var delegate: MainInfoViewDelegate?
    let canvasTitleLabel = UILabel()
    let canvasUserLabel = UILabel()
    let canvasShapesView = UIView()
    let images = DefaultTheme.shared.instanceImageSet()

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setTitleLabelUI()
        setUserLabelUI()
        self.addSubview(canvasTitleLabel)
        self.addSubview(canvasUserLabel)
        self.addSubview(canvasShapesView)
    }
    
    private func setTitleLabelUI() {
        canvasTitleLabel.text = UserDefaults.standard.string(forKey: "canvasTitle") ?? "Canvas"
        canvasTitleLabel.font = UIFont(name: "Cardo-Bold", size: 16)
        canvasTitleLabel.textColor = UIColor(r: 72, g: 80, b: 84)
    }
    
    private func setUserLabelUI() {
        canvasUserLabel.text = UserDefaults.standard.string(forKey: "userID") ?? "User"
        canvasUserLabel.font = UIFont(name: "Cardo-Regular", size: 14)
        canvasUserLabel.textColor = UIColor(r: 103, g: 114, b: 120)
    }
    
    func setShapesView(records: [Record]) {
        for subview in canvasShapesView.subviews {
            subview.removeFromSuperview()
        }
        let recordCount = records.count
        var idx = records.count
        var count = records.count
        if recordCount > 10 {
            idx = 10
        }
        if recordCount < 10 {
            count = 10
        }
        for _ in 1 ... 10  {
            let shapeView = UIImageView()
            shapeView.frame.size = CGSize(width: canvasShapesView.frame.width * 0.1 * 0.8,
                                      height: canvasShapesView.frame.width * 0.1 * 0.8)
            shapeView.center = CGPoint(x: canvasShapesView.frame.width * (0.05 + (0.1 * CGFloat(10 - count))),
                                       y: canvasShapesView.frame.height / 2)
            if idx > 0 {
                shapeView.image = DefaultTheme.shared.getImageByGaugeLevel(gaugeLevel: Int(records[idx - 1].gaugeLevel))
                shapeView.tintColor = DefaultTheme.shared.getColorByGaugeLevel(gaugeLevel: Int(records[idx - 1].gaugeLevel))
                idx -= 1
            } else if (delegate?.getCurrentIndex() ?? 1) == 0 {
                shapeView.image = DefaultTheme.shared.getImageByGaugeLevel(gaugeLevel: Int.random(in: 1 ..< 100))
                shapeView.tintColor = .lightGray
            }
            count -= 1
            canvasShapesView.addSubview(shapeView)
        }
    }
    
    
    // 따로 해주어야 함.
    
    func setInfoViewContentSize() {
        canvasTitleLabel.frame.size = CGSize(width: canvasTitleLabel.intrinsicContentSize.width,
                                             height: self.frame.height * 0.3)
        canvasUserLabel.frame.size = CGSize(width: canvasUserLabel.intrinsicContentSize.width,
                                             height: self.frame.height * 0.2)
        canvasShapesView.frame.size = CGSize(width: self.frame.width,
                                         height: self.frame.height * 0.5)
    }
    
    func setInfoViewContentLayout() {
        canvasTitleLabel.frame.origin = CGPoint(x: .zero,
                                                y: self.frame.height * 0.0)
        canvasUserLabel.frame.origin = CGPoint(x: .zero,
                                                y: self.frame.height * 0.3)
        canvasShapesView.frame.origin = CGPoint(x: .zero,
                                            y: self.frame.height * 0.5)
    }
        
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
