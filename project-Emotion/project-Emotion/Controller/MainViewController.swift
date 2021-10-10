
import UIKit
import TweenKit

class MainViewController: UIViewController {
    
    @IBOutlet weak var addRecordButton: UIButton!
    @IBOutlet weak var gotoSettingButton: UIButton!
    let userDefaults = UserDefaults.standard
    var theme = ThemeManager.shared.getThemeInstance()
    
    
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
