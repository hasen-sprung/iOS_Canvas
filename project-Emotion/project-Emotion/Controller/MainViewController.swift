
import UIKit
import TweenKit
import Macaw

class MainViewController: UIViewController {
    
    @IBOutlet weak var addRecordButton: UIButton!
    @IBOutlet weak var gotoSettingButton: UIButton!
    

    @IBOutlet weak var goToArchiveButton: UIBarButtonItem!
    
    @IBOutlet weak var recordAnimationView: RecordAnimationView!

    private let recordModalLabel = UILabel()
    
    private var currentRecords: [Record] = [Record]()
    
    private let userDefaults = UserDefaults.standard
    private var theme = ThemeManager.shared.getThemeInstance()
    private let dateManager = DateManager.shared
    private let recordManager = RecordManager.shared
    
    private var changeSubViewToken = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getUserDefault()
        setAddRecordButton()
        
        setRecordAnimationView()
        setRecordModalLabel()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        // core data에 추가된 데이터가 있을수 있으므로 뷰의 데이터를 리로드
        theme = ThemeManager.shared.getThemeInstance()
        self.view.backgroundColor = theme.getColor().view.main
        
        dateManager.setCurrentDateForNow()
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
            
            changeSubViewToken = false
        } else {
            recordAnimationView.isHidden = true
            
            changeSubViewToken = true
            recordModalLabel.fadeOut(duration: 0)
        }
    }
    
}

extension MainViewController {
    
    private func setRecordAnimationView() {
        
        let mainViewWidth = self.view.frame.width
        let mainViewHeight = self.view.frame.height
        recordAnimationView.backgroundColor = .clear
        recordAnimationView.frame.size = CGSize(width: mainViewWidth * 0.8, height: mainViewHeight * 0.7)
        recordAnimationView.center = CGPoint(x: mainViewWidth / 2, y: mainViewHeight / 2 )
        recordAnimationView.delegate = self
    }
    
    private func setAddRecordButton() {
        
        let mainViewWidth = self.view.frame.width
        let mainViewHeight = self.view.frame.height
        let buttonSize = mainViewWidth * 0.1
        
        addRecordButton.frame.size = CGSize(width: buttonSize, height: buttonSize)
        addRecordButton.center = CGPoint(x: mainViewWidth / 2, y: mainViewHeight - (mainViewWidth / 4))
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
        let width = 300
        let height = 100
        
        recordModalLabel.frame.size = CGSize(width: width, height: height)
        recordModalLabel.center = CGPoint(x: view.frame.width * 0.5, y: view.frame.height * 0.8)
        recordModalLabel.text = "hello world"
        recordModalLabel.textAlignment = .center
        recordModalLabel.textColor = .black
        recordModalLabel.backgroundColor = indigo500
        recordModalLabel.fadeOut(duration: 0)
        recordModalLabel.clipsToBounds = true
        recordModalLabel.layer.cornerRadius = CGFloat(height / 4)
        
        view.addSubview(recordModalLabel)
    }
}
