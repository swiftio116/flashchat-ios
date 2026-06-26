import UIKit

final class MessageCell: UITableViewCell {

    static let identifier = "MessageCell"

    private var leftConstraint: NSLayoutConstraint?
    private var rightConstraint: NSLayoutConstraint?

    private let bubbleView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 14
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let senderLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12)
        label.textColor = .secondaryLabel
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let messageLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("Use init(style:reuseIdentifier:)")
    }

    override func prepareForReuse() {
        super.prepareForReuse()

        leftConstraint?.isActive = false
        rightConstraint?.isActive = false
    }

    // Cell layout.
    private func setupUI() {
        selectionStyle = .none
        backgroundColor = .clear

        contentView.addSubview(bubbleView)
        bubbleView.addSubview(senderLabel)
        bubbleView.addSubview(messageLabel)

        leftConstraint = bubbleView.leadingAnchor.constraint(
            equalTo: contentView.leadingAnchor,
            constant: 16
        )

        rightConstraint = bubbleView.trailingAnchor.constraint(
            equalTo: contentView.trailingAnchor,
            constant: -16
        )

        NSLayoutConstraint.activate([
            bubbleView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 6),
            bubbleView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -6),
            bubbleView.widthAnchor.constraint(lessThanOrEqualTo: contentView.widthAnchor, multiplier: 0.75),

            senderLabel.topAnchor.constraint(equalTo: bubbleView.topAnchor, constant: 8),
            senderLabel.leadingAnchor.constraint(equalTo: bubbleView.leadingAnchor, constant: 12),
            senderLabel.trailingAnchor.constraint(equalTo: bubbleView.trailingAnchor, constant: -12),

            messageLabel.topAnchor.constraint(equalTo: senderLabel.bottomAnchor, constant: 4),
            messageLabel.leadingAnchor.constraint(equalTo: bubbleView.leadingAnchor, constant: 12),
            messageLabel.trailingAnchor.constraint(equalTo: bubbleView.trailingAnchor, constant: -12),
            messageLabel.bottomAnchor.constraint(equalTo: bubbleView.bottomAnchor, constant: -10)
        ])
    }

    func configure(with message: Message, isOwnMessage: Bool) {
        senderLabel.text = message.senderName
        messageLabel.text = message.body

        leftConstraint?.isActive = !isOwnMessage
        rightConstraint?.isActive = isOwnMessage

        bubbleView.backgroundColor = isOwnMessage ? .systemBlue : .secondarySystemBackground
        messageLabel.textColor = isOwnMessage ? .white : .label
        senderLabel.textColor = isOwnMessage ? .white.withAlphaComponent(0.8) : .secondaryLabel
    }
}
