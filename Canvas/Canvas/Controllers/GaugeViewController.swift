import UIKit
import SnapKit
import CoreData

class GaugeViewController: UIViewController {
    private let launchedBefore = UserDefaults.standard.bool(forKey: "launchedGauge")
    private var gaugeWaveView: GaugeWaveAnimationView = {
        let view = GaugeWaveAnimationView(frame: UIScreen.main.bounds)
        return view
    }()
    private var createRecordView: CreateRecordView?
    private var cancelButton: UIView = UIView()
    private var shapeImage: UIImageView = UIImageView()
    private let theme = ThemeManager.shared.getThemeInstance()
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .black
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = bgColor
        setSubViews()
        setLayout()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        gaugeWaveView.startWaveAnimation()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if launchedBefore == false {
            UserDefaults.standard.set(true, forKey: "launchedGauge")
            let greetingLabel = UILabel()
            greetingLabel.text = "게이지를 끝까지 올리면 종료됩니다. :)"
            greetingLabel.font = UIFont(name: "Pretendard-Regular", size: 15)
            greetingLabel.textColor = UIColor(r: 72, g: 80, b: 84)
            greetingLabel.frame.size = CGSize(width: view.frame.width,
                                              height: 100)
            greetingLabel.textAlignment = .center
            greetingLabel.center = CGPoint(x: view.frame.width / 2, y: view.frame.height * 0.2)
            view.addSubview(greetingLabel)
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        gaugeWaveView.stopWaveAnimation()
    }
    
    private func setSubViews() {
        view.addSubview(gaugeWaveView)
        gaugeWaveView.delegate = self
        gaugeWaveView.setGaugeWaveView(with: theme.gradientColors,
                                       with: theme.changeGradientColors)
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
        let level = gaugeWaveView.getCurrentGaugeLevel()
        
        shapeImage.image = theme.getImageByGaugeLevel(gaugeLevel: level)
        shapeImage.tintColor = theme.getColorByGaugeLevel(gaugeLevel: level)
    }
    
    func cancelGaugeView() {
        UIView.animate(withDuration: 0.75, delay: 0.0, options: [.curveEaseOut], animations: { [self] in
            cancelButton.alpha = 0.0
            gaugeWaveView.bounds.origin.y = gaugeWaveView.bounds.origin.y - view.frame.height
        }) { (completed) in
            self.dismiss(animated: false, completion: nil)
        }
    }
    
    func createRecord() {
        if UIScreen.main.bounds.height < 740 {
            cancelButton.alpha = 0.0
        }
        createRecordView = CreateRecordView()
        createRecordView?.frame = view.frame
        createRecordView?.setCreateRecordView()
        createRecordView?.alpha = 0.0
        if let CRView = createRecordView {
            CRView.delegate = self
            CRView.fadeIn()
            view.addSubview(CRView)
        }
        UIView.animate(withDuration: 0.75, delay: 0.0, options: [.curveEaseOut], animations: { [self] in
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
        let context = CoreDataStack.shared.managedObjectContext//appDelegate.persistentContainer.viewContext
        let newRecord = Record(context: context)
        
        newRecord.createdDate = newDate
        newRecord.gaugeLevel = Int16(newGagueLevel)
        if let newMemo = newMemo {
            newRecord.memo = newMemo
        }
        CoreDataStack.shared.saveContext()
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
        completeCreateRecordView()
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
        changedGaugeLevel()
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
        shapeImage.image = UIImage(named: "default_7")
        cancelButton.addSubview(shapeImage)
    }
}
