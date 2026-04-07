import UIKit

class MessageCell: UITableViewCell {
    
    @IBOutlet weak var leftImageView: UIImageView!
    @IBOutlet weak var rightImageView: UIImageView!
    @IBOutlet weak var messageBubble: UIView!
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    
    @IBOutlet weak var leadingConstraint: NSLayoutConstraint?
    @IBOutlet weak var trailingConstraint: NSLayoutConstraint?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
        setupInnerConstraints()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        leftImageView.layer.cornerRadius = leftImageView.bounds.height / 2
        rightImageView.layer.cornerRadius = rightImageView.bounds.height / 2
    }
    
    private func setupUI() {
        selectionStyle = .none
        
        messageBubble.layer.cornerRadius = 16
        messageBubble.clipsToBounds = true
        
        leftImageView.clipsToBounds = true
        rightImageView.clipsToBounds = true
        
        label.numberOfLines = 0
        
        timeLabel.font = UIFont.systemFont(ofSize: 11)
        timeLabel.textColor = .darkGray
    }
    
    private func setupInnerConstraints() {
        label.translatesAutoresizingMaskIntoConstraints = false
        timeLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            // label
            label.topAnchor.constraint(equalTo: messageBubble.topAnchor, constant: 8),
            label.leadingAnchor.constraint(equalTo: messageBubble.leadingAnchor, constant: 12),
            label.trailingAnchor.constraint(equalTo: messageBubble.trailingAnchor, constant: -12),
            
            // timeLabel
            timeLabel.trailingAnchor.constraint(equalTo: messageBubble.trailingAnchor, constant: -8),
            timeLabel.bottomAnchor.constraint(equalTo: messageBubble.bottomAnchor, constant: -6),
            
            // связь между label и timeLabel
            label.bottomAnchor.constraint(equalTo: timeLabel.topAnchor, constant: -4)
        ])
    }
    
    func configure(with message: Message, isCurrentUser: Bool, formatter: DateFormatter) {
        label.text = message.body
        
        let date = Date(timeIntervalSince1970: message.date)
        timeLabel.text = formatter.string(from: date)
        
        if isCurrentUser {
            leftImageView.isHidden = true
            rightImageView.isHidden = false
            
            messageBubble.backgroundColor = .systemBlue
            label.textColor = .white
            timeLabel.textColor = UIColor.white.withAlphaComponent(0.7)
            
            leadingConstraint?.constant = 110
            trailingConstraint?.constant = 44
        } else {
            leftImageView.isHidden = false
            rightImageView.isHidden = true
            
            messageBubble.backgroundColor = .systemGray5
            label.textColor = .black
            timeLabel.textColor = .darkGray
            
            leadingConstraint?.constant = 44
            trailingConstraint?.constant = 110
        }
        
        layoutIfNeeded()
    }
}
