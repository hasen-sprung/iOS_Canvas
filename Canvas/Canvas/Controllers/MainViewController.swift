import UIKit
import SnapKit

class MainViewController: UIViewController {
    // Data
    private let launchedBefore = UserDefaults.standard.bool(forKey: "launchedBefore")
    private let userIDsetting = UserDefaults.standard.bool(forKey: "userIDsetting")
    private let themeManager = ThemeManager.shared
    private var records = [Record]()
    
    // Main views
    private var mainCanvasView: UIView = UIView()
    private var mainInfoView: UIView = UIView()
    private var mainAddRecordButton: UIButton = UIButton()
    @IBOutlet weak var goToListButton: UIButton!
    @IBOutlet weak var goToSettingButton: UIButton!
    private let mainViewLabel = UILabel()
    
    // Main views images
    private let addRecordIcon = UIImageView()
    private let goToListIcon = UIImageView()
    private let goToSettingIcon = UIImageView()
    
    // Sub views
    private var mainCanvasSubview: UIView = UIView()
    private var canvasRecordsView: MainRecordsView?
    private let infoContentView = MainInfoView()
    private let greetingView = UILabel()
    private var detailView = RecordDetailView()
    
    
    private var isFirstInitInMainView: Bool = false
    private var countOfRecordInCanvas: Int = defaultCountOfRecordInCanvas
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .black
    }
    
    override func loadView() {
        super.loadView()
        // MARK: - DEVELOP - init seedData :
        DataHelper.shared.loadSeeder()
        // 처음 앱을 실행되었을 때 = 코어데이터에 아무것도 없는 상태이기 때문에, 레코드들의 위치정보를 제공해줘야 한다.
        if launchedBefore == false {
            UserDefaults.standard.set(true, forKey: "launchedBefore")
            UserDefaults.standard.set("Canvas", forKey: "canvasTitle")
            UserDefaults.standard.set(true, forKey: "shakeAvail")
            UserDefaults.standard.synchronize()
            // MARK: - init position by Default Ratio
            // 레코드들의 포지션 정보(비율)를 초기화
            for i in 0..<countOfRecordInCanvas {
                let context = CoreDataStack.shared.managedObjectContext
                let position = Position(context: context)
                
                position.xRatio = Ratio.DefaultRatio[i].x
                position.yRatio = Ratio.DefaultRatio[i].y
                CoreDataStack.shared.saveContext()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(r: 240, g: 240, b: 243)
        setAutoLayout()
        setButtonsTarget()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        updateContext()
        canvasRecordsView?.setRecordViews(records: records, theme: themeManager.getThemeInstance())
        setInfoContentView()
    }
    
    override func viewDidLayoutSubviews() {
        // MARK: - 초기값에 프레임이 없기 때문에 여기에서 한번 무조건 초기화를 해줘야함
        if !isFirstInitInMainView {
            isFirstInitInMainView = true
            print("Set shadow in main")
            setShadows(mainInfoView)
            setShadows(mainCanvasView)
            setShadows(mainAddRecordButton, firstRadius: 36, secondRadius: 13, thirdRadius: 7)
            
            setRecordsViewInCanvas()
            canvasRecordsView?.setRecordViews(records: records, theme: themeManager.getThemeInstance())
            setInfoContentView()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if userIDsetting == false {
            loadUserIdInputMode()
            UserDefaults.standard.synchronize()
        }
        print(mainCanvasView.frame)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        canvasRecordsView?.clearRecordViews()
    }
    
    private func updateContext() {
        let context = CoreDataStack.shared.managedObjectContext
        let request = Record.fetchRequest()
        
        do {
            records = try context.fetch(request)
        } catch { print("context Error") }
        records.sort(by: {$0.createdDate?.timeIntervalSinceNow ?? Date().timeIntervalSinceNow > $1.createdDate?.timeIntervalSinceNow ?? Date().timeIntervalSinceNow})
    }
    
    private func loadUserIdInputMode() {
        guard let nextVC = self.storyboard?.instantiateViewController(identifier: "userIdInputViewController") as? UserIdInputViewController else { return }
        transitionVc(vc: nextVC, duration: 0.5, type: .fromBottom)
    }
}

// MARK: - Auto Layout & Set Subviews

extension MainViewController {
    private func setAutoLayout() {
        // MARK: - Main Views Layout
        mainViewLabel.snp.makeConstraints { make in
            mainViewLabel.backgroundColor = .clear
            mainViewLabel.text = "CANVAS"
            mainViewLabel.font = UIFont(name: "JosefinSans-Regular", size: CGFloat(fontSize))
            mainViewLabel.textColor = textColor
            mainViewLabel.textAlignment = .center
            mainViewLabel.frame.size = CGSize(width: mainViewLabel.intrinsicContentSize.width,
                                              height: mainViewLabel.intrinsicContentSize.height)
            make.centerX.equalTo(self.view)
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top).offset(paddingInSafeArea + 10)
            view.addSubview(mainViewLabel)
        }
        goToListButton.snp.makeConstraints { make in
            goToListButton.backgroundColor = .clear
            goToListButton.setImage(UIImage(named: "SmallBtnBackground"), for: .normal)
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top).offset(paddingInSafeArea)
            make.leading.equalTo(self.view.safeAreaLayoutGuide.snp.leading).offset(paddingInSafeArea)
            make.size.equalTo(buttonSize)
        }
        goToSettingButton.snp.makeConstraints { make in
            goToSettingButton.backgroundColor = .clear
            goToSettingButton.setImage(UIImage(named: "SmallBtnBackground"), for: .normal)
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top).offset(paddingInSafeArea)
            make.trailing.equalTo(self.view.safeAreaLayoutGuide.snp.trailing).offset(-paddingInSafeArea)
            make.size.equalTo(buttonSize)
        }
        mainAddRecordButton.snp.makeConstraints { make in
            mainAddRecordButton.backgroundColor = .clear
            make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom).offset(-paddingInSafeArea)
            make.centerX.equalTo(self.view)
            make.size.equalTo(addButtonSize)
            view.addSubview(mainAddRecordButton)
        }
        mainInfoView.snp.makeConstraints { make in
            mainInfoView.backgroundColor = .white
            make.leading.equalTo(self.view.safeAreaLayoutGuide.snp.leading).offset(paddingInSafeArea)
            make.trailing.equalTo(self.view.safeAreaLayoutGuide.snp.trailing).offset(-paddingInSafeArea)
            make.bottom.equalTo(mainAddRecordButton.snp.top).offset(-paddingInSafeArea)
            make.height.equalTo(infoHeight)
            view.addSubview(mainInfoView)
        }
        mainCanvasView.snp.makeConstraints { make in
            mainCanvasView.backgroundColor = .white
            make.top.equalTo(goToListButton.snp.bottom).offset(paddingInSafeArea)
            make.leading.equalTo(self.view.safeAreaLayoutGuide.snp.leading).offset(paddingInSafeArea)
            make.trailing.equalTo(self.view.safeAreaLayoutGuide.snp.trailing).offset(-paddingInSafeArea)
            make.bottom.equalTo(mainInfoView.snp.top).offset(-paddingInSafeArea)
            view.addSubview(mainCanvasView)
        }
        mainCanvasSubview.snp.makeConstraints { make in
            mainCanvasSubview.backgroundColor = canvasColor
            make.edges.equalTo(mainCanvasView).inset(8)
            view.addSubview(mainCanvasSubview)
        }
        
        // MARK: - Icons Layout
        goToListIcon.snp.makeConstraints { make in
            goToListIcon.image = UIImage(named: "ListBtnIcon")
            goToListIcon.isUserInteractionEnabled = false
            make.size.equalTo(goToListButton).multipliedBy(iconSizeRatio)
            make.center.equalTo(goToListButton)
            view.addSubview(goToListIcon)
        }
        goToSettingIcon.snp.makeConstraints { make in
            goToSettingIcon.image = UIImage(named: "SettingBtnIcon")
            goToSettingIcon.isUserInteractionEnabled = false
            make.size.equalTo(goToSettingButton).multipliedBy(iconSizeRatio)
            make.center.equalTo(goToSettingButton)
            view.addSubview(goToSettingIcon)
        }
        addRecordIcon.snp.makeConstraints { make in
            addRecordIcon.image = UIImage(named: "AddRecordBtnIcon")?.withRenderingMode(.alwaysTemplate)
            addRecordIcon.tintColor = UIColor(r: 163, g: 173, b: 178)
            addRecordIcon.isUserInteractionEnabled = false
            make.size.equalTo(mainAddRecordButton).multipliedBy(0.35)
            make.center.equalTo(mainAddRecordButton)
            view.addSubview(addRecordIcon)
        }
    }
    
    private func setRecordsViewInCanvas() {
        // canvas ui의 frame, layout이 정해진 후 레코드뷰들을 생성해야 함
        canvasRecordsView = MainRecordsView(in: mainCanvasSubview)
        if let recordsView = canvasRecordsView {
            mainCanvasSubview.addSubview(recordsView)
            // 메인 뷰에서 출력되는 숫자는 차후 유저디폴트로 세팅가능하게, 초기값은 10
            recordsView.setRecordViewsCount(to: countOfRecordInCanvas)
            recordsView.delegate = self
        }
    }
}

