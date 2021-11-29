import UIKit

class SettingTitleViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var backButton: UIButton!
    private let backButtonIcon = UIImageView()
    private let settingTitle = UILabel()
    private let placeHolder = UIImageView()
    private let textField = UITextField()
    private let completeButton = UIButton()
    private let completeButtonLabel = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(r: 240, g: 240, b: 243)
        textField.delegate = self
        setSettingTitle()
        setBackButton()
        setTextField()
        setCompleteButton()
        completeButton.addTarget(self, action: #selector(completeButtonPressed), for: .touchUpInside)
    }
    
    @objc func completeButtonPressed() {
        let finalText = textField.text?.trimmingCharacters(in: .whitespaces) ?? ""
        if finalText.count > 0 {
            UserDefaults.standard.set(finalText, forKey: "canvasTitle")
        }
        let transition = CATransition()
        transition.duration = 0.5
        transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        transition.type = CATransitionType.push
        transition.subtype = CATransitionSubtype.fromLeft
        self.view.window?.layer.add(transition, forKey: nil)
        self.dismiss(animated: false, completion: nil)
    }
    
    private func setTextField() {
        placeHolder.frame.size = CGSize(width: view.frame.width * 0.8,
                                        height: view.frame.width * 0.8 / 7)
        placeHolder.center = CGPoint(x: view.frame.width / 2, y: view.frame.height * 0.25)
        placeHolder.image = UIImage(named: "inputPlaceholder")
        view.addSubview(placeHolder)
        
        textField.font = UIFont(name: "Pretendard-Regular", size: 14)
        textField.frame.size = CGSize(width: placeHolder.frame.width * 0.8,
                                      height: placeHolder.frame.height)
        textField.center = placeHolder.center
        textField.attributedPlaceholder = NSAttributedString(
            string: UserDefaults.standard.string(forKey: "canvasTitle") ?? "",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor(r: 103, g: 114, b: 120)]
        )
        textField.textColor = UIColor(r: 72, g: 80, b: 84)
        textField.backgroundColor = .clear
        textField.becomeFirstResponder()
        view.addSubview(textField)
    }
    
    private func setCompleteButton() {
        completeButton.frame.size = CGSize(width: view.frame.width * 0.6, height: view.frame.width * 0.6 / 3)
        completeButton.center = CGPoint(x: view.frame.width / 2, y: view.frame.height * 0.4)
        completeButton.setImage(UIImage(named: "ChangeSettingBtn"), for: .normal)
        
        completeButtonLabel.frame.size = CGSize(width: completeButton.frame.width * 0.6, height: completeButton.frame.height * 0.6)
        completeButtonLabel.center = completeButton.center
        completeButtonLabel.text = "변경"
        completeButtonLabel.font = UIFont(name: "Pretendard-Regular", size: 15)
        completeButtonLabel.textAlignment = .center
        completeButtonLabel.textColor = .black
        completeButtonLabel.isUserInteractionEnabled = false
        view.addSubview(completeButton)
        view.addSubview(completeButtonLabel)
    }
    
    @objc func backButtonPressed() {
        let transition = CATransition()
        transition.duration = 0.5
        transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        transition.type = CATransitionType.push
        transition.subtype = CATransitionSubtype.fromLeft
        self.view.window?.layer.add(transition, forKey: nil)
        self.dismiss(animated: false, completion: nil)
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let MAX_LENGTH = 15
        let updatedString = ((textField.text ?? "") as NSString).replacingCharacters(in: range, with: string)
        return updatedString.count <= MAX_LENGTH
        
    }
}

extension SettingTitleViewController {
    private func setSettingTitle() {
        settingTitle.text = "작품명 변경"
        settingTitle.font = UIFont(name: "Pretendard-Bold", size: 17)
        settingTitle.textColor = UIColor(r: 72, g: 80, b: 84)
        settingTitle.frame.size = CGSize(width: settingTitle.intrinsicContentSize.width,
                                         height: view.frame.width / 10)
        settingTitle.center = CGPoint(x: view.frame.width / 2,
                                      y: view.frame.height * 0.11)
        view.addSubview(settingTitle)
    }
    
    private func setBackButton() {
        setBackButtonConstraints()
        setBackButtonUI()
        backButton.addTarget(self, action: #selector(backButtonPressed), for: .touchUpInside)
    }
    
    private func setBackButtonConstraints() {
        backButton.frame.size = CGSize(width: view.frame.width / 10,
                                       height: view.frame.width / 10)
        backButton.center = CGPoint(x: view.frame.width * 1 / 8,
                                    y: view.frame.height * 0.11)
        backButtonIcon.frame.size = CGSize(width: backButton.frame.width * 3 / 6,
                                           height: backButton.frame.width * 3 / 6)
        backButtonIcon.center = backButton.center
    }
    
    private func setBackButtonUI() {
        backButton.backgroundColor = .clear
        backButton.setImage(UIImage(named: "SmallBtnBackground"), for: .normal)
        backButtonIcon.image = UIImage(systemName: "arrow.backward")
        backButtonIcon.tintColor = UIColor(r: 163, g: 173, b: 178)
        backButtonIcon.isUserInteractionEnabled = false
        view.addSubview(backButtonIcon)
    }
}
