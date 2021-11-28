import UIKit

class SettingManualViewController: UIViewController {

    @IBOutlet weak var backButton: UIButton!
    private let backButtonIcon = UIImageView()
    private let settingTitle = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setSettingTitle()
        setBackButton()
    }

    @objc func backButtonPressed() {
        guard let nextVC = self.storyboard?.instantiateViewController(identifier: "settingViewController") as? SettingViewController else { return }
        transitionVc(vc: nextVC, duration: 0.5, type: .fromLeft)
    }
}

extension SettingManualViewController {
    private func setSettingTitle() {
        settingTitle.text = "Canvas 사용법"
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
