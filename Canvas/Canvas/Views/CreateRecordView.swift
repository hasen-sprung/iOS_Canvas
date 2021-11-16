import UIKit

protocol CreateRecordViewDelegate {
    func dismissCreateRecordView()
}

class CreateRecordView: UIView {
    var delegate: CreateRecordViewDelegate?
    
    private let CRBackgroundView =  UIView()
    private let CRBtnBackgroundView = UIImageView()
    private let CRBtnIcon = UIImageView()
    private let cancelButton = UIButton()
    private let completeButton = UIButton()
    private let CRTextView = UITextView()
    private var date = Date()
    
    func setCreateRecordView() {
        let viewSize = self.frame.width * 0.8
        
        self.backgroundColor = .clear
        date = Date()
        CRBackgroundView.frame = CGRect(x: 0, y: 0, width: viewSize, height: viewSize * 1.22)
        self.addSubview(CRBackgroundView)
        setCRBackgroundViewShape()
        setCRBackgroundViewContraints()
        setCRBackgroundViewComponents()
        CRBtnBackgroundView.isUserInteractionEnabled = true
        cancelButton.addTarget(self, action: #selector(cancelButtonPressed), for: .touchUpInside)
    }
    
    func setCRTextView() {
        CRTextView.frame.size = CGSize(width: CRBackgroundView.frame.width * 0.8,
                                       height: CRBackgroundView.frame.height * 0.6)
        CRTextView.center = CGPoint(x: CRBackgroundView.frame.width / 2,
                                    y: CRBackgroundView.frame.height / 2)
        CRTextView.backgroundColor = .clear
        CRTextView.becomeFirstResponder()
        CRBackgroundView.addSubview(CRTextView)
    }
    
    @objc func cancelButtonPressed() {
        CRTextView.endEditing(true)
        completeButton.setTitleColor(UIColor(r: 163, g: 173, b: 178), for: .normal)
        cancelButton.setTitleColor(.black, for: .normal)
        UIView.animate(withDuration: 0.5, delay: 0.0, animations: { [self] in
            CRBtnIcon.center.x = CRBackgroundView.frame.width * 0.25
        }) { (completed) in
            if let d = self.delegate {
                d.dismissCreateRecordView()
            }
        }
    }
}

// MARK: - set components
extension CreateRecordView {
    
    private func setCRBackgroundViewComponents() {
        setSeperateLine()
        setDateLabel()
        setButtonBackground()
        setBtnIcon()
        setButtons()
    }
    
    private func setSeperateLine() {
        let seperateUpperView = UIView()
        let seperateUnderView = UIView()
        
        seperateUpperView.frame.size = CGSize(width: CRBackgroundView.frame.width,
                                              height: 1)
        seperateUnderView.frame.size = seperateUpperView.frame.size
        seperateUpperView.backgroundColor = .white
        seperateUnderView.backgroundColor = UIColor(r: 195, g: 201, b: 205)
        seperateUpperView.center = CGPoint(x: CRBackgroundView.frame.width / 2,
                                           y: CRBackgroundView.frame.height / 6)
        seperateUnderView.center = CGPoint(x: CRBackgroundView.frame.width / 2,
                                           y: CRBackgroundView.frame.height / 6 + 1)
        CRBackgroundView.addSubview(seperateUpperView)
        CRBackgroundView.addSubview(seperateUnderView)
    }
    
    private func setDateLabel() {
        let dateLabel = UILabel()
        
        dateLabel.text = getDateString()
        dateLabel.textColor = .black
        dateLabel.textAlignment = .center
        dateLabel.frame.size = CGSize(width: CRBackgroundView.frame.width,
                                      height: CRBackgroundView.frame.height / 8)
        dateLabel.center = CGPoint(x: CRBackgroundView.frame.width / 2,
                                   y: CRBackgroundView.frame.height / 11)
        CRBackgroundView.addSubview(dateLabel)
    }
    
    private func getDateString() -> String {
        
        let df = DateFormatter()
        var dateString: String?
        
        df.dateFormat = "yyyy년 M월 d일 HH:mm"
        df.locale = Locale(identifier:"ko_KR")
        dateString = df.string(from: date)
        
        return dateString ?? ""
    }
    
    private func setButtonBackground() {
        CRBtnBackgroundView.frame.size = CGSize(width: CRBackgroundView.frame.height / 1.44,
                                                height: CRBackgroundView.frame.height / 7.7)
        CRBtnBackgroundView.center = CGPoint(x: CRBackgroundView.frame.width / 2,
                                             y: CRBackgroundView.frame.height * 0.9)
        CRBtnBackgroundView.backgroundColor = .clear
        CRBtnBackgroundView.image = UIImage(named: "TextBtnBackground")
        CRBackgroundView.addSubview(CRBtnBackgroundView)
    }
    
