import UIKit
import SnapKit

class MainViewController: UIViewController {
    private let launchedBefore = UserDefaults.standard.bool(forKey: "launchedBefore")
    private let userIDsetting = UserDefaults.standard.bool(forKey: "userIDsetting")
    
    @IBOutlet weak var canvasView: UIImageView!
    @IBOutlet weak var infoView: UIImageView!
    @IBOutlet weak var goToListButton: UIButton!
    @IBOutlet weak var goToSettingButton: UIButton!
    @IBOutlet weak var addRecordButton: UIButton!
    private let infoContentView = MainInfoView()
    private let greetingView = UILabel()
    private var detailView = RecordDetailView()
    private let mainViewLabel = UILabel()
    
    private let goToListIcon = UIImageView()
    private let goToSettingIcon = UIImageView()
    private let addRecordIcon = UIImageView()
    private var canvasRecordsView: MainRecordsView?
    
    private let themeManager = ThemeManager.shared
    private var records = [Record]()
    private var countOfRecordInCanvas: Int = defaultCountOfRecordInCanvas
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .black
    }
    
    override func loadView() {
        super.loadView()
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
        setMainViewConstraints()
        setMainViewUI()
        setButtonsTarget()
        setRecordsViewInCanvas()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        updateContext()
        canvasRecordsView?.setRecordViews(records: records, theme: themeManager.getThemeInstance())
        setInfoContentView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if userIDsetting == false {
            loadUserIdInputMode()
            UserDefaults.standard.synchronize()
        }
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
        addRecordButton.addTarget(self, action: #selector(addRecordButtonPressed), for: .touchUpInside)
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

// MARK: - Set UI

extension MainViewController {
    private func setMainViewUI() {
        view.backgroundColor = UIColor(r: 240, g: 240, b: 243)
        view.addSubview(goToListIcon)
        view.addSubview(goToSettingIcon)
        view.addSubview(addRecordIcon)
        setCanvasViewUI()
        setInfoViewUI()
        setListButtonsUI()
        setSettingButtonUI()
        setAddRecordingButtonUI()
        setMainViewLabel()
    }
    
    private func setCanvasViewUI() {
        canvasView.backgroundColor = .clear
        canvasView.image = UIImage(named: "CanvasView")
        canvasView.contentMode = .scaleAspectFill
        canvasView.isUserInteractionEnabled = true
    }
    
    private func setRecordsViewInCanvas() {
        // canvas ui의 frame, layout이 정해진 후 레코드뷰들을 생성해야 함
        canvasRecordsView = MainRecordsView(in: canvasView)
        canvasView.addSubview(canvasRecordsView!)
        // 메인 뷰에서 출력되는 숫자는 차후 유저디폴트로 세팅가능하게, 초기값은 10
        canvasRecordsView?.setRecordViewsCount(to: countOfRecordInCanvas)
        canvasRecordsView?.delegate = self
    }
    
    private func setInfoViewUI() {
        infoView.backgroundColor = .clear
        infoView.image = UIImage(named: "InfoView")
        infoView.contentMode = .scaleAspectFill
    }
    
    private func setListButtonsUI() {
        goToListButton.backgroundColor = .clear
        goToListButton.setImage(UIImage(named: "SmallBtnBackground"), for: .normal)
        goToListIcon.image = UIImage(named: "ListBtnIcon")
        goToListIcon.isUserInteractionEnabled = false
    }
    
    private func setSettingButtonUI() {
        goToSettingButton.backgroundColor = .clear
        goToSettingButton.setImage(UIImage(named: "SmallBtnBackground"), for: .normal)
        goToSettingIcon.image = UIImage(named: "SettingBtnIcon")
        goToSettingIcon.isUserInteractionEnabled = false
    }
    
    private func setAddRecordingButtonUI() {
        addRecordButton.backgroundColor = .clear
        addRecordButton.setImage(UIImage(named: "BigBtnBackground"), for: .normal)
        addRecordIcon.image = UIImage(named: "AddRecordBtnIcon")?.withRenderingMode(.alwaysTemplate)
        addRecordIcon.tintColor = UIColor(r: 163, g: 173, b: 178)
        addRecordIcon.isUserInteractionEnabled = false
    }
    
    private func setMainViewLabel() {
        mainViewLabel.backgroundColor = .clear
        mainViewLabel.text = "CANVAS"
        mainViewLabel.font = UIFont(name: "Helvetica", size: goToListButton.frame.size.height * 0.6 )
        mainViewLabel.textColor = UIColor(.black)
        mainViewLabel.textAlignment = .center
        mainViewLabel.frame.size = CGSize(width: mainViewLabel.intrinsicContentSize.width,
                                          height: mainViewLabel.intrinsicContentSize.height)
        view.addSubview(mainViewLabel)
        
        mainViewLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(canvasView.snp.top).offset(-10)
        }
    }
}

// MARK: - Set Layout / AutoLayout Refactoring 필요

extension MainViewController {
    private func setMainViewConstraints() {
        setCanvasViewConstraints()
        // CanvasView를 중심으로 layout 구성 (반드시 canvasView가 먼저 setting 되어야 한다.)
        setInfoViewConstraints()
        setListButtonConstraints()
        setSettingButtonConstraints()
        setAddRecordButtonConstraints()
    }
    
    private func setCanvasViewConstraints() {
        var viewWidth = view.frame.width * 0.925
        if UIScreen.main.bounds.height < 740 {
            viewWidth = view.frame.width * 0.825
            canvasView.frame.size = CGSize(width: viewWidth,
                                           height: viewWidth * 1.36)
            canvasView.center = CGPoint(x: view.frame.width / 2, y: view.frame.height * 0.425)
        } else {
        canvasView.frame.size = CGSize(width: viewWidth,
                                       height: viewWidth * 1.36)
        canvasView.center = CGPoint(x: view.frame.width / 2, y: view.frame.height * 0.425)
        }
        
    }
    
    private func setInfoViewConstraints() {
        let viewWidth = canvasView.frame.width
        let endOfCanvasView = canvasView.frame.origin.y + canvasView.frame.height
        
        infoView.frame.size = CGSize(width: viewWidth,
                                     height: viewWidth * 0.3)
        if UIScreen.main.bounds.height < 740 {
            infoView.frame.size = CGSize(width: viewWidth,
                                         height: viewWidth * 0.35)
        }
        infoView.frame.origin = CGPoint(x: canvasView.frame.origin.x,
                                        y: endOfCanvasView - (900 * 20 / view.frame.height))
    }
    
    private func setListButtonConstraints() {
        var margin = view.frame.width * 0.175 / 2
        var buttonSize = view.frame.height * 40 / 900
        if UIScreen.main.bounds.height < 740 {
            margin = view.frame.width * 0.3 / 2
            buttonSize = view.frame.width / 12
        }
        let buttonY = canvasView.frame.origin.y - buttonSize
        
        // Button
        goToListButton.frame.size = CGSize(width: buttonSize,
                                           height: buttonSize)
        goToListButton.frame.origin = CGPoint(x: margin,
                                              y: buttonY)
        // Icon
        goToListIcon.frame.size = CGSize(width: goToListButton.frame.width * 4 / 6,
                                         height: goToListButton.frame.width * 4 / 6)
        goToListIcon.center = goToListButton.center
    }
    
    private func setSettingButtonConstraints() {
        
        var margin = view.frame.width * 0.175 / 2
        var buttonSize = view.frame.height * 40 / 900
        if UIScreen.main.bounds.height < 740 {
            margin = view.frame.width * 0.3 / 2
            buttonSize = view.frame.width / 12
        }
        let buttonY = canvasView.frame.origin.y - buttonSize
        
        // Button
        goToSettingButton.frame.size = CGSize(width: buttonSize,
                                              height: buttonSize)
        goToSettingButton.frame.origin = CGPoint(x: view.frame.width - margin - buttonSize,
                                                 y: buttonY)
        // Icon
        goToSettingIcon.frame.size = CGSize(width: goToSettingButton.frame.width * 4 / 6,
                                            height: goToSettingButton.frame.width * 4 / 6)
        goToSettingIcon.center = goToSettingButton.center
    }
    
    private func setAddRecordButtonConstraints() {
        
        let endOfInfoView = infoView.frame.origin.y + infoView.frame.height
        
        //Button
        addRecordButton.frame.size = CGSize(width: view.frame.height * 80 / 900,
                                            height: view.frame.height * 80 / 900)
        if UIScreen.main.bounds.height < 740 {
            addRecordButton.frame.size = CGSize(width: view.frame.height * 45 / 900,
                                                height: view.frame.height * 45 / 900)
        }
        addRecordButton.center = CGPoint(x: view.frame.width / 1.95, y: 0)
        addRecordButton.frame.origin.y = endOfInfoView + (view.frame.height * 0.03)
        // Icon
        addRecordIcon.frame.size = CGSize(width: addRecordButton.frame.width * 0.35,
                                          height: addRecordButton.frame.width * 0.35)
        addRecordIcon.center = CGPoint(x: view.frame.width / 2, y: addRecordButton.center.y)
    }
}

// MARK: - set info Content view in info view
extension MainViewController: MainInfoViewDelegate {
    func getInfoDateString() -> String {
        let recordCount = records.count
        let df = DateFormatter()
        
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
        } else if recordCount == 0 {
            let date = df.string(from: records[0].createdDate ?? Date())
            return date
        } else {
            return ""
        }
    }
    
    func setInfoContentView() {
        infoContentView.delegate = self
        infoContentView.frame.size = CGSize(width: infoView.frame.width * 0.8,
                                            height: infoView.frame.height * 0.7)
        infoContentView.center = CGPoint(x: infoView.frame.width / 2,
                                         y: infoView.frame.height * 0.4)
        infoContentView.backgroundColor = .clear
        // TODO: - 개수가 있을 때만, 작동하도록 해야 함. 아닐 때는 추가해보라는 설명이 들어가야 함.
        if records.count > 0 {
            greetingView.removeFromSuperview()
            infoContentView.setDateLabel()
            infoContentView.setInfoViewContentSize()
            infoContentView.setInfoViewContentLayout()
            infoView.addSubview(infoContentView)
        } else {
            greetingView.lineBreakMode = .byWordWrapping
            greetingView.numberOfLines = 0
            greetingView.text = "안녕하세요 \(UserDefaults.standard.string(forKey: "userID") ?? "User")님!\n언제든 감정 기록을 추가하여\n나만의 그림을 완성해보세요!"
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
            greetingView.center = infoView.center
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
    }
    
    func tapActionRecordView() {
    }
}

extension UIStatusBarStyle {
    static var black: UIStatusBarStyle {
        if #available(iOS 13.0, *) {
            return .darkContent
        }
        return .default
    }
}
