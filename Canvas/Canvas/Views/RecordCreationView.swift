import UIKit
import SnapKit

protocol CreateRecordViewDelegate {
    func getGaugeLevel() -> Int
    func dismissCreateRecordView()
    func completeCreateRecordView()
    func saveRecord(newDate: Date, newGagueLevel: Int, newMemo: String?)
}

class RecordCreationView: UIView {
    var delegate: CreateRecordViewDelegate?
    private var date = Date()
    
    private let rootBackgroundView = UIView()
    private let rootBackgroundImageView = UIImageView()
    
    private let dateLabelView = UILabel()
    private var byteView = UILabel()
    private let memoTextView = UITextView()
    
    private let completeButtonBackground = UIImageView()
    private let completeButtonIcon = UIImageView()
    private let cancelButton = UIButton()
    private let completeButton = UIButton()
    
    private var bottomConstraint: Constraint?
    private var createRecordViewBottomOffset: CGFloat = {
        var offset = UIScreen.main.bounds.height * 0.4
        return offset
    }()
    
    private let changeDateButton = UIButton()
    private let datePicker = UIDatePicker()
    private var keyboardFrame = CGRect(x: 0, y: 0, width: 0, height: 0)
    private let modifyDateIcon = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .clear
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setLayout() {
        rootBackgroundView.snp.makeConstraints { make in
            make.top.equalTo(self.snp.top).offset(self.frame.width / 7 * 2.5)
            make.leading.equalTo(self.snp.leading).offset(40)
            make.trailing.equalTo(self.snp.trailing).offset(-40)
            // TODO: KEYBOARD NOTIFICATION
            self.bottomConstraint = make.bottom.equalTo(self.snp.bottom).offset(-createRecordViewBottomOffset).constraint
            
            rootBackgroundView.backgroundColor = .clear
            rootBackgroundView.layer.cornerRadius = 10
            self.addSubview(rootBackgroundView)
        }
        rootBackgroundImageView.snp.makeConstraints { make in
            make.top.equalTo(rootBackgroundView).offset(-30)
            make.leading.equalTo(rootBackgroundView).offset(-20)
            make.trailing.equalTo(rootBackgroundView).offset(30)
            make.bottom.equalTo(rootBackgroundView).offset(30)
            
            rootBackgroundImageView.image = UIImage(named: "CreateBackground")
            self.addSubview(rootBackgroundImageView)
        }
        dateLabelView.snp.makeConstraints { make in
            make.top.equalTo(rootBackgroundView.snp.top).offset(10)
            make.centerX.equalTo(self.snp.centerX)
            
            dateLabelView.backgroundColor = .clear
            
            let imageAttachment = NSTextAttachment()
            imageAttachment.image = UIImage(systemName: "pencil")
            imageAttachment.image = UIImage(systemName: "pencil")?.withTintColor(.black)
            
            let fullString = NSMutableAttributedString(string: getDateString() + " ")
            fullString.append(NSAttributedString(attachment: imageAttachment))
            dateLabelView.attributedText = fullString
//            dateLabelView.text = getDateString() + " ✎"
            dateLabelView.font = UIFont(name: "Cardo-Regular", size: 17)
            dateLabelView.textColor = .black
            dateLabelView.textAlignment = .center
            dateLabelView.frame.size = CGSize(width: dateLabelView.intrinsicContentSize.width,
                                              height: dateLabelView.intrinsicContentSize.height)
            self.addSubview(dateLabelView)
        }
        
        changeDateButton.snp.makeConstraints { make in
            make.top.equalTo(rootBackgroundView.snp.top).offset(10)
            make.leading.equalTo(rootBackgroundView.snp.leading).offset(0)
            make.trailing.equalTo(rootBackgroundView.snp.trailing).offset(0)
            make.centerX.equalTo(self.snp.centerX)
            
            changeDateButton.backgroundColor = .clear
            changeDateButton.setTitle("", for: .normal)
            changeDateButton.addTarget(self, action: #selector(createDatePickerView), for: .touchUpInside)
            self.addSubview(changeDateButton)
        }
        
        completeButtonBackground.snp.makeConstraints { make in
            make.leading.equalTo(rootBackgroundView.snp.leading).offset(30)
            make.trailing.equalTo(rootBackgroundView.snp.trailing).offset(-30)
            make.bottom.equalTo(rootBackgroundView.snp.bottom).offset(-20)
            make.height.equalTo(50)
            
            completeButtonBackground.image = UIImage(named: "TextBtnBackground")
            completeButtonBackground.isUserInteractionEnabled = false
            completeButtonBackground.backgroundColor = .clear
            self.addSubview(completeButtonBackground)
        }
        cancelButton.snp.makeConstraints { make in
            make.width.equalTo(completeButtonBackground.snp.width).dividedBy(2)
            make.height.equalTo(completeButtonBackground.snp.height)
            make.centerY.leading.equalTo(completeButtonBackground)
            
            cancelButton.setTitle("취소", for: .normal)
            cancelButton.setTitleColor(UIColor(r: 163, g: 173, b: 178), for: .normal)
            cancelButton.titleLabel?.font = UIFont(name: "Pretendard-Regular", size: 15)
            cancelButton.backgroundColor = .clear
            cancelButton.addTarget(self, action: #selector(cancelButtonPressed), for: .touchUpInside)
            self.addSubview(cancelButton)
        }
        completeButton.snp.makeConstraints { make in
            make.width.equalTo(completeButtonBackground.snp.width).dividedBy(2)
            make.height.equalTo(completeButtonBackground.snp.height)
            make.centerY.trailing.equalTo(completeButtonBackground)
            
            completeButton.setTitle("완료", for: .normal)
            completeButton.setTitleColor(.black, for: .normal)
            completeButton.setTitleColor(UIColor(r: 163, g: 173, b: 178), for: .disabled)
            completeButton.titleLabel?.font = UIFont(name: "Pretendard-Regular", size: 15)
            completeButton.backgroundColor = .clear
            completeButton.addTarget(self, action: #selector(completeButtonPressed), for: .touchUpInside)
            completeButton.isEnabled = false
            self.addSubview(completeButton)
        }
        completeButtonIcon.snp.makeConstraints { make in
            make.height.width.equalTo(completeButton).offset(14)
            make.centerX.equalTo(completeButton)
            make.centerY.equalTo(completeButton).offset(2)
            
            completeButtonIcon.image = UIImage(named: "TextBtn")
            completeButtonIcon.backgroundColor = .clear
            self.addSubview(completeButtonIcon)
        }
        memoTextView.snp.makeConstraints { make in
            make.top.equalTo(dateLabelView.snp.bottom).offset(20)
            make.leading.equalTo(rootBackgroundView.snp.leading).offset(30)
            make.trailing.equalTo(rootBackgroundView.snp.trailing).offset(-30)
            make.bottom.equalTo(completeButtonBackground.snp.top).offset(-20)
            
            memoTextView.delegate = self
            memoTextView.backgroundColor = .clear
            memoTextView.textContainer.maximumNumberOfLines = 15
            memoTextView.font = UIFont(name: "Pretendard-Regular", size: 16)
            memoTextView.textColor = .black
            memoTextView.becomeFirstResponder()
            memoTextView.isScrollEnabled = true
            self.addSubview(memoTextView)
        }
        byteView.snp.makeConstraints { make in
            make.bottom.equalTo(completeButtonBackground.snp.top)
            make.trailing.equalTo(memoTextView)

            byteView.frame.size = CGSize(width: dateLabelView.intrinsicContentSize.width,
                                         height: dateLabelView.intrinsicContentSize.height)
            byteView.text = "0/180"
            byteView.textAlignment = .right
            byteView.textColor = .lightGray
            byteView.font = UIFont(name: "Cardo-Regular", size: 13)
            self.addSubview(byteView)
        }
        self.bringSubviewToFront(cancelButton)
        self.bringSubviewToFront(completeButton)
        setSeperateLine()
    }
    
    @objc func createDatePickerView(){
        let toolbar = UIToolbar()
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target : nil, action: #selector(donePressed))
        
        toolbar.sizeToFit()
        toolbar.setItems([doneButton], animated: true)
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.frame.size = CGSize(width: self.frame.width, height: keyboardFrame.height)
        memoTextView.inputAccessoryView = toolbar
        memoTextView.inputView = datePicker
        memoTextView.reloadInputViews()
        completeButton.isEnabled = false
    }
    
    @objc func donePressed(){
        //formatter
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none

        date = datePicker.date
        let imageAttachment = NSTextAttachment()
        imageAttachment.image = UIImage(systemName: "pencil")
        imageAttachment.image = UIImage(systemName: "pencil")?.withTintColor(.black)
        
        let fullString = NSMutableAttributedString(string: getDateString() + " ")
        fullString.append(NSAttributedString(attachment: imageAttachment))
        dateLabelView.attributedText = fullString
//        dateLabelView.text = getDateString() + " ✎"
        memoTextView.inputAccessoryView = nil
        memoTextView.inputView = nil
        memoTextView.reloadInputViews()
        completeButton.isEnabled = true
    }
}

// MARK: - Keyboard Notification

extension RecordCreationView {
    @objc
    func keyboardWillShow(_ sender: Notification) {
        if let userInfo = sender.userInfo as? Dictionary<String, Any> {
            if let keyboardFrameValue = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
                keyboardFrame = keyboardFrameValue.cgRectValue
                
                self.bottomConstraint?.update(offset: -keyboardFrame.height - 20)
                self.setNeedsLayout()
                
                UIView.animate(withDuration: 0.4, animations: {
                    self.layoutIfNeeded()
                })
            }
        }
    }
    
    @objc
    func keyboardWillHide(_ sender: Notification) {
        self.bottomConstraint?.update(offset:-createRecordViewBottomOffset)
        self.setNeedsLayout()
        
        UIView.animate(withDuration: 0.4, animations: {
            self.layoutIfNeeded()
        })
    }
}

// MARK: - Button Press

extension RecordCreationView {
    @objc func cancelButtonPressed() {
        impactFeedbackGenerator?.impactOccurred()
        memoTextView.endEditing(true)
        completeButton.setTitleColor(UIColor(r: 163, g: 173, b: 178), for: .normal)
        cancelButton.setTitleColor(.black, for: .normal)
        cancelButton.isEnabled = false
        UIView.animate(withDuration: 0.7, delay: 0.0, animations: { [self] in
            completeButtonIcon.center.x = cancelButton.center.x + 4
        }) { (completed) in
            self.cancelButton.isEnabled = true
            if let d = self.delegate {
                d.dismissCreateRecordView()
            }
        }
    }
    
    @objc func completeButtonPressed() {
        feedbackGenerator?.notificationOccurred(.success)
        if let d = self.delegate {
            memoTextView.endEditing(true)
            d.completeCreateRecordView()
            d.saveRecord(newDate: date,
                         newGagueLevel: d.getGaugeLevel(),
                         newMemo: memoTextView.text)
            UserDefaults.shared.set(false, forKey: "guideAvail")
        }
    }
}

// MARK: - set textview setting

extension RecordCreationView: UITextViewDelegate {
    
    func textViewDidChange(_ textView: UITextView) {
        if textView.text.count > 180 {
            textView.deleteBackward()
        }
        if textView.numberOfLine() >= textView.textContainer.maximumNumberOfLines {
            textView.deleteBackward()
        }
        completeButton.isEnabled = false
        let finalText = textView.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        if finalText.count > 0 {
            completeButton.isEnabled = true
        }
        byteView.text = "\(textView.text.count)/180"
    }
}
extension UITextView {
    func numberOfLine() -> Int {
        if let font = self.font {
            let rows = round((self.contentSize.height - self.textContainerInset.top - self.textContainerInset.bottom) / font.lineHeight)
            return Int(rows)
        } else {
            print("Cannot get font size")
            return 0
        }
    }
}

// MARK: - set components

extension RecordCreationView {
    private func setSeperateLine() {
        let seperateUpperView = UIView()
        seperateUpperView.snp.makeConstraints { make in
            make.top.equalTo(dateLabelView.snp.bottom).offset(10)
            make.leading.trailing.equalTo(memoTextView)
            make.height.equalTo(1)
            
            seperateUpperView.backgroundColor = .white
            self.addSubview(seperateUpperView)
        }
        
        let seperateUnderView = UIView()
        seperateUnderView.snp.makeConstraints { make in
            make.top.equalTo(seperateUpperView.snp.bottom)
            make.leading.trailing.equalTo(memoTextView)
            make.height.equalTo(1)
            
            seperateUnderView.backgroundColor = UIColor(r: 195, g: 201, b: 205)
            self.addSubview(seperateUnderView)
        }
    }
    
    private func getDateString() -> String {
        let df = DateFormatter()
        var dateString: String?
        
        df.dateFormat = "yyyy. M. d. HH:mm"
        df.locale = Locale(identifier:"ko_KR")
        dateString = df.string(from: date)
        return dateString ?? ""
    }
}
