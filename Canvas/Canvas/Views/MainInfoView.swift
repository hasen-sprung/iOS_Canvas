//
//  MainInfoView.swift
//  Canvas
//
//  Created by Junhong Park on 2021/11/21.
//

import UIKit

protocol MainInfoViewDelegate {
    func getInfoDateString() -> String
}

class MainInfoView: UIView {
    
    var delegate: MainInfoViewDelegate?
    let canvasTitleLabel = UILabel()
    let canvasUserLabel = UILabel()
    let howMadeLabel = UILabel()
    let canvasDateLabel = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setTitleLabelUI()
        setUserLabelUI()
        setHowMadeLabel()
        self.addSubview(canvasTitleLabel)
        self.addSubview(canvasUserLabel)
        self.addSubview(howMadeLabel)
        self.addSubview(canvasDateLabel)
    }
    
    private func setTitleLabelUI() {
        canvasTitleLabel.text = UserDefaults.standard.string(forKey: "canvasTitle")
        canvasTitleLabel.font = UIFont(name: "Helvetica", size: 16)
        canvasTitleLabel.textColor = UIColor(r: 72, g: 80, b: 84)
    }
    
    private func setUserLabelUI() {
        canvasUserLabel.text = UserDefaults.standard.string(forKey: "userID") ?? "User(1)"
        canvasUserLabel.font = UIFont(name: "Helvetica", size: 14)
        canvasUserLabel.textColor = UIColor(r: 103, g: 114, b: 120)
    }
    
    private func setHowMadeLabel() {
        howMadeLabel.text = "emotions on canvas"
        howMadeLabel.font = UIFont(name: "Helvetica", size: 12)
        howMadeLabel.textColor = UIColor(r: 141, g: 146, b: 149)
    }
    
    // 따로 해주어야 함.
    func setDateLabel() {
        if let d = delegate {
            canvasDateLabel.text = d.getInfoDateString()
        }
        canvasDateLabel.text = "2021. 11. 01 ~ 2021. 11. 04"
        canvasDateLabel.font = UIFont(name: "Helvetica", size: 12)
        canvasUserLabel.textColor = UIColor(r: 103, g: 114, b: 120)
    }
    
    func setInfoViewContentSize() {
        canvasTitleLabel.frame.size = CGSize(width: canvasTitleLabel.intrinsicContentSize.width,
                                             height: self.frame.height * 0.34)
        canvasUserLabel.frame.size = CGSize(width: canvasUserLabel.intrinsicContentSize.width,
                                             height: self.frame.height * 0.22)
        howMadeLabel.frame.size = CGSize(width: howMadeLabel.intrinsicContentSize.width,
                                             height: self.frame.height * 0.22)
        canvasDateLabel.frame.size = CGSize(width: canvasDateLabel.intrinsicContentSize.width,
                                             height: self.frame.height * 0.22)
    }
    
    func setInfoViewContentLayout() {
        canvasTitleLabel.frame.origin = CGPoint(x: .zero,
                                                y: self.frame.height * 0.0)
        canvasUserLabel.frame.origin = CGPoint(x: .zero,
                                                y: self.frame.height * 0.34)
        howMadeLabel.frame.origin = CGPoint(x: .zero,
                                                y: self.frame.height * 0.56)
        canvasDateLabel.frame.origin = CGPoint(x: .zero,
                                                y: self.frame.height * 0.78)
    }
        
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
