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
        svgView.backgroundColor = .clear
        SvgImageView.backgroundColor = .lightGray
        SvgImageView.layer.cornerRadius = SvgImageView.frame.width / 2
        let svgImages = theme.instanceSVGImages()
        let currentImage = theme.getNodeByFigure(figure: records[indexPath.row].gaugeLevel, currentNode: nil, svgNodes: svgImages) ?? Node()
        svgView.node = currentImage
        let svgShape = (svgView.node as! Group).contents.first as! Shape
        svgShape.fill = Color(CellTheme.shared.getCurrentColor(figure: figure))
        
        var timeString = "오전 0:00"
        let df = DateFormatter()
        df.dateFormat = "a hh:mm"
        df.locale = Locale(identifier:"ko_KR")
        if let newTime = time {
            timeString = df.string(from: newTime)
        }
        
        timeLabel.text = timeString
        memoBackgroundView.backgroundColor = .clear
        memoView.text = memo
        memoView.backgroundColor = .clear
        memoView.frame.size = CGSize(width: memoView.frame.width, height: memoView.optimalHeight)
        if memoView.text == nil {
            memoView.alpha = 0.0
        }
    }
    
    private func setCellContentsLayout() {
        
        self.backgroundColor = .clear
        self.contentView.backgroundColor = .clear
    }
    
//    override func layoutSubviews() {
//        super.layoutSubviews()
//
//        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 5, left: 0, bottom: 5, right: 0))
//    }
//    
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
