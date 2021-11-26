//
//  MainCanavasCollectionViewCell.swift
//  Canvas
//
//  Created by Junhong Park on 2021/11/26.
//

import UIKit

class MainCanavasCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var canvasView: UIView!
    var index: Int? {
        didSet {
            self.updateUI()
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    private func updateUI() {
        print("??")
        canvasView.frame.size = CGSize(width: 200, height: 200)
        canvasView.center = CGPoint(x: 100, y: 100)
        canvasView.backgroundColor = .white
        setShadows(canvasView)
    }
}
