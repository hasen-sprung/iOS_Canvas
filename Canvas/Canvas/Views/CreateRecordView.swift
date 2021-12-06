import UIKit
import SnapKit

protocol CreateRecordViewDelegate {
    func getGaugeLevel() -> Int
    func dismissCreateRecordView()
    func completeCreateRecordView()
    func saveRecord(newDate: Date, newGagueLevel: Int, newMemo: String?)
}

class CreateRecordView: UIView {
    var delegate: CreateRecordViewDelegate?
    private var date = Date()
    
    private let CRBackgroundView = UIView()
    private let CRBackgroundImageView = UIImageView()
    
    private let dateLabelView = UILabel()
    private var byteView = UILabel()
    private let CRTextView = UITextView()
    
    private let CRBtnBackgroundView = UIImageView()
    private let CRBtnIcon = UIImageView()
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
        CRBackgroundView.snp.makeConstraints { make in
            make.top.equalTo(self.snp.top).offset(self.frame.width / 7 * 2.5)
            make.leading.equalTo(self.snp.leading).offset(40)
            make.trailing.equalTo(self.snp.trailing).offset(-40)
            // TODO: KEYBOARD NOTIFICATION
            self.bottomConstraint = make.bottom.equalTo(self.snp.bottom).offset(-createRecordViewBottomOffset).constraint
            
            CRBackgroundView.backgroundColor = .clear
            CRBackgroundView.layer.cornerRadius = 10
            self.addSubview(CRBackgroundView)
        }
        CRBackgroundImageView.snp.makeConstraints { make in
            make.top.equalTo(CRBackgroundView).offset(-30)
            make.leading.equalTo(CRBackgroundView).offset(-20)
            make.trailing.equalTo(CRBackgroundView).offset(30)
            make.bottom.equalTo(CRBackgroundView).offset(30)
            
            CRBackgroundImageView.image = UIImage(named: "CreateBackground")
            self.addSubview(CRBackgroundImageView)
        }
        dateLabelView.snp.makeConstraints { make in
            make.top.equalTo(CRBackgroundView.snp.top).offset(10)
            make.centerX.equalTo(self.snp.centerX)
            
            dateLabelView.backgroundColor = .clear
            dateLabelView.text = getDateString()
            dateLabelView.font = UIFont(name: "Cardo-Regular", size: 17)
            dateLabelView.textColor = .black
            dateLabelView.textAlignment = .center
            dateLabelView.frame.size = CGSize(width: dateLabelView.intrinsicContentSize.width,
                                              height: dateLabelView.intrinsicContentSize.height)
            self.addSubview(dateLabelView)
        }
        
