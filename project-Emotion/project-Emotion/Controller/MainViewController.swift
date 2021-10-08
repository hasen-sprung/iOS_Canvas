
import UIKit
import TweenKit

class MainViewController: UIViewController {
    
    @IBOutlet weak var addRecordButton: UIButton!
    @IBOutlet weak var gotoSettingButton: UIButton!
    let userDefaults = UserDefaults.standard
    private let scheduler = ActionScheduler()
    
    var theme = ThemeManager.shared.getThemeInstance()
    
    var testView : UIView = {
        let view = UIView(frame: CGRect(origin: CGPoint(x: 50, y: 50), size: CGSize(width: 50, height: 50)))
        view.backgroundColor = .red
        
        return view
    }()
    
    var testView2 : UIView = {
        let view = UIView(frame: CGRect(origin: CGPoint(x: 550, y: 50), size: CGSize(width: 50, height: 50)))
        view.backgroundColor = .blue
        
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // core data에서 모든 기록데이터를 로드
        view.addSubview(testView)
        view.addSubview(testView2)
        
        actionMoveFrame(from: testView2.center, to: view.center, view: testView2, size: testView2.frame.size, option: 0)
        actionMoveFrame(from: testView.center, to: view.center, view: testView, size: testView.frame.size, option: 0)
        
        getUserDefault()
        setAddRecordButton()
    }
    override func viewWillAppear(_ animated: Bool) {
        // core data에 추가된 데이터가 있을수 있으므로 뷰의 데이터를 리로드
        theme = ThemeManager.shared.getThemeInstance()
        self.view.backgroundColor = theme.getColor().view.main
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

// MARK: - Animation
extension MainViewController {
    
    
    func actionMoveFrame(from: CGPoint, to: CGPoint, view: UIView, size: CGSize, option: Int) {
        
        let fromRect = CGRect(origin: from, size: size)
        let toRect = CGRect(origin: to, size: size)
        let duration = 1.0
        let action = InterpolationAction(from: fromRect, to: toRect, duration: duration, easing: .exponentialInOut) {
            view.frame = $0
        }
        if option == 0 {
            scheduler.run(action: action.repeatedForever())
        } else {
            scheduler.run(action: action.yoyo())
        }
        
    }
}
