import UIKit

protocol MainCanavasCollectionViewCellDelegate: AnyObject {
    func setCanvasSubView(subView: MainRecordsView, idx: Int)
}

class MainCanavasCollectionViewCell: UICollectionViewCell {
    
    weak var delegate: MainCanavasCollectionViewCellDelegate?
    let canvasView = UIView()
    var canvasSubView = UIView()
    var canvasRecordView: MainRecordsView?
    
    var index = 0
    
    override func layoutSubviews() {
        super.layoutSubviews()
        updateUI()
    }
    
    private func updateUI() {
        canvasView.frame = self.contentView.frame
        canvasView.backgroundColor = .clear
//        setShadows(canvasView)
        canvasSubView.frame.size = CGSize(width: canvasView.frame.width - 16,
                                          height: canvasView.frame.height - 16)
        self.contentView.addSubview(canvasView)
        canvasSubView.center = CGPoint(x: canvasView.frame.width / 2,
                                       y: canvasView.frame.height / 2)
        canvasSubView.backgroundColor = canvasColor
        canvasView.addSubview(canvasSubView)
        canvasRecordView?.clearRecordViews()
        canvasRecordView = MainRecordsView(in: canvasSubView)
        canvasSubView.addSubview(canvasRecordView ?? UIView())
        
        if let delegate = delegate {
            delegate.setCanvasSubView(subView: canvasRecordView ?? MainRecordsView(), idx: index)
        }
    }
}
