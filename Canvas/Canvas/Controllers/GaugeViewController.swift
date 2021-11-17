import UIKit
import SnapKit
import CoreData

class GaugeViewController: UIViewController {
    private let recordManager = RecordManager.shared
    private var gaugeWaveView: GaugeWaveAnimationView = {
        let view = GaugeWaveAnimationView(frame: UIScreen.main.bounds)
        return view
    }()
    private var cancelButton: UIView = UIView()
    private var shapeImage: UIImageView = UIImageView()
    
    private var createRecordView: CreateRecordView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = bgColor
        setSubViews()
        setLayout()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        gaugeWaveView.startWaveAnimation()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        gaugeWaveView.stopWaveAnimation()
    }
    
    private func setSubViews() {
        view.addSubview(gaugeWaveView)
        gaugeWaveView.delegate = self
        setCancelButton(in: view)
    }
    
    private func setLayout() {
        gaugeWaveView.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
            make.leading.equalTo(self.view.safeAreaLayoutGuide.snp.leading)
            make.trailing.equalTo(self.view.safeAreaLayoutGuide.snp.trailing)
            make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom)
        }
        cancelButton.snp.makeConstraints { make in
            make.top.equalTo(view.snp.top).offset(view.frame.height * 0.075)
            make.centerX.equalToSuperview().offset(-view.frame.width / 7 / 2)
        }
    }
}

// MARK: - GaugeWaveAnimationView Delegate
extension GaugeViewController: GaugeWaveAnimationViewDelegate {
    func touchInCancelArea() {
        shapeImage.image = UIImage(named: "GaugeCancelIcon")
    }
    
    func changedGaugeLevel() {
        changeImage(level: gaugeWaveView.getCurrentGaugeLevel())
    }
    
    func cancelGaugeView() {
        UIView.animate(withDuration: 1.0, delay: 0.0, options: [.curveEaseOut], animations: { [self] in
            cancelButton.alpha = 0.0
            gaugeWaveView.bounds.origin.y = gaugeWaveView.bounds.origin.y - view.frame.height
        }) { (completed) in
            self.dismiss(animated: false, completion: nil)
        }
    }
    
    func createRecord() {
        createRecordView = CreateRecordView()
        createRecordView?.frame = view.frame
        createRecordView?.setCreateRecordView()
        createRecordView?.alpha = 0.0
        if let CRView = createRecordView {
            CRView.delegate = self
            CRView.fadeIn()
            view.addSubview(CRView)
        }
        UIView.animate(withDuration: 1.0, delay: 0.0, options: [.curveEaseOut], animations: { [self] in
            gaugeWaveView.bounds.origin.y = gaugeWaveView.bounds.origin.y - view.frame.height
        }) { (completed) in
            self.createRecordView?.setCRTextView()
        }
    }
}

// MARK: - Create Record View Delegate
extension GaugeViewController: CreateRecordViewDelegate {
    func getGaugeLevel() -> Int {
        return gaugeWaveView.getCurrentGaugeLevel()
    }
    
    func saveRecord(newDate: Date, newGagueLevel: Int, newMemo: String?) {
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            let context = appDelegate.persistentContainer.viewContext
            let newRecord = Record(context: context)
            
            newRecord.createdDate = newDate
            newRecord.gaugeLevel = Int16(newGagueLevel)
            if let newMemo = newMemo {
                newRecord.memo = newMemo
            }
            appDelegate.saveContext()
        }
        let paths = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)
        print(paths[0])
    }
    
    func completeCreateRecordView() {
        cancelButton.fadeOut()
        createRecordView?.fadeOut()
        self.gaugeWaveView.removeFromSuperview()
        let transition: CATransition = CATransition()
        transition.duration = 1.0
        transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        transition.type = CATransitionType.reveal
        transition.subtype = CATransitionSubtype.fromBottom
        self.view.window?.layer.add(transition, forKey: nil)
        self.dismiss(animated: false, completion: nil)
    }
    
    func dismissCreateRecordView() {
        createRecordView?.fadeOut()
        UIView.animate(withDuration: 1.0, delay: 0.0, options: [.curveEaseOut], animations: { [self] in
            gaugeWaveView.bounds.origin.y = gaugeWaveView.bounds.origin.y + view.frame.height
        }) { (completed) in
            self.createRecordView?.removeFromSuperview()
        }
    }
}

