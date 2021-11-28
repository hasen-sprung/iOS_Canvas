import UIKit

protocol CalendarCollectionViewCellDelegate {
    func isCellPressed(sectionStr: String)
}

class CalendarCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var dateDot: UIButton!
    var cellDateStr: String?
    
    var delegate: CalendarCollectionViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        dateDot.backgroundColor = .clear
        dateDot.alpha = 0.0
    }
    
    override var isSelected: Bool {
        didSet{
            if isSelected {
                if let sectionStr = cellDateStr {
                    if let d = delegate {
                        d.isCellPressed(sectionStr: sectionStr)
                    }
                }
            }
        }
    }
}
