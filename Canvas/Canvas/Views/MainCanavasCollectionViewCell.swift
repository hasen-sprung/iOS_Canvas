//
//  MainCanavasCollectionViewCell.swift
//  Canvas
//
//  Created by Junhong Park on 2021/11/26.
//

import UIKit

class MainCanavasCollectionViewCell: UICollectionViewCell {
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.layer.cornerRadius = 3.0
        layer.shadowRadius = 10
        layer.shadowOpacity = 0.4
        layer.shadowOffset = CGSize(width: 5, height: 10)
    }
}
