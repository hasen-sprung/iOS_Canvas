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
    }
}

// MARK: Set UI
extension MainViewController {
    
    private func setMainViewUI() {
        
        view.backgroundColor = UIColor(red: 240 / 255, green: 240 / 255, blue: 243 / 255, alpha: 1.0)
        view.addSubview(goToListIcon)
        view.addSubview(goToSettingIcon)
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
        goToListIcon.frame.size = goToListButton.frame.size
        goToListIcon.center = goToListButton.center
        goToListIcon.image = UIImage(named: "ListBtnIcon")
        goToListIcon.isUserInteractionEnabled = false
    }
    
    private func setSettingButtonUI() {
        goToSettingButton.backgroundColor = .clear
        goToSettingButton.setImage(UIImage(named: "SmallBtnBackground"), for: .normal)
        goToSettingIcon.frame.size = goToSettingButton.frame.size
        goToSettingIcon.center = goToSettingButton.center
        goToSettingIcon.image = UIImage(named: "SettingBtnIcon")
        goToSettingIcon.isUserInteractionEnabled = false
    }
    
    private func setAddRecordingButtonUI() {
        addRecordButton.backgroundColor = .clear
        addRecordButton.setImage(UIImage(named: "BigBtnBackground"), for: .normal)
        addRecordButton.contentMode = .scaleToFill
    }
}


// MARK: set Layout / autoLayout refactoring 필요
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
        goToListButton.frame.size = CGSize(width: buttonSize,
                                           height: buttonSize)
        goToListButton.frame.origin = CGPoint(x: margin,
                                              y: buttonY)
    }
    
    private func setSettingButtonConstraints() {
        
        let margin = view.frame.width * 0.175 / 2
        let buttonSize = view.frame.width / 10
        let buttonY = canvasView.frame.origin.y - buttonSize
        goToSettingButton.frame.size = CGSize(width: buttonSize,
                                              height: buttonSize)
        goToSettingButton.frame.origin = CGPoint(x: view.frame.width - margin - buttonSize,
                                                 y: buttonY)
    }
    
    private func setAddRecordButtonConstraints() {
        
        let endOfInfoView = infoView.frame.origin.y + infoView.frame.height
        addRecordButton.frame.size = CGSize(width: view.frame.width / 5,
                                            height: view.frame.width / 5)
        addRecordButton.center = CGPoint(x: view.frame.width / 1.95, y: 0)
        addRecordButton.frame.origin.y = endOfInfoView + (view.frame.height * 0.03)
    }
}
