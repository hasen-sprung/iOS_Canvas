import UIKit
import SnapKit

class GaugeViewController: UIViewController {
    private let recordManager = RecordManager.shared
    private var gaugeWaveView: GaugeWaveAnimationView = {
        let view = GaugeWaveAnimationView(frame: UIScreen.main.bounds)
        return view
    }()
    
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
        // TODO: go to the main view
        print("Cancel the gauge view")
    }
    
    func addMemo() {
        // TODO: add Data and go to the main view
        print("Created the New Memo")
    }
}
