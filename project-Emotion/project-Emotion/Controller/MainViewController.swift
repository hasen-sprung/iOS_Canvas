
import UIKit
import TweenKit

class MainViewController: UIViewController {
    
    @IBOutlet weak var addRecordButton: UIButton!
    @IBOutlet weak var gotoSettingButton: UIButton!
    let userDefaults = UserDefaults.standard
    var theme = ThemeManager.shared.getThemeInstance()
    
    var recordViews: [UIView]?
    let viewCounts: Int = 9
    private let scheduler = ActionScheduler()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getUserDefault()
        setAddRecordButton()
    }
    
    override func viewWillAppear(_ animated: Bool) {

        // core data에 추가된 데이터가 있을수 있으므로 뷰의 데이터를 리로드
        theme = ThemeManager.shared.getThemeInstance()
        self.view.backgroundColor = theme.getColor().view.main
        
        // 기존에 있던 액션 삭제
        scheduler.removeAll()
        // core data의 개수만큼 뷰 생성
        recordViews = setRecordViews(counts: viewCounts)
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
    
    func setAddRecordButton() {
        let mainViewWidth = self.view.frame.width
        let mainViewHeight = self.view.frame.height
        let buttonSize = mainViewWidth * 0.2
        
        addRecordButton.frame.size = CGSize(width: buttonSize, height: buttonSize)
        addRecordButton.center = CGPoint(x: mainViewWidth / 2, y: mainViewHeight - (mainViewWidth / 4))
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
        var rotateViews = [UIView]()
        
        for _ in 0 ..< counts {
            let view = UIView()
            let randSize: CGFloat = CGFloat.random(in: 55.0 ... 65.0)
            // coredata에서 그림 삽입.
            view.frame.size = CGSize(width: randSize, height: randSize)
            view.backgroundColor = .brown
            //setRandomViewCenter(view: view)
            
            // Affine을 돌리기 전/후의 center 는 같다.
            //view.transform = CGAffineTransform(rotationAngle: randAngle * CGFloat(Double.pi) / 180)
            print("--------")
//            print(view.frame.size.width)
//            print(view.frame.size.height)
//            print(view.bounds.width)
//            print(view.bounds.height)
            
//            let newView = UIView(frame: CGRect(origin: view.center, size: CGSize(width: view.frame.size.width * 1.2, height: view.frame.size.height * 1.2)))
//            newView.backgroundColor = .red
//            newView.transform = view.transform
//            self.view.addSubview(newView)
            
            // MARK: - 이게 이상하게 출력이 되나?? rotate를 한 후에
//            let fromRect = CGRect(origin: view.frame.origin, size: view.frame.size)
//            let newView = UIView(frame: fromRect)
//            newView.backgroundColor = .red
//            self.view.addSubview(newView)
            
            
            print(view.center.x)
            print(view.center.y)
            views.append(view)
            //self.view.addSubview(view)
            
            print(view.center.x)
            print(view.center.y)
            let randFigure: Float = Float.random(in: 0.0 ... 1.0)
            actionByFigure(view: view, figure: randFigure)
            
            // MARK: - rotate view
            print(view.center.x)
            print(view.center.y)
            
            let rotateView = UIView()
            print(rotateView.frame.origin.x)
            print(rotateView.frame.origin.y)
            //rotateView.frame.origin = view.frame.origin
            setRandomViewCenter(view: rotateView)
            
            rotateView.addSubview(view)
            self.view.addSubview(rotateView)
            
            let randAngle: CGFloat = CGFloat.random(in: 0.0 ... 360.0)
            rotateView.transform = CGAffineTransform(rotationAngle: randAngle)
        }
        
//        for i in 0 ..< counts {
//            let randAngle: CGFloat = CGFloat.random(in: 0.0 ... 360.0)
//            views[i].transform = CGAffineTransform(rotationAngle: randAngle  * CGFloat(Double.pi) / 180)
//        }
        
        return views
    }
    
    func setRandomViewCenter(view: UIView) {
        // 뷰 범위를 벗어나지 않기 위해서 safe area추가
        let maxX = self.view.frame.maxX - view.frame.size.width * 1.2
        let maxY = self.view.frame.maxY - view.frame.size.height * 1.2
        let minX: CGFloat = view.frame.size.width * 1.2
        let minY: CGFloat = view.frame.size.height * 1.2
        
        view.center = CGPoint(x: CGFloat.random(in: minX...maxX), y: CGFloat.random(in: minY...maxY))
    }
    
    
    
}

class ActionProperty {
    var duration: Double = 0.0
    var rangeFrom: Float = 0.0
    var rangeTo: Float = 0.0
    
}

// MARK: - Animation
extension MainViewController {
    // MARK: - make action squence and group
//    func makeAction() -> FiniteTimeAction {
//
//        let randomMoveDistanceX = CGFloat.random(in: 20...30) * CGFloat.random(in: -1...1)
//        let randomMoveDistanceY = CGFloat.random(in: 20...30) * CGFloat.random(in: -1...1)
//
//        let action = InterpolationAction(from: fromRect, to: toRect, duration: duration, easing: .bounceIn) {
//            view.frame = $0
//        }
//
//        return action
//
//    }
    
