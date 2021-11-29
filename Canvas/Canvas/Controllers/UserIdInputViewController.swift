import UIKit

class UserIdInputViewController: UIViewController, UITextFieldDelegate {

    private let settingTitle = UILabel()
    private let placeHolder = UIImageView()
    private let textField = UITextField()
    private let completeButton = UIButton()
    private let completeButtonLabel = UILabel()
    private let byteView = UILabel()
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .black
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(r: 240, g: 240, b: 243)
        textField.delegate = self
        setSettingTitle()
        setTextField()
        setCompleteButton()
        completeButton.addTarget(self, action: #selector(completeButtonPressed), for: .touchUpInside)
        textField.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: UIControl.Event.editingChanged)
    }
    
    @objc func textFieldDidChange(textField : UITextField){
        self.byteView.text = "\(self.textField.text!.count)/"+"\(15)"
      }
    
    @objc func completeButtonPressed() {
        let finalText = textField.text?.trimmingCharacters(in: .whitespaces) ?? ""
        if finalText.count > 0 {
            UserDefaults.standard.set(finalText, forKey: "userID")
        } else {
            UserDefaults.standard.set("무명작가", forKey: "userID")
        }
        UserDefaults.standard.set(true, forKey: "userIDsetting")
        guard let nextVC = self.storyboard?.instantiateViewController(identifier: "mainViewController") as? MainViewController else { return }
        transitionVc(vc: nextVC, duration: 0.5, type: .fromTop)
    }
    
    private func setTextField() {
        placeHolder.frame.size = CGSize(width: view.frame.width * 0.8,
                                        height: view.frame.width * 0.8 / 7)
        placeHolder.center = CGPoint(x: view.frame.width / 2, y: view.frame.height * 0.35)
        placeHolder.image = UIImage(named: "inputPlaceholder")
        view.addSubview(placeHolder)
        
        textField.frame.size = CGSize(width: placeHolder.frame.width * 0.8,
                                      height: placeHolder.frame.height)
        textField.center = placeHolder.center
        textField.textColor = UIColor(r: 72, g: 80, b: 84)
        textField.backgroundColor = .clear
        textField.becomeFirstResponder()
        view.addSubview(textField)
        byteView.frame = textField.frame
        byteView.text = "0/15"
        byteView.font = UIFont(name: "Cardo-Regular", size: 13)
        byteView.textColor = .lightGray
        byteView.textAlignment = .right
        view.addSubview(byteView)
    }
    
    private func setCompleteButton() {
        completeButton.frame.size = CGSize(width: view.frame.width * 0.6, height: view.frame.width * 0.6 / 3)
        completeButton.center = CGPoint(x: view.frame.width / 2, y: view.frame.height * 0.5)
        completeButton.setImage(UIImage(named: "ChangeSettingBtn"), for: .normal)
        
        completeButtonLabel.frame.size = CGSize(width: completeButton.frame.width * 0.6, height: completeButton.frame.height * 0.6)
        completeButtonLabel.center = completeButton.center
        completeButtonLabel.text = "완료"
        completeButtonLabel.textAlignment = .center
        completeButtonLabel.textColor = .black
        completeButtonLabel.isUserInteractionEnabled = false
        view.addSubview(completeButton)
        view.addSubview(completeButtonLabel)
    }
    
    @objc func backButtonPressed() {
        guard let nextVC = self.storyboard?.instantiateViewController(identifier: "settingViewController") as? SettingViewController else { return }
        transitionVc(vc: nextVC, duration: 1.0, type: .fromLeft)
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let MAX_LENGTH = 15
        let updatedString = ((textField.text ?? "") as NSString).replacingCharacters(in: range, with: string)
        
        return updatedString.count <= MAX_LENGTH
    }
}

extension UserIdInputViewController {
    private func setSettingTitle() {
        settingTitle.lineBreakMode = .byWordWrapping
        settingTitle.numberOfLines = 0

        settingTitle.text = "처음 오셨군요!\n\n작가님의 이름을 알려주세요.\n\n이름은 언제든지 수정 가능해요 :)"
        settingTitle.textColor = UIColor(r: 72, g: 80, b: 84)
        settingTitle.frame.size = CGSize(width: settingTitle.intrinsicContentSize.width,
                                         height: settingTitle.intrinsicContentSize.height)
        settingTitle.textAlignment = .center
        settingTitle.center = CGPoint(x: view.frame.width / 2,
                                      y: view.frame.height * 0.2)
        view.addSubview(settingTitle)
    }
}
