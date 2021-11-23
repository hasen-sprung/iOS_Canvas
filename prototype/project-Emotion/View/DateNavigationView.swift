//
//  DateNavigationView.swift
//  project-Emotion
//
//  Created by Junhong Park on 2021/10/25.
//

import UIKit

protocol DateNavigationViewDelegate {
    
    func getDateString() -> String
    
    func changeDateMode(mode: Int)
    
}

class DateNavigationView: UIView {
    
    private let dayButton = UIButton()
    private let weekButton = UIButton()
    private let monthButton = UIButton()
    private let dateLabel = UILabel()
    
    var delegate: DateNavigationViewDelegate?
    
    override func awakeFromNib() {
        
        self.backgroundColor = .clear
    }
    
    func setDateNavigationLayout() {
        
        setButtonsLayout()
        addTargetForButtons()
        setLabelLayout()
    }
    
    private func setButtonsLayout() {
        
        let buttons = [dayButton, weekButton, monthButton]
        let centerX = [2, 4, 6]
        let title = ["Day", "Week", "Month"]
        
        for idx in 0 ..< buttons.count {
            
            buttons[idx].backgroundColor = cellGVBottom
            buttons[idx].frame.size = CGSize(width: self.frame.width / 5,
                                             height: self.frame.height / 4)
            buttons[idx].center = CGPoint(x: self.frame.width / 8 * CGFloat(centerX[idx]),
                                          y: self.frame.height * 0.25)
            buttons[idx].setTitle(title[idx], for: .normal)
            buttons[idx].setTitleColor(.white, for: .normal)
            buttons[idx].layer.cornerRadius = buttons[idx].frame.height * 0.3

            self.addSubview(buttons[idx])
        }
    }
    
    private func setLabelLayout() {
        
        dateLabel.frame.size = CGSize(width: self.frame.width,
                                      height: self.frame.height / 3)
        dateLabel.center = CGPoint(x: self.frame.width / 2,
                                   y: self.frame.height * 0.7)
        dateLabel.backgroundColor = .clear
        if let delegate = delegate { dateLabel.text = delegate.getDateString() }
        dateLabel.textColor = cellGVBottom
        dateLabel.textAlignment = .center
        self.addSubview(dateLabel)
    }
    
    func setLabelText() {
        
        if let delegate = delegate { dateLabel.text = delegate.getDateString() }
    }
    
    private func addTargetForButtons() {
        

        dayButton.addTarget(self, action: #selector(dayButtonPressed), for: .touchUpInside)
        weekButton.addTarget(self, action: #selector(weekButtonPressed), for: .touchUpInside)
        monthButton.addTarget(self, action: #selector(monthButtonPressed), for: .touchUpInside)
    }
    
    @objc private func dayButtonPressed() {
        
        if let delegate = delegate {
            delegate.changeDateMode(mode: 0)
            dateLabel.text = delegate.getDateString()
        }
    }
    
    @objc private func weekButtonPressed() {
        
        if let delegate = delegate {
            delegate.changeDateMode(mode: 1)
            dateLabel.text = delegate.getDateString()
        }
    }
    
    @objc private func monthButtonPressed() {
        
        if let delegate = delegate {
            delegate.changeDateMode(mode: 2)
            dateLabel.text = delegate.getDateString()
        }
    }
}
