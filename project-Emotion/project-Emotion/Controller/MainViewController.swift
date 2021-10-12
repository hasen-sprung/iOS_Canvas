
import UIKit
import TweenKit

class MainViewController: UIViewController {
    
    @IBOutlet weak var addRecordButton: UIButton!
    @IBOutlet weak var gotoSettingButton: UIButton!
    let userDefaults = UserDefaults.standard
    var theme = ThemeManager.shared.getThemeInstance()
    
    // MARK: - Record Animation Property
    var recordViews: [UIView]?
    let viewCounts: Int = 15 //coredata의 개수로 나중에 제거될 속성
    private let scheduler = ActionScheduler() //main view 애니메이션 관리자
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getUserDefault()
        setAddRecordButton()
    }
    
    override func viewWillAppear(_ animated: Bool) {

        // core data에 추가된 데이터가 있을수 있으므로 뷰의 데이터를 리로드
        theme = ThemeManager.shared.getThemeInstance()
        self.view.backgroundColor = theme.getColor().view.main
        
        // 애니메이션 : 기존에 있던 액션 삭제
        scheduler.removeAll()
        // core data의 개수만큼 뷰 생성
        recordViews = setAnimationAtRecordViews(recordCounts: viewCounts, randomRotate: true)
        print(view.subviews.count)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        // MARK: - 기존에 뷰에 추가되었던 서브뷰들을 제거 : 흐음 근데 이 방법이 최선인가? 메인뷰로 갈때마다 생성 삭제를 반복하는게 최선일까요?
        clearSubviews(views: recordViews)
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

// MARK: - Set Record Image, Animation, Size, Location, Rotate

extension MainViewController {
    
    // MARK: - 메인 뷰에 추가되었던 뷰들을 제거하지 않으면 계속 쌓인다.
    // 변경사항이 있을 경우 (새로운 서브뷰가 추가될때)만 그 뷰만 추가되고 삭제되면 더 좋을거 같다.
    func clearSubviews(views: [UIView]?) {
        if let views = views {
            for view in views {
                view.removeFromSuperview()
            }
        } else {
            print("생성된 서브뷰가 없어서 삭제할게 없습니다. = 해당 날짜에 아무런 데이터가 없어서 출력할게 없다.")
        }
    }
    
    // MARK: - Record들에 적합한 사이즈와 이미지, 액션을 결정해준다
    func setAnimationAtRecordViews(recordCounts: Int, randomRotate: Bool) -> [UIView] {
        var recordViews = [UIView]()
        
        for _ in 0 ..< recordCounts {
            let animatedView = UIView()
            // TODO: set SVG images
            // - Record.figure의 수치에 따라서 이미지가 결정됨
            
            // MARK: - Set size and Animation by figure
            // TODO: view의 크기는 Record가 생성된 시간에 따라 결정됨 private setRecordViewSize()
            let randSize: CGFloat = CGFloat.random(in: 25.0...55.0)
            animatedView.frame.size = CGSize(width: randSize, height: randSize)
            setActionByFigure(view: animatedView, figure: Float.random(in: 0.0...1.0))
            
            // MARK: - set random location and rotate record view
            let rotateView = UIView()
            let randAngle: CGFloat = CGFloat.random(in: 0.0...360.0)
            
            setRandomLocationRecordView(view: rotateView, superView: self.view)
            if randomRotate {
                rotateView.transform = CGAffineTransform(rotationAngle: randAngle)
            }
            
            // MARK: - connect view
            rotateView.addSubview(animatedView)
            self.view.addSubview(rotateView) //TODO: 현재는 메인뷰에 바로 서브뷰를 추가하지만 애니메이션 뷰에 추가하도록 수정
            recordViews.append(rotateView)
        }
        
        return recordViews
    }
    
    private func setRandomLocationRecordView(view: UIView, superView: UIView) {
        // TODO: 겹치는 부분에 대한 미세한 정의, 완전하게 겹치는건 안되지만 살짝 겹치는건 괜찮다.
        // 뷰 범위를 벗어나지 않기 위해서 safe area추가
        let maxX = superView.frame.maxX - view.frame.size.width * 1.2
        let maxY = superView.frame.maxY - view.frame.size.height * 1.2
        let minX: CGFloat = view.frame.size.width * 1.2
        let minY: CGFloat = view.frame.size.height * 1.2
        
        view.center = CGPoint(x: CGFloat.random(in: minX...maxX), y: CGFloat.random(in: minY...maxY))
    }
    
}

// MARK: - Animation 효과들

extension MainViewController {
    
    // MARK: - 지이잉
    private func fastMoveAction(view: UIView) -> FiniteTimeAction {
        
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
    
    private func slowMoveAction(view: UIView) -> FiniteTimeAction {
        
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
    
    // MARK: - 크기와 위치를 조절해서 애니메이션 효과.
    
    private func moveUpDownAction(view: UIView, moveUpDownLen: CGFloat, sizeMultiple: CGFloat) -> FiniteTimeAction {
        
        let moveUpLength: CGFloat = moveUpDownLen
        let sizeUpFrame: CGFloat = sizeMultiple
        // 새로운 뷰의 가운데를 맞춰주기 위해 더 좋은 방법이 있으면 코드 수정해도 됨
        let newView = UIView(frame: CGRect(origin: view.center, size: CGSize(width: view.frame.size.width * sizeUpFrame, height: view.frame.size.height * sizeUpFrame)))
        newView.center = view.center
        
        let fromRect = CGRect(origin: view.frame.origin, size: view.frame.size)
        let toRect = CGRect(origin: CGPoint(x: newView.frame.origin.x, y: newView.frame.origin.y - moveUpLength), size: newView.frame.size)
        let duration = Double.random(in: 1.0...1.0)
        
        let action = InterpolationAction(from: fromRect, to: toRect, duration: duration, easing: .sineInOut) {
            view.frame = $0
        }
        
        return action
    }
    
    // MARK: - figure에 따라 애니메이션 동작이 달라진다.
    
    private func setActionByFigure(view: UIView, figure: Float) {
        
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
        
        // MARK: - delay: 액션이 실행되기전 잠깐 멈칫하는 시간을 앞 뒤 언제든 설정할 수 있음
        let delay = Double.random(in: 0.0...0.5)
        let sequence = ActionSequence(actions: DelayAction(duration: delay), action)
        scheduler.run(action: sequence.yoyo().repeatedForever())
    }
    
}
