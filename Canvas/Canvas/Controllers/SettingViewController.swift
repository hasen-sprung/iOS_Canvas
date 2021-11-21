//
//  SettingViewController.swift
//  Canvas
//
//  Created by Junhong Park on 2021/11/21.
//

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
        
        let versionAndBuild: String = "V \(version).\(build)"
        return versionAndBuild
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .black
    }
    
    private let settingList = ["작가명", "작품명", "흔들어서 그림 섞기", "개발자에게 의견 남기기", "Canvas 정보"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(r: 240, g: 240, b: 243)
        setTableView()
        settingTableView.delegate = self
        settingTableView.dataSource = self
        settingTableView.register(SettingTableViewCell.classForCoder(), forCellReuseIdentifier: "settingCell")
        setSettingTitle()
        setBackButton()
    }
    
    @objc func backButtonPressed() {
        guard let nextVC = self.storyboard?.instantiateViewController(identifier: "mainViewController") as? MainViewController else { return }
        transitionVc(vc: nextVC, duration: 0.5, type: .fromLeft)
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
            
            if UserDefaults.standard.bool(forKey: "shakeAvail") == true {
                if let cell = settingTableView.cellForRow(at: indexPath) as? SettingTableViewCell {
                    cell.toggleButton.setImage(UIImage(systemName: "xmark"), for: .normal)
                }
                UserDefaults.standard.set(false, forKey: "shakeAvail")
            } else {
                if let cell = settingTableView.cellForRow(at: indexPath) as? SettingTableViewCell {
                    cell.toggleButton.setImage(UIImage(systemName: "circle"), for: .normal)
                }
                UserDefaults.standard.set(true, forKey: "shakeAvail")
            }
        case 3:
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
        }
        if indexPath.row == 5 {
            cell?.settingDetail.text = version
            cell?.settingDetailAvailable()
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
        settingTitle.text = "Canvas Setting"
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