    // MARK: - 지이잉
    func fastMoveAction(view: UIView) -> FiniteTimeAction {
        let randomMoveDistanceX = CGFloat.random(in: 20...30) * CGFloat.random(in: -1...1)
        let randomMoveDistanceY = CGFloat.random(in: 20...30) * CGFloat.random(in: -1...1)
        
        let fromRect = CGRect(origin: view.center, size: view.frame.size)
        let toRect = CGRect(origin: CGPoint(x: view.center.x + randomMoveDistanceX, y: view.center.y + randomMoveDistanceY), size: view.frame.size)
        
        let duration = Double.random(in: 0.3...0.3)
        
        let action = InterpolationAction(from: fromRect, to: toRect, duration: duration, easing: .bounceIn) {
            view.frame = $0
        }
        
        return action
    }
    func test2(view: UIView) -> FiniteTimeAction {
        let randomMoveDistanceX = CGFloat.random(in: 20...30) * CGFloat.random(in: -1...1)
        let randomMoveDistanceY = CGFloat.random(in: 20...30) * CGFloat.random(in: -1...1)
        
        let fromRect = CGRect(origin: view.center, size: view.frame.size)
        let toRect = CGRect(origin: CGPoint(x: view.center.x + randomMoveDistanceX, y: view.center.y + randomMoveDistanceY), size: view.frame.size)
        let duration = Double.random(in: 0.3...0.6)
        
        let action = InterpolationAction(from: fromRect, to: toRect, duration: duration, easing: .exponentialInOut) {
            view.frame = $0
        }
        
        return action
    }
    func test3(view: UIView) -> FiniteTimeAction {
        let randomMoveDistanceX = CGFloat.random(in: 20...30) * CGFloat.random(in: -1...1)
        let randomMoveDistanceY = CGFloat.random(in: 20...30) * CGFloat.random(in: -1...1)
        
        let fromRect = CGRect(origin: view.center, size: view.frame.size)
        let toRect = CGRect(origin: CGPoint(x: view.center.x + randomMoveDistanceX, y: view.center.y + randomMoveDistanceY), size: view.frame.size)
        let duration = Double.random(in: 0.6...1.0)
        
        let action = InterpolationAction(from: fromRect, to: toRect, duration: duration, easing: .elasticIn) {
            view.frame = $0
        }
        
        return action
    }
    
    // MARK: - 크기와 위치를 조절해서 애니메이션 효과.
    
    func moveUpDownAction(view: UIView, moveUpDownLen: CGFloat, sizeMultiple: CGFloat) -> FiniteTimeAction {
        
        let moveUpLength: CGFloat = moveUpDownLen
        let sizeUpFrame: CGFloat = sizeMultiple
        // 새로운 뷰의 가운데를 맞춰주기 위해 더 좋은 방법이 있으면 코드 수정해도 됨
        let newView = UIView(frame: CGRect(origin: view.center, size: CGSize(width: view.frame.size.width * sizeUpFrame, height: view.frame.size.height * sizeUpFrame)))
        newView.center = view.center
        
//        let randAngle: CGFloat = CGFloat.random(in: 0.0 ... 360.0)
//        view.transform = CGAffineTransform(rotationAngle: randAngle  * CGFloat(Double.pi) / 180)
//        newView.transform = CGAffineTransform(rotationAngle: randAngle  * CGFloat(Double.pi) / 180)
//        newView.center = view.center
        
        let fromRect = CGRect(origin: view.frame.origin, size: view.frame.size)
        let toRect = CGRect(origin: CGPoint(x: newView.frame.origin.x, y: newView.frame.origin.y - moveUpLength), size: newView.frame.size)
        let duration = 1.0
        
        let action = InterpolationAction(from: fromRect, to: toRect, duration: duration, easing: .sineInOut) {
            view.frame = $0
        }
        
        return action
    }
    
    
    func slowMoveAction(view: UIView) -> FiniteTimeAction {
        let randomMoveDistanceX = CGFloat.random(in: 20...30) * CGFloat.random(in: -1...1)
        let randomMoveDistanceY = CGFloat.random(in: 20...30) * CGFloat.random(in: -1...1)
        
        let fromRect = CGRect(origin: view.center, size: view.frame.size)
        let toRect = CGRect(origin: CGPoint(x: view.center.x + randomMoveDistanceX, y: view.center.y + randomMoveDistanceY), size: view.frame.size)
        let duration = Double.random(in: 1.5...2.0)
        
        let action = InterpolationAction(from: fromRect, to: toRect, duration: duration, easing: .linear) {
            view.frame = $0
        }
        
        return action
    }
    
    func actionByFigure(view: UIView, figure: Float) {
        
        var action: FiniteTimeAction
        if figure < 0.2 {
            //action = fastMoveAction(view: view)
            view.backgroundColor = cellGVMiddle
        } else if figure < 0.4 {
            //action = test2(view: view)
            view.backgroundColor = cellGVTop
        } else if figure < 0.6 {
            //action = test3(view: view)
            view.backgroundColor = cellGVBottom
        } else if figure < 0.8 {
            view.backgroundColor = pink100
        } else {
            //action = slowMoveAction(view: view)
            view.backgroundColor = indigo500
        }
        action = moveUpDownAction(view: view, moveUpDownLen: 10, sizeMultiple: 1.2)
        
        scheduler.run(action: action.yoyo().repeatedForever())
    }
    //delay, 겹치는 문제, rotate
    
}
