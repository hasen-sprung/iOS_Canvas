//
//  SVGTextView.swift
//  project-Emotion
//
//  Created by Junhong Park on 2021/10/04.
//

import UIKit

@objc protocol SVGTextViewDelegate {
    
    func setSVGTextView()
    
    func setSVGTextViewField()
    
    func dismissTextViewSVG()
    
    func textViewToFloatingSVG()
}

class SVGTextView: UIView {
    
    var svgTextViewDelegate: SVGTextViewDelegate?
    
    let textBaseView = UIView()
    let textView = UITextView()
    let buttonBaseView = UIView()
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
        df.dateFormat = "yyyy년 M월 d일 a h시 mm분"
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
        
        setCompleteButton()
        buttonBaseView.addSubview(completeButton)
        setCancelButton()
        buttonBaseView.addSubview(cancelButton)
        
    }
    
    private func setCompleteButton() {
        
        completeButton.frame.size = CGSize(width: buttonBaseView.frame.width / 3, height: buttonBaseView.frame.height * 0.75)
        completeButton.center = CGPoint(x: buttonBaseView.frame.width * 0.75, y: buttonBaseView.frame.height / 2)
        completeButton.backgroundColor = .white
        completeButton.layer.cornerRadius = completeButton.frame.height / 2
        completeButton.setTitle("추가", for: .normal)
        completeButton.setTitleColor(UIColor(hex: getCurrentColor()), for: .normal)
        completeButton.addTarget(self, action: #selector(saveRecord), for: .touchUpInside)
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
        
        textView.text = nil
        textBaseView.removeFromSuperview()
        if let delegate = self.svgTextViewDelegate {
            delegate.dismissTextViewSVG()
        }
    }
    
    @objc func saveRecord() {
        
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let newRecord = Record(context: context)
        
        if self.date != nil { newRecord.date = self.date } else { newRecord.date = Date()}
        if self.figure != nil { newRecord.figure = self.figure ?? 0.0 } else {newRecord.figure = 0.0}
        if textView.text != nil { newRecord.text = textView.text }
        
        do { try context.save() } catch { print("Error saving context \(error)") }
        
        let paths = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)
        print(paths[0])
    }
    
    
}
