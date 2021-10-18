//
//  RecordTableViewCell.swift
//  project-Emotion
//
//  Created by Junhong Park on 2021/10/15.
//

import UIKit
import Macaw


class RecordTableViewCell: UITableViewCell {

    @IBOutlet weak var svgImageView: SVGView!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var memoView: UILabel!
    
    
    let currentTheme = ThemeManager.shared.getThemeInstance()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setCellContentsLayout()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setCellContents(records: [Record], indexPath: IndexPath) {
        
        
    }
    
    private func setCellContentsLayout() {
        
        self.backgroundColor = .clear
        self.contentView.backgroundColor = .clear
        
        svgImageView.frame.size = CGSize(width: self.frame.size.height * 0.6, height: self.frame.size.height * 0.6)
        svgImageView.center = CGPoint(x: self.frame.size.width * 0.3, y: self.frame.size.height * 0.4)
        svgImageView.layer.cornerRadius = svgImageView.frame.width / 2
        svgImageView.clipsToBounds = true
        svgImageView.backgroundColor = .cyan
        
        timeLabel.frame.size = CGSize(width: self.frame.size.height * 0.6, height: self.frame.size.height * 0.15)
        timeLabel.center = CGPoint(x: self.frame.size.width * 0.3, y: self.frame.size.height * 0.875)
        timeLabel.backgroundColor = .cyan
        
        memoView.frame.size = CGSize(width: self.frame.size.width * 0.4, height: self.frame.size.height * 0.8)
        memoView.center = CGPoint(x: self.frame.size.width * 0.75, y: self.frame.size.height * 0.5)
        memoView.backgroundColor = .cyan
    }

}
