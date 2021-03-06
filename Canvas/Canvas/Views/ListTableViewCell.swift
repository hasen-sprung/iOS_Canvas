import UIKit

class ListTableViewCell: UITableViewCell {
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var shapeImage: UIImageView!
    @IBOutlet weak var userMemo: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = UIColor(r: 240, g: 240, b: 243)
        timeLabel.textColor = .darkGray
        timeLabel.font = UIFont(name: "Cardo-Regular", size: 12)
        userMemo.textColor = .darkGray
        userMemo.font = UIFont(name: "Pretendard-Regular", size: 15)
        timeLabel.backgroundColor = .clear
        shapeImage.backgroundColor = .clear
        userMemo.backgroundColor = .clear
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
}
