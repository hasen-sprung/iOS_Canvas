import UIKit
import MessageUI

class SettingViewController: UIViewController {
    private let settingTitle = UILabel()
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var settingTableView: UITableView!
    private let backButtonIcon = UIImageView()
    private var version: String? {
        guard let dictionary = Bundle.main.infoDictionary,
              let version = dictionary["CFBundleShortVersionString"] as? String,
              let build = dictionary["CFBundleVersion"] as? String
        else { return nil }
        
        let versionAndBuild: String = "\(textSettingVersion) \(version).\(build)"
        return versionAndBuild
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .black
    }
    
    private let settingList = ["작가명", "작품명", "작품 모드", "흔들어서 그림 섞기", "가이드 도형", "개발자에게 의견 남기기", "Canvas 정보"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(r: 240, g: 240, b: 243)
        setTableView()
        settingTableView.delegate = self
        settingTableView.dataSource = self
        settingTableView.register(SettingTableViewCell.classForCoder(), forCellReuseIdentifier: "settingCell")
        setSettingTitle()
        setBackButton()
        let swipe = UISwipeGestureRecognizer(target: self, action: #selector(backButtonPressed))
        swipe.direction = .down
        self.settingTableView.gestureRecognizers = [swipe]
    }
    
    @objc func backButtonPressed() {
        dismiss(animated: true, completion: nil)
    }
}

// MARK: - cell press event

extension SettingViewController: MFMailComposeViewControllerDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        switch indexPath.row {
        case 0:
            guard let nextVC = self.storyboard?.instantiateViewController(identifier: "settingUserIDViewController") as? SettingUserIDViewController else { return }
            transitionVc(vc: nextVC, duration: 0.5, type: .fromRight)
        case 1:
            guard let nextVC = self.storyboard?.instantiateViewController(identifier: "settingTitleViewController") as? SettingTitleViewController else { return }
            transitionVc(vc: nextVC, duration: 0.5, type: .fromRight)
        case 2:
            if UserDefaults.standard.bool(forKey: "canvasMode") == true {
                if let cell = settingTableView.cellForRow(at: indexPath) as? SettingTableViewCell {
                    cell.toggleLabel.text = "Last 10"
                }
                UserDefaults.standard.set(false, forKey: "canvasMode")
            } else {
                if let cell = settingTableView.cellForRow(at: indexPath) as? SettingTableViewCell {
                    cell.toggleLabel.text = "Each Date"
                }
                UserDefaults.standard.set(true, forKey: "canvasMode")
            }
        case 3:
            if UserDefaults.standard.bool(forKey: "shakeAvail") == true {
                if let cell = settingTableView.cellForRow(at: indexPath) as? SettingTableViewCell {
                    cell.toggleLabel.text = "Off"
                }
                UserDefaults.standard.set(false, forKey: "shakeAvail")
            } else {
                if let cell = settingTableView.cellForRow(at: indexPath) as? SettingTableViewCell {
                    cell.toggleLabel.text = "On"
                }
                UserDefaults.standard.set(true, forKey: "shakeAvail")
            }
        case 4:
            if UserDefaults.standard.bool(forKey: "guideAvail") == true {
                if let cell = settingTableView.cellForRow(at: indexPath) as? SettingTableViewCell {
                    cell.toggleLabel.text = "Off"
                }
                UserDefaults.standard.set(false, forKey: "guideAvail")
            } else {
                if let cell = settingTableView.cellForRow(at: indexPath) as? SettingTableViewCell {
                    cell.toggleLabel.text = "On"
                }
                UserDefaults.standard.set(true, forKey: "guideAvail")
            }
        case 5:
            if MFMailComposeViewController.canSendMail() {
                
                let compseVC = MFMailComposeViewController()
                compseVC.mailComposeDelegate = self
                compseVC.setToRecipients(["hasensprung42@gmail.com"])
                compseVC.setSubject("")
                compseVC.setMessageBody("", isHTML: false)
                self.present(compseVC, animated: true, completion: nil)
            }
            else {
                self.showSendMailErrorAlert()
            }
        default:
            return
        }
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    func showSendMailErrorAlert() {
        let sendMailErrorAlert = UIAlertController(title: "메일을 전송 실패", message: "이메일앱을 확인하고 다시 시도해주세요.", preferredStyle: .alert)
        let confirmAction = UIAlertAction(title: "확인", style: .default) {
            (action) in
        }
        
        sendMailErrorAlert.addAction(confirmAction)
        self.present(sendMailErrorAlert, animated: true, completion: nil)
    }
}

