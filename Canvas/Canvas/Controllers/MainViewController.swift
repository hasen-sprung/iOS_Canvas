import UIKit
import SnapKit

class MainViewController: UIViewController {
    
    @IBOutlet weak var canvasView: UIImageView!
    @IBOutlet weak var infoView: UIImageView!
    @IBOutlet weak var goToListButton: UIButton!
    @IBOutlet weak var goToSettingButton: UIButton!
    @IBOutlet weak var addRecordButton: UIButton!
    private let infoContentView = MainInfoView()
    
    private let goToListIcon = UIImageView()
    private let goToSettingIcon = UIImageView()
    private let addRecordIcon = UIImageView()
    private var canvasRecordsView: MainRecordsView?
    
    private let themeManager = ThemeManager.shared
    private var records = [Record]()
    
    private let launchedBefore = UserDefaults.standard.bool(forKey: "launchedBefore")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 첫 실행시, user ID 정해주는 부분.
        if launchedBefore == false {
            print("firstLoad")
            UserDefaults.standard.set(true, forKey: "launchedBefore")
            // TODO: - 처음 런치 했을 때, userID 입력하는 단계 필요
            UserDefaults.standard.set("User", forKey: "userID")
            UserDefaults.standard.set("Canvas", forKey: "canvasTitle")
            UserDefaults.standard.synchronize()
        }
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
}

// MARK: - set Buttons Target
extension MainViewController {
    private func setButtonsTarget() {
        addRecordButton.addTarget(self, action: #selector(addRecordButtonPressed), for: .touchUpInside)
        goToListButton.addTarget(self, action: #selector(goToListButtonPressed), for: .touchUpInside)
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
        canvasRecordsView?.setRecordViewsCount(to: 10)
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
        addRecordButton.contentMode = .scaleToFill
        addRecordIcon.image = UIImage(named: "AddRecordBtnIcon")?.withRenderingMode(.alwaysTemplate)
        addRecordIcon.tintColor = UIColor(r: 163, g: 173, b: 178)
        addRecordIcon.isUserInteractionEnabled = false
    }
}

// MARK: - set Layout / autoLayout refactoring 필요
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
        let viewWidth = view.frame.width * 0.925
        
        canvasView.frame.size = CGSize(width: viewWidth,
                                       height: viewWidth * 1.36)
        canvasView.center = CGPoint(x: view.frame.width / 2, y: view.frame.height * 0.425)
        
    }
    
    private func setInfoViewConstraints() {
        let viewWidth = canvasView.frame.width
        let endOfCanvasView = canvasView.frame.origin.y + canvasView.frame.height
        
        infoView.frame.size = CGSize(width: viewWidth,
                                     height: viewWidth * 0.3)
        infoView.frame.origin = CGPoint(x: canvasView.frame.origin.x,
                                        y: endOfCanvasView - (900 * 20 / view.frame.height))
    }
    
    private func setListButtonConstraints() {
        let margin = view.frame.width * 0.175 / 2
        let buttonSize = view.frame.width / 10
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
        
        let margin = view.frame.width * 0.175 / 2
        let buttonSize = view.frame.width / 10
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
        addRecordButton.frame.size = CGSize(width: view.frame.width / 5,
                                            height: view.frame.width / 5)
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
        // TODO: - 10개를 가져와서 첫 date, 나중 date 뽑아서 string 만들어야 함.
        return ""
    }
    
    func setInfoContentView() {
        
        infoContentView.frame.size = CGSize(width: infoView.frame.width * 0.8,
                                            height: infoView.frame.height * 0.7)
        infoContentView.center = CGPoint(x: infoView.frame.width / 2,
                                         y: infoView.frame.height * 0.4)
        infoContentView.backgroundColor = .clear
        // TODO: - 개수가 있을 때만, 작동하도록 해야 함. 아닐 때는 추가해보라는 설명이 들어가야 함.
        infoContentView.setDateLabel()
        infoContentView.setInfoViewContentSize()
        infoContentView.setInfoViewContentLayout()
        infoView.addSubview(infoContentView)
    }
}

extension MainViewController: MainRecordsViewDelegate {
    func openRecordTextView(index: Int) {
        print("record touch and index: \(index)")
        // TODO: 더미 데이터 회색의 인덱스로 접근하면 터짐! 당연히 존재하지 않는 레코드니까...
        // 회색 10개에는 뭔가 도움말 같은 것을 추가하면 될 듯, 인사말 + 버튼눌러봐 등등
    }
    
    func tapActionRecordView() {
        // 레코드 뷰 내부를 터치했을 경우 취소시키는 기능인데 필요없을 듯?
        print("recordsview touched")
    }
}
