import UIKit

class MessageCell: UITableViewCell {
    
    @IBOutlet weak var leftImageView: UIImageView!
    @IBOutlet weak var rightImageView: UIImageView!
    @IBOutlet weak var messageBubble: UIView!
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        messageBubble.layer.cornerRadius = 16
        messageBubble.clipsToBounds = true
        
        leftImageView.layer.cornerRadius = leftImageView.frame.size.height / 2
        leftImageView.clipsToBounds = true
        
        rightImageView.layer.cornerRadius = rightImageView.frame.size.height / 2
        rightImageView.clipsToBounds = true
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