// MARK: - set Table View

extension SettingViewController: UITableViewDelegate, UITableViewDataSource {
    private func setTableView() {
        setTableViewConstraints()
        setTableViewUI()
    }
    
    private func setTableViewConstraints() {
        settingTableView.frame.size = CGSize(width: view.frame.width,
                                             height: view.frame.height * 5 / 6)
        settingTableView.frame.origin = CGPoint(x: .zero,
                                                y: view.frame.height * 0.2)
    }
    
    private func setTableViewUI() {
        settingTableView.backgroundColor = UIColor(r: 240, g: 240, b: 243)
        settingTableView.separatorStyle = .none
        settingTableView.isScrollEnabled = false
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return settingList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = settingTableView.dequeueReusableCell(withIdentifier: "settingCell") as? SettingTableViewCell
        
        cell?.setCellConstraints(viewWidth: view.frame.width)
        cell?.backgroundColor = UIColor(r: 240, g: 240, b: 243)
        cell?.settingText.text = settingList[indexPath.row]
        if indexPath.row == 0 {
            cell?.settingDetail.text = UserDefaults.standard.string(forKey: "userID")
            cell?.settingDetailAvailable()
        }
        if indexPath.row == 1 {
            cell?.settingDetail.text = UserDefaults.standard.string(forKey: "canvasTitle")
            cell?.settingDetailAvailable()
        }
        if indexPath.row == 2 {
            cell?.settingToggleAvailable()
            if UserDefaults.standard.bool(forKey: "canvasMode") == true {
                cell?.toggleLabel.text = "Each Date"
            } else {
                cell?.toggleLabel.text = "Last 10"
            }
        }
        if indexPath.row == 3 {
            cell?.settingToggleAvailable()
            if UserDefaults.standard.bool(forKey: "shakeAvail") == true {
                cell?.toggleLabel.text = "On"
            } else {
                cell?.toggleLabel.text = "Off"
            }
        }
        if indexPath.row == 4 {
            cell?.settingToggleAvailable()
            if UserDefaults.standard.bool(forKey: "guideAvail") == true {
                cell?.toggleLabel.text = "On"
            } else {
                cell?.toggleLabel.text = "Off"
            }
        }
        if indexPath.row == 6 {
            cell?.settingDetail.text = version
            cell?.settingDetailAvailable()
            cell?.settingDetail.font = UIFont(name: "Pretendard-Regular", size: 12)
        }
        
        let bgColorView = UIView()
        bgColorView.backgroundColor = UIColor(r: 240, g: 240, b: 243)
        cell?.selectedBackgroundView = bgColorView
        
        return cell ?? UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let cellHeight = view.frame.height * 0.07
        return cellHeight
    }
}

// MARK: - set setting title and back button

extension SettingViewController {
    private func setSettingTitle() {
        settingTitle.snp.makeConstraints { make in
            settingTitle.backgroundColor = .clear
            settingTitle.text = "Setting"
            settingTitle.font = UIFont(name: "Cardo-Bold", size: CGFloat(fontSize))
            settingTitle.textColor = textColor
            settingTitle.textAlignment = .center
            settingTitle.frame.size = CGSize(width: settingTitle.intrinsicContentSize.width,
                                              height: settingTitle.intrinsicContentSize.height)
            make.centerX.equalTo(self.view)
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top).offset(paddingInSafeArea + 10)
            view.addSubview(settingTitle)
        }
    }
    
    private func setBackButton() {
        setBackButtonConstraints()
        setBackButtonUI()
        backButton.addTarget(self, action: #selector(backButtonPressed), for: .touchUpInside)
    }
    
    private func setBackButtonConstraints() {
        backButton.snp.makeConstraints { make in
            make.leading.equalTo(self.view.safeAreaLayoutGuide.snp.leading).offset(paddingInSafeArea)
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top).offset(paddingInSafeArea)
            make.size.equalTo(buttonSize)
        }
        backButtonIcon.snp.makeConstraints { make in
            make.size.equalTo(backButton).multipliedBy(iconSizeRatio)
            make.center.equalTo(backButton)
            view.addSubview(backButtonIcon)
        }
    }
    
    private func setBackButtonUI() {
        backButton.backgroundColor = .clear
        backButton.setImage(UIImage(named: "SmallBtnBackground"), for: .normal)
        backButtonIcon.image = UIImage(systemName: "xmark")
        backButtonIcon.tintColor = UIColor(r: 163, g: 173, b: 178)
        backButtonIcon.isUserInteractionEnabled = false
    }
}
