import UIKit
import SnapKit

class MainViewController: UIViewController {
    
    @IBOutlet weak var canvasView: UIImageView!
    @IBOutlet weak var infoView: UIImageView!
    @IBOutlet weak var goToListButton: UIButton!
    @IBOutlet weak var goToSettingButton: UIButton!
    @IBOutlet weak var addRecordButton: UIButton!
    
    private let goToListIcon = UIImageView()
    private let goToSettingIcon = UIImageView()
    private let addRecordIcon = UIImageView()
    
    let recordManager = RecordManager.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setMainViewConstraints()
        setMainViewUI()
        setButtonsTarget()
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

extension UIViewController {
    func transitionVc(vc: UIViewController, duration: CFTimeInterval, type: CATransitionSubtype) {
        let customVcTransition = vc
        let transition = CATransition()
        
        transition.duration = duration
        transition.type = CATransitionType.push
        transition.subtype = type
        transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        customVcTransition.modalPresentationStyle = .fullScreen
        view.window!.layer.add(transition, forKey: kCATransition)
        present(customVcTransition, animated: false, completion: nil)
    }}
