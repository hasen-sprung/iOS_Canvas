//
//  ListTableViewCell.swift
//  Canvas
//
//  Created by Junhong Park on 2021/11/18.
//

import UIKit

class ListTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var shapeImage: UIImageView!
    @IBOutlet weak var userMemo: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        timeLabel.backgroundColor = .clear
        shapeImage.backgroundColor = .clear
        userMemo.backgroundColor = .clear
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }

}