    private func setBtnIcon() {
        CRBtnIcon.frame.size = CGSize(width: CRBtnBackgroundView.frame.width / 2 * 1.2,
                                     height: CRBtnBackgroundView.frame.height * 1.3)
        CRBtnIcon.backgroundColor = .clear
        CRBtnIcon.image = UIImage(named: "TextBtn")
        CRBtnIcon.center = CGPoint(x: CRBtnBackgroundView.frame.width * 0.75,
                                  y: CRBtnBackgroundView.frame.height * 0.55)
        CRBtnBackgroundView.addSubview(CRBtnIcon)
    }
    
    private func setButtons() {
        let buttons: [UIButton : CGFloat] = [completeButton : 0.75,
                                             cancelButton : 0.28]
        
        for button in buttons {
            (button.key).frame.size = CGSize(width: CRBtnBackgroundView.frame.width / 2,
                                             height: CRBtnBackgroundView.frame.height)
            (button.key).center = CGPoint(x: CRBtnBackgroundView.frame.width * button.value,
                                          y: CRBtnBackgroundView.frame.height / 2)
            (button.key).backgroundColor = .clear
            (button.key).setTitleColor(UIColor(r: 163, g: 173, b: 178), for: .normal)
            CRBtnBackgroundView.addSubview(button.key)
        }
        cancelButton.setTitle("취소", for: .normal)
        completeButton.setTitle("완료", for: .normal)
        completeButton.setTitleColor(.black, for: .normal)
    }
}

// MARK: - set CRBackroundView UI and Constraints
extension CreateRecordView {
    
    private func setCRBackgroundViewContraints() {
        CRBackgroundView.translatesAutoresizingMaskIntoConstraints = false
        CRBackgroundView.widthAnchor.constraint(equalToConstant: self.frame.width * 0.8).isActive = true
        CRBackgroundView.heightAnchor.constraint(equalToConstant: self.frame.width * 0.8 * 1.22).isActive = true
        CRBackgroundView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 50).isActive = true
        CRBackgroundView.topAnchor.constraint(equalTo: self.topAnchor, constant: 164).isActive = true
    }
    
    private func setCRBackgroundViewShape() {
        CRBackgroundView.backgroundColor = .clear
        CRBackgroundView.layer.cornerRadius = 10
        
        let shadows = UIView()
        
        shadows.frame = CRBackgroundView.frame
        shadows.clipsToBounds = false
        CRBackgroundView.addSubview(shadows)
        
        let shadowPath0 = UIBezierPath(roundedRect: shadows.bounds, cornerRadius: 10)
        let layer0 = CALayer()
        
        layer0.shadowPath = shadowPath0.cgPath
        layer0.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.06).cgColor
        layer0.shadowOpacity = 1
        layer0.shadowRadius = 36
        layer0.shadowOffset = CGSize(width: 6, height: 6)
        layer0.bounds = shadows.bounds
        layer0.position = shadows.center
        shadows.layer.addSublayer(layer0)
        
        let shadowPath1 = UIBezierPath(roundedRect: shadows.bounds, cornerRadius: 10)
        let layer1 = CALayer()
        
        layer1.shadowPath = shadowPath1.cgPath
        layer1.shadowColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1).cgColor
        layer1.shadowOpacity = 1
        layer1.shadowRadius = 13
        layer1.shadowOffset = CGSize(width: -4, height: -4)
        layer1.bounds = shadows.bounds
        layer1.position = shadows.center
        shadows.layer.addSublayer(layer1)
        
        let shadowPath2 = UIBezierPath(roundedRect: shadows.bounds, cornerRadius: 10)
        let layer2 = CALayer()
        
        layer2.shadowPath = shadowPath2.cgPath
        layer2.shadowColor = UIColor(red: 0.682, green: 0.682, blue: 0.753, alpha: 0.1).cgColor
        layer2.shadowOpacity = 1
        layer2.shadowRadius = 7
        layer2.shadowOffset = CGSize(width: 4, height: 4)
        layer2.compositingFilter = "multiplyBlendMode"
        layer2.bounds = shadows.bounds
        layer2.position = shadows.center
        shadows.layer.addSublayer(layer2)
        
        let shapes = UIView()
        
        shapes.frame = CRBackgroundView.frame
        shapes.clipsToBounds = true
        CRBackgroundView.addSubview(shapes)
        
        let layer3 = CALayer()
        
        layer3.backgroundColor = UIColor(red: 0.941, green: 0.941, blue: 0.953, alpha: 1).cgColor
        layer3.bounds = shapes.bounds
        layer3.position = shapes.center
        shapes.layer.addSublayer(layer3)
        shapes.layer.cornerRadius = 10
    }
}
