//
//  SettingTableViewCell.swift
//  Canvas
//
//  Created by Junhong Park on 2021/11/21.
//

import UIKit
import SwiftUI

class SettingTableViewCell: UITableViewCell {

    let settingText = UILabel()
    let settingDetail = UILabel()
    let settingToggle = UIView()
    let toggleButton = UIButton()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setCellUI()
        self.contentView.addSubview(settingText)
    }
    
    func settingDetailAvailable() {
        self.contentView.addSubview(settingDetail)
    }
    
    func settingToggleAvailable() {
        self.contentView.addSubview(settingToggle)
    }
    
    func setCellConstraints(viewWidth: CGFloat) {
        settingText.frame.size = CGSize(width: viewWidth * 0.5, height: self.frame.height)
        settingText.frame.origin = CGPoint(x: viewWidth * 0.1, y: .zero)
        settingDetail.frame.size = CGSize(width: viewWidth * 0.3, height: self.frame.height)
        settingDetail.frame.origin = CGPoint(x: viewWidth * 0.6, y: .zero)
        settingToggle.frame.size = CGSize(width: self.frame.height, height: self.frame.height)
        settingToggle.frame.origin = CGPoint(x: viewWidth * 0.9 - self.frame.height, y: .zero)
        toggleButton.frame.size = CGSize(width: self.frame.height * 0.7, height: self.frame.height * 0.7)
        toggleButton.center = CGPoint(x: settingToggle.frame.width / 2, y: settingToggle.frame.height / 2)
        toggleButton.layer.cornerRadius = toggleButton.frame.width / 2
        settingToggle.addSubview(toggleButton)
        
    }
    
    private func setCellUI() {
        settingText.textColor = UIColor(r: 72, g: 80, b: 84)
        settingText.textAlignment = .left
        settingText.font = UIFont(name: "Pretendard-Regular", size: 14)
        settingDetail.textColor = UIColor(r: 72, g: 80, b: 84)
        settingDetail.textAlignment = .right
        settingDetail.font = UIFont(name: "Cardo-Regular", size: 12)
        toggleButton.backgroundColor = .clear
        toggleButton.tintColor = UIColor(r: 72, g: 80, b: 84)
        if UserDefaults.standard.bool(forKey: "shakeAvail") == true {
            toggleButton.setImage(UIImage(systemName: "circle"), for: .normal)
        } else {
            toggleButton.setImage(UIImage(systemName: "xmark"), for: .normal)
        }
        toggleButton.isUserInteractionEnabled = false
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