// MARK: - Set CancelButton and Shadows
extension GaugeViewController {
    private func setCancelButton(in superview: UIView) {
        let buttonSize = superview.frame.width / 7
        
        cancelButton.backgroundColor = .white
        cancelButton.frame = CGRect(origin: .zero, size: CGSize(width: buttonSize, height: buttonSize))
        setShadows(cancelButton, buttonSize: buttonSize)
        setShapeImage()
        superview.addSubview(cancelButton)
    }
    
    private func setShadows(_ view: UIView, buttonSize: CGFloat) {
        let shadows = UIView()
        
        shadows.frame = view.frame
        shadows.clipsToBounds = false
        view.addSubview(shadows)
        setLayer(shadows: shadows, cornerRadius: buttonSize * 0.25, color: UIColor(red: 0, green: 0, blue: 0, alpha: 0.06), opacity: 1, radius: buttonSize / 2, size: buttonSize / 10)
        setLayer(shadows: shadows, cornerRadius: buttonSize * 0.25, color: UIColor(red: 1, green: 1, blue: 1, alpha: 1), opacity: 1, radius: buttonSize / 5, size: -buttonSize / 12)
        setLayer(shadows: shadows, cornerRadius: buttonSize * 0.25, color: UIColor(red: 0.682, green: 0.682, blue: 0.753, alpha: 0.1), opacity: 1, radius: buttonSize / 9, size: buttonSize / 12, blender: true)
        
        let shapes = UIView()
        
        shapes.frame = view.frame
        shapes.clipsToBounds = true
        view.addSubview(shapes)
        
        let layer = CALayer()
        
        layer.backgroundColor = UIColor(red: 0.941, green: 0.941, blue: 0.953, alpha: 1).cgColor
        layer.bounds = shapes.bounds
        layer.position = shapes.center
        shapes.layer.addSublayer(layer)
        shapes.layer.cornerRadius = buttonSize / 4
    }
    
    private func setLayer(shadows: UIView, cornerRadius: CGFloat, color: UIColor, opacity: Float, radius: CGFloat, size: CGFloat, blender: Bool = false) {
        let shadowPath = UIBezierPath(roundedRect: shadows.bounds, cornerRadius: cornerRadius)
        let layer = CALayer()
        
        layer.shadowPath = shadowPath.cgPath
        layer.shadowColor = color.cgColor
        layer.shadowOpacity = opacity
        layer.shadowRadius = radius
        layer.shadowOffset = CGSize(width: size, height: size)
        if blender == true {
            layer.compositingFilter = "multiplyBlendMode"
        }
        layer.bounds = shadows.bounds
        layer.position = shadows.center
        shadows.layer.addSublayer(layer)
    }
    
    private func setShapeImage() {
        let size = cancelButton.frame.width / 1.8
        
        shapeImage.frame = CGRect(origin: .zero, size: CGSize(width: size, height: size))
        shapeImage.center = cancelButton.center
        shapeImage.image = UIImage(named: "image_6")
        cancelButton.addSubview(shapeImage)
    }
    
    private func changeImage(level: Int) {
        switch level {
        case 1...10:
            shapeImage.image = UIImage(named: "image_1")
        case 11...20:
            shapeImage.image = UIImage(named: "image_2")
        case 21...30:
            shapeImage.image = UIImage(named: "image_3")
        case 31...40:
            shapeImage.image = UIImage(named: "image_4")
        case 41...50:
            shapeImage.image = UIImage(named: "image_5")
        case 51...60:
            shapeImage.image = UIImage(named: "image_6")
        case 61...70:
            shapeImage.image = UIImage(named: "image_7")
        case 71...80:
            shapeImage.image = UIImage(named: "image_8")
        case 81...90:
            shapeImage.image = UIImage(named: "image_9")
        case 91...100:
            shapeImage.image = UIImage(named: "image_10")
        default:
            print("범위를 벗어남")
        }
    }
}
