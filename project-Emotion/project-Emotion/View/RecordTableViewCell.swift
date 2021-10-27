//
//  RecordTableViewCell.swift
//  project-Emotion
//
//  Created by Junhong Park on 2021/10/15.
//

import UIKit
import Macaw
import CoreData


class RecordTableViewCell: UITableViewCell {
    
    @IBOutlet weak var SvgImageView: UIView!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var memoView: UILabel!
    @IBOutlet weak var svgView: SVGView!
    @IBOutlet weak var memoBackgroundView: UIView!
    
    
    let theme = ThemeManager.shared.getThemeInstance()
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
        
        
        let time = records[indexPath.row].createdDate
        let figure = records[indexPath.row].gaugeLevel
        let memo = records[indexPath.row].memo
        let color = CellTheme.shared.getCurrentColor(figure: figure)
        svgView.backgroundColor = .clear
        SvgImageView.backgroundColor = .white
        SvgImageView.layer.cornerRadius = SvgImageView.frame.width / 2
        let svgImages = theme.instanceSVGImages()
        let currentImage = theme.getNodeByFigure(figure: records[indexPath.row].gaugeLevel, currentNode: nil, svgNodes: svgImages) ?? Node()
        svgView.node = currentImage
        let svgShape = (svgView.node as! Group).contents.first as! Shape
        svgShape.fill = Color(color)
        
        var timeString = "오전 0:00"
        let df = DateFormatter()
        df.dateFormat = "a hh:mm"
        df.locale = Locale(identifier:"ko_KR")
        if let newTime = time {
            timeString = df.string(from: newTime)
        }
        
        timeLabel.text = timeString
        timeLabel.textColor = .black
        memoBackgroundView.backgroundColor = .white
        memoBackgroundView.layer.cornerRadius = 15
        memoView.text = memo
        memoView.textColor = .black
        memoView.backgroundColor = .clear
        memoView.frame.size = CGSize(width: memoView.frame.width, height: memoView.optimalHeight)
        if memoView.text?.count == 0 {
            memoBackgroundView.backgroundColor = .clear
        }
        
        self.contentView.backgroundColor = .clear// UIColor(hex: color)
        self.contentView.layer.cornerRadius = 15
    }
    
    private func setCellContentsLayout() {
        
        self.backgroundColor = .clear
        self.contentView.backgroundColor = .clear
    }
    
}

extension UILabel {
    var optimalHeight : CGFloat {
        get {
            let label = UILabel(frame: CGRect(x: 0, y: 0, width: self.frame.width, height: CGFloat.greatestFiniteMagnitude))
            label.numberOfLines = 0
            label.lineBreakMode = self.lineBreakMode
            label.font = self.font
            label.text = self.text
            
            label.sizeToFit()
            
            return label.frame.height
        }
    }
}
