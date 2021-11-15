import UIKit
import SnapKit

class MainViewController: UIViewController {
    
    @IBOutlet weak var canvasView: UIImageView!
    @IBOutlet weak var infoView: UIImageView!
    @IBOutlet weak var goToListButton: UIButton!
    @IBOutlet weak var goToSettingButton: UIButton!
    @IBOutlet weak var addRecordButton: UIButton!
    
    
    let recordManager = RecordManager.shared
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        setMainViewConstraints()
    }
    
    
    func setMainViewConstraints() {
        
        setCanvasViewConstraints()
        // CanvasView를 중심으로 layout 구성 (반드시 canvasView가 먼저 setting 되어야 한다.)
        setInfoViewConstraints()
        setTopButtonsConstraints()
        setAddRecordButtonConstraints()
    }
}

extension MainViewController {
    
    func setCanvasViewConstraints() {
    
        let viewWidth = view.frame.width * 0.8
        
        canvasView.frame.size = CGSize(width: viewWidth,
                                       height: viewWidth * 1.2)
        canvasView.center = CGPoint(x: view.frame.width / 2, y: view.frame.height * 0.4)
        canvasView.backgroundColor = .lightGray
    }
    
    func setInfoViewConstraints() {
        
        let viewWidth = canvasView.frame.width
        let endOfCanvasView = canvasView.frame.origin.y + canvasView.frame.height
        
        infoView.frame.size = CGSize(width: viewWidth,
                                     height: viewWidth * 0.3)
        infoView.frame.origin = CGPoint(x: canvasView.frame.origin.x,
                                        y: endOfCanvasView + view.frame.height * 0.03)
        infoView.backgroundColor = .lightGray
    }
    
    func setTopButtonsConstraints() {
        
        let margin = canvasView.frame.origin.x
        let buttonSize = view.frame.width / 10
        let buttonY = canvasView.frame.origin.y - buttonSize - (view.frame.height * 0.03)
        
        goToListButton.frame.size = CGSize(width: buttonSize,
                                           height: buttonSize)
        goToSettingButton.frame.size = CGSize(width: buttonSize,
                                              height: buttonSize)
        goToListButton.frame.origin = CGPoint(x: margin,
                                              y: buttonY)
        goToSettingButton.frame.origin = CGPoint(x: view.frame.width - margin - buttonSize,
                                                 y: buttonY)
        goToListButton.backgroundColor = .lightGray
        goToSettingButton.backgroundColor = .lightGray
    }
    
    func setAddRecordButtonConstraints() {
        
        let endOfInfoView = infoView.frame.origin.y + infoView.frame.height
        
        addRecordButton.frame.size = CGSize(width: view.frame.width / 5,
                                            height: view.frame.width / 5)
        addRecordButton.center = CGPoint(x: view.frame.width / 2,
                                         y: 0)
        addRecordButton.frame.origin.y = endOfInfoView + view.frame.height * 0.045
        addRecordButton.backgroundColor = .lightGray
    }
}