        changeDateButton.snp.makeConstraints { make in
            make.top.equalTo(CRBackgroundView.snp.top).offset(10)
            make.leading.equalTo(CRBackgroundView.snp.leading).offset(0)
            make.trailing.equalTo(CRBackgroundView.snp.trailing).offset(0)
            make.centerX.equalTo(self.snp.centerX)
            
            changeDateButton.backgroundColor = .clear
            changeDateButton.setTitle("", for: .normal)
            changeDateButton.addTarget(self, action: #selector(createDatePickerView), for: .touchUpInside)
            self.addSubview(changeDateButton)
        }
        
        CRBtnBackgroundView.snp.makeConstraints { make in
            make.leading.equalTo(CRBackgroundView.snp.leading).offset(30)
            make.trailing.equalTo(CRBackgroundView.snp.trailing).offset(-30)
            make.bottom.equalTo(CRBackgroundView.snp.bottom).offset(-20)
            make.height.equalTo(50)
            
            CRBtnBackgroundView.image = UIImage(named: "TextBtnBackground")
            CRBtnBackgroundView.isUserInteractionEnabled = false
            CRBtnBackgroundView.backgroundColor = .clear
            self.addSubview(CRBtnBackgroundView)
        }
        cancelButton.snp.makeConstraints { make in
            make.width.equalTo(CRBtnBackgroundView.snp.width).dividedBy(2)
            make.height.equalTo(CRBtnBackgroundView.snp.height)
            make.centerY.leading.equalTo(CRBtnBackgroundView)
            
            cancelButton.setTitle("취소", for: .normal)
            cancelButton.setTitleColor(UIColor(r: 163, g: 173, b: 178), for: .normal)
            cancelButton.titleLabel?.font = UIFont(name: "Pretendard-Regular", size: 15)
            cancelButton.backgroundColor = .clear
            cancelButton.addTarget(self, action: #selector(cancelButtonPressed), for: .touchUpInside)
            self.addSubview(cancelButton)
        }
        completeButton.snp.makeConstraints { make in
            make.width.equalTo(CRBtnBackgroundView.snp.width).dividedBy(2)
            make.height.equalTo(CRBtnBackgroundView.snp.height)
            make.centerY.trailing.equalTo(CRBtnBackgroundView)
            
            completeButton.setTitle("완료", for: .normal)
            completeButton.setTitleColor(.black, for: .normal)
            completeButton.titleLabel?.font = UIFont(name: "Pretendard-Regular", size: 15)
            completeButton.backgroundColor = .clear
            completeButton.addTarget(self, action: #selector(completeButtonPressed), for: .touchUpInside)
            self.addSubview(completeButton)
        }
        CRBtnIcon.snp.makeConstraints { make in
            make.height.width.equalTo(completeButton).offset(14)
            make.centerX.equalTo(completeButton)
            make.centerY.equalTo(completeButton).offset(2)
            
            CRBtnIcon.image = UIImage(named: "TextBtn")
            CRBtnIcon.backgroundColor = .clear
            self.addSubview(CRBtnIcon)
        }
        CRTextView.snp.makeConstraints { make in
            make.top.equalTo(dateLabelView.snp.bottom).offset(20)
            make.leading.equalTo(CRBackgroundView.snp.leading).offset(30)
            make.trailing.equalTo(CRBackgroundView.snp.trailing).offset(-30)
            make.bottom.equalTo(CRBtnBackgroundView.snp.top).offset(-20)
            
            CRTextView.delegate = self
            CRTextView.backgroundColor = .clear
            CRTextView.textContainer.maximumNumberOfLines = 15
            CRTextView.font = UIFont(name: "Pretendard-Regular", size: 16)
            CRTextView.textColor = .black
            CRTextView.becomeFirstResponder()
            CRTextView.isScrollEnabled = true
            self.addSubview(CRTextView)
        }
        byteView.snp.makeConstraints { make in
            make.bottom.equalTo(CRBtnBackgroundView.snp.top)
            make.trailing.equalTo(CRTextView)

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
        CRTextView.inputAccessoryView = toolbar
        CRTextView.inputView = datePicker
        CRTextView.reloadInputViews()
        completeButton.isEnabled = false
    }
    
    @objc func donePressed(){
        //formatter
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none

        date = datePicker.date
        dateLabelView.text = getDateString()
        CRTextView.inputAccessoryView = nil
        CRTextView.inputView = nil
        CRTextView.reloadInputViews()
        completeButton.isEnabled = true
    }
}

// MARK: - Keyboard Notification

extension CreateRecordView {
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

extension CreateRecordView {
    @objc func cancelButtonPressed() {
        impactFeedbackGenerator?.impactOccurred()
        CRTextView.endEditing(true)
        completeButton.setTitleColor(UIColor(r: 163, g: 173, b: 178), for: .normal)
        cancelButton.setTitleColor(.black, for: .normal)
        cancelButton.isEnabled = false
        UIView.animate(withDuration: 0.7, delay: 0.0, animations: { [self] in
            CRBtnIcon.center.x = cancelButton.center.x + 4
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
            CRTextView.endEditing(true)
            d.completeCreateRecordView()
            d.saveRecord(newDate: date,
                         newGagueLevel: d.getGaugeLevel(),
                         newMemo: CRTextView.text)
            UserDefaults.shared.set(false, forKey: "guideAvail")
        }
    }
}

// MARK: - set textview setting

extension CreateRecordView: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let existingLines = textView.text.components(separatedBy: CharacterSet.newlines)
        let newLines = text.components(separatedBy: CharacterSet.newlines)
        let linesAfterChange = existingLines.count + newLines.count - 1
        let newText = (textView.text as NSString).replacingCharacters(in: range, with: text)
        byteView.text = "\(newText.count)/180"
        return linesAfterChange <= textView.textContainer.maximumNumberOfLines && newText.count < 180
    }
}

// MARK: - set components

extension CreateRecordView {
    private func setSeperateLine() {
        let seperateUpperView = UIView()
        seperateUpperView.snp.makeConstraints { make in
            make.top.equalTo(dateLabelView.snp.bottom).offset(10)
            make.leading.trailing.equalTo(CRTextView)
            make.height.equalTo(1)
            
            seperateUpperView.backgroundColor = .white
            self.addSubview(seperateUpperView)
        }
        
        let seperateUnderView = UIView()
        seperateUnderView.snp.makeConstraints { make in
            make.top.equalTo(seperateUpperView.snp.bottom)
            make.leading.trailing.equalTo(CRTextView)
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
