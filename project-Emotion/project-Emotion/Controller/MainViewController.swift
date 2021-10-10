
import UIKit
import TweenKit

class MainViewController: UIViewController {
    
    @IBOutlet weak var addRecordButton: UIButton!
    @IBOutlet weak var gotoSettingButton: UIButton!
    
    @IBOutlet weak var dateForwardButton: UIButton!
    @IBOutlet weak var dateBackwardButton: UIButton!
    @IBOutlet weak var dateLabel: UILabel!
    
    @IBOutlet weak var selectDateView: UIView!
    @IBOutlet weak var selectDayButton: UIButton!
    @IBOutlet weak var selectWeekButton: UIButton!
    @IBOutlet weak var selectMonthButton: UIButton!
    
    let userDefaults = UserDefaults.standard
    
    private var currentRecords: [Record] = [Record]()
    
    private var theme = ThemeManager.shared.getThemeInstance()
    private let dateManager = DateManager.shared
    private let recordManager = RecordManager.shared
    
    
    var recordViews: [UIView]?
    let viewCounts: Int = 5
    private let scheduler = ActionScheduler()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // core data에서 모든 기록데이터를 로드
        //view.addSubview(testView)
        //view.addSubview(testView2)
        
        getUserDefault()
        setAddRecordButton()
        setDateButtons()
        setDateLabel()
        setSelectDateView()
        
    }
    override func viewWillAppear(_ animated: Bool) {

        scheduler.removeAll()
        // core data에 추가된 데이터가 있을수 있으므로 뷰의 데이터를 리로드
        theme = ThemeManager.shared.getThemeInstance()
        self.view.backgroundColor = theme.getColor().view.main
        
        recordViews = setRecordViews(counts: viewCounts)
        for i in 0..<viewCounts {
            if let views = recordViews {
                view.addSubview(views[i])
                actionMoveFrame(from: views[i].center, to: view.center, view: views[i])
            }
        }
        currentRecords = recordManager.getMatchingRecords()
        
        print(view.subviews.count)
        print(recordViews?.count)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        // MARK: - 기존에 뷰에 추가되었던 서브뷰들을 제거 : 흐음 근데 이 방법이 최선인가? 메인뷰로 갈때마다 생성 삭제를 반복하는게 최선일까요?
        // 변경사항이 있을 경우 (새로운 서브뷰가 추가될때)만 그 뷰만 추가되고 삭제되면 더 좋을거 같다.
        if let views = recordViews {
            for view in views {
                view.removeFromSuperview()
            }
        }
    }
    
    private func setSelectDateView() {
        
        selectDateView.backgroundColor = .clear
        selectDateView.frame.size = CGSize(width: view.frame.width * 0.7, height: 50)
        selectDateView.center = CGPoint(x: view.frame.width / 2, y: view.frame.height * 0.15)
        
        selectDayButton.frame.size = CGSize(width: selectDateView.frame.width * 0.3, height: selectDateView.frame.height * 0.8)
        selectDayButton.center = CGPoint(x: selectDateView.frame.width * 0.25, y: selectDateView.frame.height / 2)
        selectDayButton.setTitle("Day", for: .normal)
        selectDayButton.addTarget(self, action: #selector(changeDateModeToDate), for: .touchUpInside)
        
        selectWeekButton.frame.size = CGSize(width: selectDateView.frame.width * 0.3, height: selectDateView.frame.height * 0.8)
        selectWeekButton.center = CGPoint(x: selectDateView.frame.width * 0.5, y: selectDateView.frame.height / 2)
        selectWeekButton.setTitle("Week", for: .normal)
        selectWeekButton.addTarget(self, action: #selector(changeDateModeToWeek), for: .touchUpInside)
        
        selectMonthButton.frame.size = CGSize(width: selectDateView.frame.width * 0.3, height: selectDateView.frame.height * 0.8)
        selectMonthButton.center = CGPoint(x: selectDateView.frame.width * 0.75, y: selectDateView.frame.height / 2)
        selectMonthButton.setTitle("Month", for: .normal)
        selectMonthButton.addTarget(self, action: #selector(changeDateModeToMonth), for: .touchUpInside)
    }
    
    @objc func changeDateModeToDate() {
        
        dateManager.setDateMode(newMode: 0)
        dateLabel.text = dateManager.getCurrentDateString()
        currentRecords = recordManager.getMatchingRecords()
    }
    
    @objc func changeDateModeToWeek() {
        
        dateManager.setDateMode(newMode: 1)
        dateLabel.text = dateManager.getCurrentDateString()
        currentRecords = recordManager.getMatchingRecords()
    }
    
    @objc func changeDateModeToMonth() {
        
        dateManager.setDateMode(newMode: 2)
        dateLabel.text = dateManager.getCurrentDateString()
        currentRecords = recordManager.getMatchingRecords()
    }
    
    private func setDateLabel() {
        
        dateLabel.frame.size = CGSize(width: 300, height: 50)
        dateLabel.center = CGPoint(x: view.frame.width * 0.5, y: view.frame.height * 0.2)
        dateLabel.text = dateManager.getCurrentDateString()
        dateLabel.textAlignment = .center
        dateLabel.textColor = .black
    }
    
    private func setDateButtons() {
        
        setDateForwardButton()
        setDateBackwardButton()
    }
    
    private func setDateBackwardButton() {
        
        dateBackwardButton.frame.size = CGSize(width: 50, height: 50)
        dateBackwardButton.center = CGPoint(x: view.frame.width * 0.2, y: view.frame.height * 0.2)
        dateBackwardButton.setImage(UIImage(systemName: "chevron.backward"), for: .normal)
        dateBackwardButton.addTarget(self, action: #selector(dateBackwardButtonPressed), for: .touchUpInside)
        dateBackwardButton.backgroundColor = .clear
        dateBackwardButton.setTitle("", for: .normal)
    }
    
    private func setDateForwardButton() {
        
        dateForwardButton.frame.size = CGSize(width: 50, height: 50)
        dateForwardButton.center = CGPoint(x: view.frame.width * 0.8, y: view.frame.height * 0.2)
        dateForwardButton.setImage(UIImage(systemName: "chevron.forward"), for: .normal)
        dateForwardButton.addTarget(self, action: #selector(dateForwardButtonPressed), for: .touchUpInside)
        dateForwardButton.backgroundColor = .clear
        dateForwardButton.setTitle("", for: .normal)
    }
    
    @objc func dateForwardButtonPressed() {
        
        dateManager.changeDate(val: 1)
        dateLabel.text = dateManager.getCurrentDateString()
        currentRecords = recordManager.getMatchingRecords()
    }
    
    @objc func dateBackwardButtonPressed() {
        
        dateManager.changeDate(val: -1)
        dateLabel.text = dateManager.getCurrentDateString()
        currentRecords = recordManager.getMatchingRecords()
        
    }
    
    func setAddRecordButton() {
        
        let mainViewWidth = self.view.frame.width
        let mainViewHeight = self.view.frame.height
        let buttonSize = mainViewWidth * 0.2
        
        addRecordButton.frame.size = CGSize(width: buttonSize, height: buttonSize)
        addRecordButton.center = CGPoint(x: mainViewWidth / 2, y: mainViewHeight - (mainViewWidth / 4))
    }
    // MARK: - Get User Default
    func getUserDefault() {
        let themeValue = userDefaults.integer(forKey: userDefaultColor)
        ThemeManager.shared.setUserThemeValue(themeValue: themeValue)
    }

    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // if 메인에서 게이지뷰로 전달할 데이터가 있으면 전달.
        //guard let gaugeViewController = segue.destination as? GaugeViewController else { return }
    }
    
    @IBAction func pressedAddRecordButton(_ sender: UIButton) {
        performSegue(withIdentifier: "mainToGauge", sender: nil)
    }
    
    @IBAction func pressedGotoSettingButton(_ sender: UIButton) {
        performSegue(withIdentifier: "mainToSetting", sender: nil)
    }
    
}
// MARK: - Set SVG Location

extension MainViewController {
    func setRecordViews(counts: Int) -> [UIView] {
        var views = [UIView]()
        
        for _ in 0 ..< counts {
            let view = UIView()
            // coredata에서 그림 삽입.
            setRandomLocation(view: view)
            view.backgroundColor = .brown
            view.frame.size = CGSize(width: 50, height: 50)
            
            views.append(view)
        }
        
        return views
        
    }
    
    func setRandomLocation(view: UIView) {
        // 뷰 범위를 벗어나지 않기 위해서 safe area추가
        let maxX = self.view.frame.maxX //self.superview.frame.maxX
        let maxY = self.view.frame.maxY
        let minX: CGFloat = 0
        let minY: CGFloat = 0
        
        view.center = CGPoint(x: CGFloat.random(in: minX...maxX), y: CGFloat.random(in: minY...maxY))
    }
    
    func setRecordViewLocation(viewCount: Int) {
//        switch viewCount {
//        case 0...10:
//            print("10")
//        case 11...20:
//            print("20")
//        default:
//            print("Too many")
//        }
    }
}

// MARK: - Animation
extension MainViewController {
    
    func actionMoveFrame(from: CGPoint, to: CGPoint, view: UIView) {
        
        let fromRect = CGRect(origin: from, size: view.frame.size)
        let toRect = CGRect(origin: to, size: view.frame.size)
        let duration = 1.0
        let action = InterpolationAction(from: fromRect, to: toRect, duration: duration, easing: .exponentialInOut) {
            view.frame = $0
        }
        scheduler.run(action: action.yoyo().repeatedForever())
        
    }
}
