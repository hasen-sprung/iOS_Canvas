//
//  SVGTextView.swift
//  project-Emotion
//
//  Created by Junhong Park on 2021/10/04.
//

import UIKit

@objc protocol SVGTextViewDelegate {
    
    func dismissTextViewSVG()
    
    func saveRecord(date: Date, figure: Float, text: String?)
    
    func finishGaugeEvent()
}

class SVGTextView: UIView {
    
    var svgTextViewDelegate: SVGTextViewDelegate?
    
    let textBaseView = UIView()
    let textView = UITextView()
    let buttonBaseView = UIView()
    let buttonTriggerView = UIView()
    let cancelButton = UIButton()
    let completeButton = UIButton()
    let dateLabel = UILabel()
    
    
    var figure: Float?
    var date: Date?
    var currentColor: Int?
    
    var keyboardHeight: CGFloat?
    
    func setTextViewProperties(figure: Float) {
        
        self.figure = figure
        self.date = Date()
        
        setTextBaseView()
        textBaseView.alpha = 0.0
        textBaseView.fadeIn(duration: 0.5)
        self.addSubview(textBaseView)
    }
    
    private func getCurrentColor() -> Int{
        
        return CellTheme.shared.getCurrentColor(figure: self.figure ?? 0.5)
    }
    
    private func setTextBaseView() {
        
        let keyboardHeight = self.frame.height * 0.3
        
        textBaseView.frame.size = CGSize(width: self.frame.width * 0.8, height: (self.frame.height - keyboardHeight) * 0.7)
        textBaseView.center = CGPoint(x: self.frame.width / 2, y: (self.frame.height - keyboardHeight) / 2)
        textBaseView.backgroundColor = .white
        textBaseView.layer.cornerRadius = 40
        textBaseView.layer.shadowColor = UIColor.gray.cgColor
        textBaseView.layer.shadowOpacity = 2.0
        textBaseView.layer.shadowOffset = CGSize.zero
        textBaseView.layer.shadowRadius = 6
        setDateLabel()
        textBaseView.addSubview(dateLabel)
        setTextView()
        textBaseView.addSubview(textView)
        textView.becomeFirstResponder()
        setButtons()
        textBaseView.addSubview(buttonBaseView)
    }
    
    private func setDateLabel() {
        
        let df = DateFormatter()
        df.dateFormat = "M월 d일 a h시 mm분"
        df.locale = Locale(identifier:"ko_KR")
        
        let dateString = df.string(from: self.date!)
        
        dateLabel.frame.size = CGSize(width: textBaseView.frame.width * 0.8, height: textBaseView.frame.height * 0.125)
        dateLabel.center = CGPoint(x: textBaseView.frame.width / 2, y: textBaseView.frame.height * 0.0625)
        dateLabel.text = dateString
        dateLabel.textColor = UIColor(hex: getCurrentColor())
        dateLabel.textAlignment = .center
        dateLabel.font = UIFont.systemFont(ofSize: 15, weight: .bold)
    }
    
    private func setTextView() {
        
        textView.frame.size = CGSize(width: textBaseView.frame.width * 0.8, height: textBaseView.frame.height * 0.65)
        textView.center = CGPoint(x: textBaseView.frame.width / 2, y: textBaseView.frame.height * 0.45)
        textView.textColor = .black
        textView.backgroundColor = .white
        textView.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
    }
    
    private func setButtons() {
        
        buttonBaseView.frame.size = CGSize(width: textBaseView.frame.width * 0.8, height: textBaseView.frame.height * 0.15)
        buttonBaseView.center = CGPoint(x: textBaseView.frame.width / 2, y: textBaseView.frame.height * 0.8875)
        buttonBaseView.backgroundColor = UIColor(hex: getCurrentColor())
        buttonBaseView.layer.cornerRadius = buttonBaseView.frame.height / 2
        
        setButtonTriggerView()
        buttonBaseView.addSubview(buttonTriggerView)
        setCompleteButton()
        buttonBaseView.addSubview(completeButton)
        setCancelButton()
        buttonBaseView.addSubview(cancelButton)
        
    }
    
    private func setButtonTriggerView() {
        
        buttonTriggerView.frame.size = CGSize(width: buttonBaseView.frame.width / 3, height: buttonBaseView.frame.height * 0.75)
        buttonTriggerView.center = CGPoint(x: buttonBaseView.frame.width * 0.75, y: buttonBaseView.frame.height / 2)
        buttonTriggerView.layer.cornerRadius = buttonTriggerView.frame.height / 2
        buttonTriggerView.backgroundColor = .white
        buttonTriggerView.layer.shadowColor = UIColor.gray.cgColor
        buttonTriggerView.layer.shadowOpacity = 1.0
        buttonTriggerView.layer.shadowOffset = CGSize.zero
        buttonTriggerView.layer.shadowRadius = 6
    }
    
    private func setCompleteButton() {
        
        completeButton.frame.size = CGSize(width: buttonBaseView.frame.width / 3, height: buttonBaseView.frame.height * 0.75)
        completeButton.center = CGPoint(x: buttonBaseView.frame.width * 0.75, y: buttonBaseView.frame.height / 2)
        completeButton.backgroundColor = .clear
        completeButton.setTitle("추가", for: .normal)
        completeButton.setTitleColor(UIColor(hex: getCurrentColor()), for: .normal)
        completeButton.addTarget(self, action: #selector(completeTextView), for: .touchUpInside)
    }
    
    private func setCancelButton() {
        
        cancelButton.frame.size = CGSize(width: buttonBaseView.frame.width / 3, height: buttonBaseView.frame.height * 0.75)
        cancelButton.center = CGPoint(x: buttonBaseView.frame.width * 0.25, y: buttonBaseView.frame.height / 2)
        cancelButton.backgroundColor = .clear
        cancelButton.layer.cornerRadius = cancelButton.frame.height / 2
        cancelButton.setTitle("취소", for: .normal)
        cancelButton.setTitleColor(.white, for: .normal)
        cancelButton.addTarget(self, action: #selector(dismissTextView), for: .touchUpInside)
    }
    
    @objc func dismissTextView() {
        
        UIView.animate(withDuration: 0.3, delay: 0.0, options: [.curveEaseOut], animations: { [self] in
            
            self.buttonTriggerView.center = CGPoint(x: buttonBaseView.frame.width * 0.25, y: buttonBaseView.frame.height / 2)
            self.completeButton.setTitleColor(.white, for: .normal)
            self.cancelButton.setTitleColor(UIColor(hex: getCurrentColor()), for: .normal)
            
        }) { (completed) in
            if let delegate = self.svgTextViewDelegate {
                delegate.dismissTextViewSVG()
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                self.textView.text = nil
                self.textBaseView.removeFromSuperview()
            }
        }
    }
    
    @objc func completeTextView() {
        
        if let delegate = self.svgTextViewDelegate {
            
            delegate.saveRecord(date: date ?? Date(),
                                figure: figure ?? 0.0,
                                text: textView.text)
        }
        
        if let delegate = self.svgTextViewDelegate {
            delegate.finishGaugeEvent()
        }
    }
    
    
}
