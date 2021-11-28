import UIKit

protocol MainInfoViewDelegate {
    func getInfoDateString() -> String
}

class MainInfoView: UIView {
    
    var delegate: MainInfoViewDelegate?
    let canvasTitleLabel = UILabel()
    let canvasUserLabel = UILabel()
    let howMadeLabel = UILabel()
    let canvasDateLabel = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setTitleLabelUI()
        setUserLabelUI()
        setHowMadeLabel()
        self.addSubview(canvasTitleLabel)
        self.addSubview(canvasUserLabel)
        self.addSubview(howMadeLabel)
        self.addSubview(canvasDateLabel)
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
    
    private func setHowMadeLabel() {
        howMadeLabel.text = "Emotions on Canvas"
        howMadeLabel.font = UIFont(name: "Cardo-Regular", size: 12)
        howMadeLabel.textColor = UIColor(r: 141, g: 146, b: 149)
    }
    
    // 따로 해주어야 함.
    func setDateLabel() {
        if let d = delegate {
            canvasDateLabel.text = d.getInfoDateString()
        }
        canvasDateLabel.font = UIFont(name: "Cardo-Regular", size: 12)
        canvasDateLabel.textColor = UIColor(r: 103, g: 114, b: 120)
    }
    
    func setInfoViewContentSize() {
        canvasTitleLabel.frame.size = CGSize(width: canvasTitleLabel.intrinsicContentSize.width,
                                             height: self.frame.height * 0.34)
        canvasUserLabel.frame.size = CGSize(width: canvasUserLabel.intrinsicContentSize.width,
                                             height: self.frame.height * 0.22)
        howMadeLabel.frame.size = CGSize(width: howMadeLabel.intrinsicContentSize.width,
                                             height: self.frame.height * 0.22)
        canvasDateLabel.frame.size = CGSize(width: canvasDateLabel.intrinsicContentSize.width,
                                             height: self.frame.height * 0.22)
    }
    
    func setInfoViewContentLayout() {
        canvasTitleLabel.frame.origin = CGPoint(x: .zero,
                                                y: self.frame.height * 0.0)
        canvasUserLabel.frame.origin = CGPoint(x: .zero,
                                                y: self.frame.height * 0.34)
        howMadeLabel.frame.origin = CGPoint(x: .zero,
                                                y: self.frame.height * 0.56)
        canvasDateLabel.frame.origin = CGPoint(x: .zero,
                                                y: self.frame.height * 0.78)
    }
        
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
