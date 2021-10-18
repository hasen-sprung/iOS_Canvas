
import UIKit
import TweenKit
import Macaw

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
    
    @IBOutlet weak var recordAnimationView: RecordAnimationView!
    private let recordTableView = RecordTableView()
    private let recordModalLabel = UILabel()
    
    private var currentRecords: [Record] = [Record]()
    
    private let userDefaults = UserDefaults.standard
    private var theme = ThemeManager.shared.getThemeInstance()
    private let dateManager = DateManager.shared
    private let recordManager = RecordManager.shared
    
    private var changeSubViewToken = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        recordTableView.dataSource = self
        recordTableView.delegate = self
        
        getUserDefault()
        setAddRecordButton()
        setDateButtons()
        setDateLabel()
        setSelectDateView()
        
        setRecordTableView()
        setRecordAnimationView()
        setRecordModalLabel()
        
        view.addSubview(recordTableView)
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        
        // core data에 추가된 데이터가 있을수 있으므로 뷰의 데이터를 리로드
        theme = ThemeManager.shared.getThemeInstance()
        self.view.backgroundColor = theme.getColor().view.main
        
        currentRecords = recordManager.getMatchingRecords()

        recordAnimationView.runAnimation(records: currentRecords)
        
        let seeder = DataHelper()
        seeder.loadSeeder()
        // 처음 뷰가 로드될 때는 항상 animated subview
        changeSubView(token: true)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        recordAnimationView.stopAnimation()
    }
    
    // MARK: - Get User Default
    private func getUserDefault() {
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

// MARK: - motion shake to change subview

extension MainViewController {
    
    override func motionBegan(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        if motion == .motionShake {
            changeSubView(token: changeSubViewToken)
            motionEnded(motion, with: event)
        }
    }
    
    // MARK: - token: True이면 애니메이션 뷰 -> 테이블 뷰
    private func changeSubView(token: Bool) {
        if token == true {
            recordAnimationView.isHidden = false
            recordTableView.isHidden = true
            
            changeSubViewToken = false
        } else {
            recordAnimationView.isHidden = true
            recordTableView.isHidden = false
            
            changeSubViewToken = true
        }
    }
    
}

extension MainViewController {
    
    private func setRecordAnimationView() {
        
        let mainViewWidth = self.view.frame.width
        let mainViewHeight = self.view.frame.height
        recordAnimationView.backgroundColor = .clear
        recordAnimationView.frame.size = CGSize(width: mainViewWidth * 0.8, height: mainViewHeight * 0.6)
        recordAnimationView.center = CGPoint(x: mainViewWidth / 2, y: mainViewHeight * 0.55 )
        recordAnimationView.delegate = self
    }
    
    private func setAddRecordButton() {
        
        let mainViewWidth = self.view.frame.width
        let mainViewHeight = self.view.frame.height
        let buttonSize = mainViewWidth * 0.1
        
        addRecordButton.frame.size = CGSize(width: buttonSize, height: buttonSize)
        addRecordButton.center = CGPoint(x: mainViewWidth / 2, y: mainViewHeight - (mainViewWidth / 4))
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
        
        modeChangeButtonsPressed(mode: 0)
    }
    
    @objc func changeDateModeToWeek() {
        
        modeChangeButtonsPressed(mode: 1)
    }
    
    @objc func changeDateModeToMonth() {
        
        modeChangeButtonsPressed(mode: 2)
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
        
        dateChangeButtonsPressed(val: 1)
    }
    
    @objc func dateBackwardButtonPressed() {
        
        dateChangeButtonsPressed(val: -1)
    }
    
    private func modeChangeButtonsPressed(mode: Int) {
        
        dateManager.setDateMode(newMode: mode)
        dateLabel.text = dateManager.getCurrentDateString()
        currentRecords = recordManager.getMatchingRecords()
        recordTableView.reloadData()
        
        recordAnimationView.reloadAnimation(records: currentRecords)
    }
    
    private func dateChangeButtonsPressed(val: Int) {
        
        dateManager.changeDate(val: val)
        dateLabel.text = dateManager.getCurrentDateString()
        currentRecords = recordManager.getMatchingRecords()
        recordTableView.reloadData()
        
        recordAnimationView.reloadAnimation(records: currentRecords)
    }
}

extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    
    private func setRecordTableView() {
        
        recordTableView.rowHeight = UITableView.automaticDimension
        recordTableView.frame.size = CGSize(width: view.frame.width, height: view.frame.height * 0.6)
        recordTableView.frame.origin = CGPoint(x: 0, y: view.frame.height * 0.25)
        recordTableView.backgroundColor = .clear
        recordTableView.setCellConfig()
        view.addSubview(recordTableView)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return currentRecords.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "RecordTableViewCell", for: indexPath) as! RecordTableViewCell
        
        cell.setCellContents(records: currentRecords, indexPath: indexPath)
        
        return cell
    }
}

// MARK: - RecordAnimationView Delegate
extension MainViewController: RecordAnimationViewDelegate {
    func tapActionRecordView() {
        recordModalLabel.fadeOut()
    }
    
    func openRecordTextView(index: Int) {
        print(currentRecords[index].gaugeLevel)
        if let text = currentRecords[index].memo {
            recordModalLabel.text = text
        }
        let figure = currentRecords[index].gaugeLevel
        recordModalLabel.backgroundColor = UIColor(hex: theme.getCurrentColor(figure: figure))
        
        recordModalLabel.fadeOut()
        recordModalLabel.fadeIn()
    }
    
    private func setRecordModalLabel() {
        
        recordModalLabel.frame.size = CGSize(width: 300, height: 100)
        recordModalLabel.center = CGPoint(x: view.frame.width * 0.5, y: view.frame.height * 0.8)
        recordModalLabel.text = "hello world"
        recordModalLabel.textAlignment = .center
        recordModalLabel.textColor = .black
        recordModalLabel.backgroundColor = indigo500
        recordModalLabel.fadeOut(duration: 0)
        
        view.addSubview(recordModalLabel)
    }
}