// MARK: - Set Motion and Gesture

extension MainViewController {
    override func motionBegan(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        let isShake = UserDefaults.standard.bool(forKey: "shakeAvail")
        
        if isShake && motion == .motionShake {
            canvasRecordsView?.setRandomPosition()
            canvasRecordsView?.clearRecordViews()
            canvasRecordsView?.setRecordViews(records: records, theme: themeManager.getThemeInstance())
            motionEnded(motion, with: event)
        }
    }
}

// MARK: - Set Buttons Target

extension MainViewController {
    private func setButtonsTarget() {
        mainAddRecordButton.addTarget(self, action: #selector(addRecordButtonPressed), for: .touchUpInside)
        goToListButton.addTarget(self, action: #selector(goToListButtonPressed), for: .touchUpInside)
        goToSettingButton.addTarget(self, action: #selector(goToSettingPressed), for: .touchUpInside)
    }
    
    @objc func addRecordButtonPressed(_ sender: UIButton) {
        guard let nextVC = self.storyboard?.instantiateViewController(identifier: "gaugeViewController") as? GaugeViewController else { return }
        
        nextVC.modalTransitionStyle = .coverVertical
        nextVC.modalPresentationStyle = .fullScreen
        self.present(nextVC, animated: true, completion: nil)
    }
    
    @objc func goToListButtonPressed(_ sender: UIButton) {
        guard let nextVC = self.storyboard?.instantiateViewController(identifier: "listTableViewController") as? ListTableViewController else { return }
        transitionVc(vc: nextVC, duration: 0.5, type: .fromLeft)
    }
    
    @objc func goToSettingPressed(_ sender: UIButton) {
        guard let nextVC = self.storyboard?.instantiateViewController(identifier: "settingViewController") as? SettingViewController else { return }
        transitionVc(vc: nextVC, duration: 0.5, type: .fromRight)
    }
}

// MARK: - set info Content view in info view
extension MainViewController: MainInfoViewDelegate {
    func getInfoDateString() -> String {
        var recordCount = records.count
        let df = DateFormatter()
        if recordCount > 10 {
            recordCount = 10
        }
        df.dateFormat = "yyyy. M. d"
        df.locale = Locale(identifier:"ko_KR")
        if recordCount >= 1 {
            let firstDate = df.string(from: records[recordCount - 1].createdDate ?? Date())
            let lastDate = df.string(from: records[0].createdDate ?? Date())
            if firstDate == lastDate {
                return firstDate
            } else {
                return firstDate + " ~ " + lastDate
            }
        } else {
            return ""
        }
    }
    
    // MARK: - infoContentView가 계속 쌓이는 거 아닌가???
    
    func setInfoContentView() {
        infoContentView.delegate = self
        infoContentView.backgroundColor = .clear
        
        // TODO: - 개수가 있을 때만, 작동하도록 해야 함. 아닐 때는 추가해보라는 설명이 들어가야 함.
        if records.count > 0 {
            infoContentView.snp.makeConstraints { make in
                make.edges.equalTo(mainInfoView).inset(10)
                view.addSubview(infoContentView)
            }
            greetingView.removeFromSuperview()
            infoContentView.setDateLabel()
            infoContentView.setInfoViewContentSize()
            infoContentView.setInfoViewContentLayout()
        } else {
            greetingView.lineBreakMode = .byWordWrapping
            greetingView.numberOfLines = 0
            greetingView.text = "안녕하세요 \(UserDefaults.standard.string(forKey: "userID") ?? "무명작가")님!\n언제든 감정 기록을 추가하여\n나만의 그림을 완성해보세요!"
            greetingView.font = UIFont(name: "Pretendard-Regular", size: 14)
            greetingView.textColor = UIColor(r: 72, g: 80, b: 84)
            
            let attrString = NSMutableAttributedString(string: greetingView.text ?? "")
            let paragraphStyle = NSMutableParagraphStyle()
            
            paragraphStyle.lineSpacing = 5
            attrString.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle, range: NSMakeRange(0, attrString.length))
            greetingView.attributedText = attrString
            greetingView.textAlignment = .center
            greetingView.frame.size = CGSize(width: greetingView.intrinsicContentSize.width,
                                             height: greetingView.intrinsicContentSize.height)
            greetingView.center = mainInfoView.center
            view.addSubview(greetingView)
        }
    }
}

// MARK: - MainRecordsViewDelegate

extension MainViewController: MainRecordsViewDelegate {
    func openRecordTextView(index: Int) {
        let df = DateFormatter()
        
        df.dateFormat = "M / d EEEE HH:mm"
        if index <= records.count - 1 {
            detailView = RecordDetailView()
            detailView.frame = view.frame
            view.addSubview(detailView)
            detailView.setDetailView()
            detailView.shapeImage.image = DefaultTheme.shared.getImageByGaugeLevel(gaugeLevel: Int(records[index].gaugeLevel))
            detailView.shapeImage.tintColor = DefaultTheme.shared.getColorByGaugeLevel(gaugeLevel: Int(records[index].gaugeLevel))
            detailView.dateLabel.text = df.string(from: records[index].createdDate ?? Date())
            detailView.memo.text = records[index].memo
        } else {
            detailView = RecordDetailView()
            detailView.frame = view.frame
            view.addSubview(detailView)
            detailView.setDetailView()
            detailView.memo.text = DefaultRecord.records[index].memo//"이곳에 랜덤한 설명이 들어갑니다."
        }
        
        let attrString = NSMutableAttributedString(string: detailView.memo.text ?? "")
        let paragraphStyle = NSMutableParagraphStyle()
        
        paragraphStyle.lineSpacing = 5
        attrString.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle, range: NSMakeRange(0, attrString.length))
        detailView.memo.attributedText = attrString
        detailView.memo.textAlignment = .left
        detailView.memo.textColor = UIColor(r: 41, g: 46, b: 48)
        detailView.memo.font = UIFont(name: "Pretendard-Regular", size: 15)
    }
    
    func tapActionRecordView() {
    }
}
