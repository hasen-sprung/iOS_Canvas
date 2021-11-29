import UIKit

protocol MainInfoViewDelegate {
    func getInfoDateString() -> String
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
        var idx: CGFloat = 0
        for record in records {
            let shapeView = UIImageView()
            shapeView.frame.size = CGSize(width: canvasShapesView.frame.width * 0.1,
                                          height: canvasShapesView.frame.width * 0.1)
            shapeView.center = CGPoint(x: canvasShapesView.frame.width * (0.5 + (1.0 * idx)),
                                       y: canvasShapesView.frame.height / 2)
            shapeView.image = DefaultTheme.shared.getImageByGaugeLevel(gaugeLevel: Int(record.gaugeLevel))
            shapeView.tintColor = DefaultTheme.shared.getColorByGaugeLevel(gaugeLevel: Int(record.gaugeLevel))
            self.addSubview(shapeView)
            idx += 1
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
