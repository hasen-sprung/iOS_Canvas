import UIKit
import SwiftUI

class SettingTableViewCell: UITableViewCell {

    let settingText = UILabel()
    let settingDetail = UILabel()
    let toggleLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setCellUI()
        self.contentView.addSubview(settingText)
    }
    
    func settingDetailAvailable() {
        self.contentView.addSubview(settingDetail)
    }
    
    func settingToggleAvailable() {
        self.contentView.addSubview(toggleLabel)
    }
    
    func setCellConstraints(viewWidth: CGFloat) {
        settingText.frame.size = CGSize(width: viewWidth * 0.2, height: self.frame.height)
        settingText.frame.origin = CGPoint(x: viewWidth * 0.1, y: .zero)
        settingDetail.frame.size = CGSize(width: viewWidth * 0.6, height: self.frame.height)
        settingDetail.frame.origin = CGPoint(x: viewWidth * 0.3, y: .zero)
        toggleLabel.frame.size = CGSize(width: viewWidth * 0.4, height: self.frame.height)
        toggleLabel.frame.origin = CGPoint(x: viewWidth * 0.5, y: .zero)
    }
    
    private func setCellUI() {
        settingText.textColor = UIColor(r: 72, g: 80, b: 84)
        settingText.textAlignment = .left
        settingText.font = UIFont(name: "Pretendard-Regular", size: 14)
        settingDetail.textColor = UIColor(r: 72, g: 80, b: 84)
        settingDetail.textAlignment = .right
        settingDetail.font = UIFont(name: "Cardo-Regular", size: 12)
        toggleLabel.backgroundColor = .clear
        toggleLabel.font = UIFont(name: "Cardo-Regular", size: 12)
        toggleLabel.textColor = UIColor(r: 72, g: 80, b: 84)
        toggleLabel.textAlignment = .right
        toggleLabel.isUserInteractionEnabled = false
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
