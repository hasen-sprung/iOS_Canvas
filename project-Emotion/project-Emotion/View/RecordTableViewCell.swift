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
        
        
        
        memoView.text = memo
        if memoView.text == nil {
            memoView.alpha = 0.0
        }
        
    }
    
    private func setCellContentsLayout() {
        
        self.backgroundColor = .clear
        self.contentView.backgroundColor = .clear
        
//        SvgImageView.frame.size = CGSize(width: self.frame.size.height * 0.6, height: self.frame.size.height * 0.6)
//        SvgImageView.center = CGPoint(x: self.frame.size.width * 0.3, y: self.frame.size.height * 0.4)
//        SvgImageView.clipsToBounds = true
//        SvgImageView.backgroundColor = .clear
//
//        timeLabel.frame.size = CGSize(width: self.frame.size.height * 0.6, height: self.frame.size.height * 0.15)
//        timeLabel.center = CGPoint(x: self.frame.size.width * 0.3, y: self.frame.size.height * 0.875)
//        timeLabel.backgroundColor = .cyan
//
//        memoView.frame.size = CGSize(width: self.frame.size.width * 0.4, height: self.frame.size.height * 0.8)
//        memoView.center = CGPoint(x: self.frame.size.width * 0.75, y: self.frame.size.height * 0.5)
//        memoView.backgroundColor = .cyan
    }

}
