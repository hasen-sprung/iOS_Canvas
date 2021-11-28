import UIKit

class RecordDetailView: UIView {
    
    private let detailView = UIView()
    private let dismissButton = UIButton()
    private let shapeBackground = UIImageView()
    let shapeImage = UIImageView()
    let dateLabel = UILabel()
    let memo = UITextView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissbuttonPressed))
        let blurEffect = UIBlurEffect(style: .regular)
        let visualEffectView = UIVisualEffectView(effect: blurEffect)
        
        self.addGestureRecognizer(tapGesture)
        self.addSubview(visualEffectView)
        self.alpha = 0.5
        self.backgroundColor = .black
        visualEffectView.frame = self.frame
    }
    
    func setDetailView() {
        detailView.frame.size = CGSize(width: self.frame.width * 0.8,
                                       height: self.frame.width * 0.8 * 4 / 3)
        detailView.center = self.center
        detailView.backgroundColor = UIColor(r: 240, g: 240, b: 243)
        detailView.layer.cornerRadius = self.frame.width / 30
        superview?.addSubview(detailView)
        
        dismissButton.frame.size = CGSize(width: detailView.frame.width / 20,
                                          height: detailView.frame.width / 20)
        dismissButton.center = CGPoint(x: detailView.frame.width * 0.9, y: detailView.frame.width * 0.1)
        dismissButton.addTarget(self, action: #selector(dismissbuttonPressed), for: .touchUpInside)
        dismissButton.setImage(UIImage(named: "DismissIcon"), for: .normal)
        detailView.addSubview(dismissButton)
        
        shapeBackground.frame.size = CGSize(width: detailView.frame.width * 0.4,
                                            height: detailView.frame.width * 0.4)
        shapeBackground.center = CGPoint(x: detailView.frame.width * 0.525,
                                         y: detailView.frame.height * 0.175)
        shapeBackground.image = UIImage(named: "ShapeBackground")
        detailView.addSubview(shapeBackground)
        
        shapeImage.frame.size = CGSize(width: detailView.frame.width * 0.1,
                                            height: detailView.frame.width * 0.1)
        shapeImage.center = CGPoint(x: detailView.frame.width * 0.51,
                                         y: detailView.frame.height * 0.165)
        detailView.addSubview(shapeImage)
        
        dateLabel.frame.size = CGSize(width: detailView.frame.width,
                                      height: detailView.frame.height * 0.1)
        dateLabel.center = CGPoint(x: detailView.frame.width * 0.5,
                                   y: detailView.frame.height * 0.3)
        dateLabel.textAlignment = .center
        dateLabel.textColor = UIColor(r: 14, g: 15, b: 15)
        dateLabel.font = UIFont(name: "Cardo-Regular", size: 15)
        detailView.addSubview(dateLabel)

        memo.frame.size = CGSize(width: detailView.frame.width * 0.8,
                                      height: detailView.frame.height * 0.5)
        memo.center = CGPoint(x: detailView.frame.width * 0.5,
                                   y: detailView.frame.height * 0.65)
        memo.backgroundColor = UIColor(r: 240, g: 240, b: 243)
        memo.isEditable = false
        detailView.addSubview(memo)
    }
    
    @objc func dismissbuttonPressed() {
        self.removeFromSuperview()
        detailView.removeFromSuperview()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
