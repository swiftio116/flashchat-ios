import UIKit

final class MessageCell: UITableViewCell {
    
    @IBOutlet weak var leftImageView: UIImageView!
    @IBOutlet weak var rightImageView: UIImageView!
    @IBOutlet weak var messageBubble: UIView!
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    
    @IBOutlet weak var leadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var trailingConstraint: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        leftImageView.layer.cornerRadius = leftImageView.bounds.height / 2
        rightImageView.layer.cornerRadius = rightImageView.bounds.height / 2
    }
    
    
    private func setupUI() {
        selectionStyle = .none
        backgroundColor = .clear
        contentView.backgroundColor = .clear
        
        messageBubble.layer.cornerRadius = 18
        messageBubble.clipsToBounds = true
        
        leftImageView.clipsToBounds = true
        rightImageView.clipsToBounds = true
        
        nameLabel.font = .systemFont(ofSize: 12, weight: .semibold)
        nameLabel.textColor = .darkGray
        
        messageLabel.font = .systemFont(ofSize: 17)
        messageLabel.numberOfLines = 0
        
        timeLabel.font = .systemFont(ofSize: 11)
    }
    
    func configure(with message: Message, isCurrentUser: Bool, formatter: DateFormatter) {
        nameLabel.text = message.senderName
        messageLabel.text = message.body
        timeLabel.text = formatter.string(from: message.date)
        if isCurrentUser {
            leftImageView.isHidden = true
            rightImageView.isHidden = false
            nameLabel.isHidden = true

            messageBubble.backgroundColor = .systemBlue
            messageLabel.textColor = .white
            timeLabel.textColor = UIColor.white.withAlphaComponent(0.75)

            leadingConstraint.constant = 80
            trailingConstraint.constant = 56

            rightImageView.image = avatarImage(letter: firstLetter(from: message.senderName))
        } else {
            leftImageView.isHidden = false
            rightImageView.isHidden = true
            nameLabel.isHidden = false

            messageBubble.backgroundColor = .systemGray5
            messageLabel.textColor = .black
            timeLabel.textColor = .darkGray
            nameLabel.textColor = .darkGray

            leadingConstraint.constant = 56
            trailingConstraint.constant = 80

            leftImageView.image = avatarImage(letter: firstLetter(from: message.senderName))
        }
        layoutIfNeeded()
    }
    
    private func firstLetter(from name: String) -> String {
        String(name.trimmingCharacters(in: .whitespacesAndNewlines).prefix(1)).uppercased()
    }
    
    private func avatarImage(letter: String) -> UIImage? {
        let size = CGSize(width: 40, height: 40)
        let renderer = UIGraphicsImageRenderer(size: size)
        
        return renderer.image { _ in
            let rect = CGRect(origin: .zero, size: size)
            UIColor.systemBlue.withAlphaComponent(0.15).setFill()
            UIBezierPath(ovalIn: rect).fill()
            
            let attrs: [NSAttributedString.Key: Any] = [
                .font: UIFont.systemFont(ofSize: 18, weight: .semibold),
                .foregroundColor: UIColor.systemBlue
            ]
            
            let textSize = letter.size(withAttributes: attrs)
            let textRect = CGRect(
                x: (size.width - textSize.width) / 2,
                y: (size.height - textSize.height) / 2,
                width: textSize.width,
                height: textSize.height
            )
            
            letter.draw(in: textRect, withAttributes: attrs)
        }
    }
}
