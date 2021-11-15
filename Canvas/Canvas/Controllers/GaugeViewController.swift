import UIKit
import SnapKit

class GaugeViewController: UIViewController {
    private let recordManager = RecordManager.shared
    private var gaugeWaveView: GaugeWaveAnimationView = {
        let view = GaugeWaveAnimationView(frame: UIScreen.main.bounds)
        return view
    }()
    
    private var createRecordView: CreateRecordView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addSubview()
        setLayout()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        gaugeWaveView.startWaveAnimation()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        gaugeWaveView.stopWaveAnimation()
    }
    
    private func addSubview() {
        view.addSubview(gaugeWaveView)
        gaugeWaveView.delegate = self
    }
    
    private func setLayout() {
        gaugeWaveView.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
            make.leading.equalTo(self.view.safeAreaLayoutGuide.snp.leading)
            make.trailing.equalTo(self.view.safeAreaLayoutGuide.snp.trailing)
            make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom)
        }
    }
}

extension GaugeViewController: GaugeWaveAnimationViewDelegate {
    func cancelGaugeView() {
        gaugeWaveView.removeFromSuperview()
        self.dismiss(animated: true, completion: nil)
    }
    
    func addMemo(gaugeLevel: Int) {
        print(gaugeLevel)
        createRecordView = CreateRecordView()
        createRecordView?.initCreateRecordView()
        createRecordView?.alpha = 0.0
        if let newView = createRecordView {
            view.addSubview(newView)
        }
        createRecordView?.fadeIn()
    }
}
