import UIKit

final class ChatViewController: UIViewController {

    private let presenter: ChatPresenter

    private var messages: [Message] = []
    private var currentUserEmail: String?

    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(MessageCell.self, forCellReuseIdentifier: MessageCell.identifier)
        tableView.separatorStyle = .none
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()

    private let inputContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = .secondarySystemBackground
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let messageTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Message"
        textField.borderStyle = .roundedRect
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()

    private lazy var sendButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Send", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 17, weight: .semibold)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(sendButtonTapped), for: .touchUpInside)
        return button
    }()

    init(presenter: ChatPresenter) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("Use init(presenter:)")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        setupNavigation()
        presenter.viewDidLoad()
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        presenter.viewDidDisappear()
    }

    // Main screen layout.
    private func setupUI() {
        view.backgroundColor = .systemBackground

        tableView.dataSource = self
        tableView.delegate = self

        view.addSubview(tableView)
        view.addSubview(inputContainerView)

        inputContainerView.addSubview(messageTextField)
        inputContainerView.addSubview(sendButton)

        NSLayoutConstraint.activate([
            inputContainerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            inputContainerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            inputContainerView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            inputContainerView.heightAnchor.constraint(equalToConstant: 64),

            messageTextField.leadingAnchor.constraint(equalTo: inputContainerView.leadingAnchor, constant: 16),
            messageTextField.centerYAnchor.constraint(equalTo: inputContainerView.centerYAnchor),
            messageTextField.heightAnchor.constraint(equalToConstant: 40),

            sendButton.leadingAnchor.constraint(equalTo: messageTextField.trailingAnchor, constant: 12),
            sendButton.trailingAnchor.constraint(equalTo: inputContainerView.trailingAnchor, constant: -16),
            sendButton.centerYAnchor.constraint(equalTo: inputContainerView.centerYAnchor),
            sendButton.widthAnchor.constraint(equalToConstant: 56),

            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: inputContainerView.topAnchor)
        ])
    }

    // Navigation bar setup.
    private func setupNavigation() {
        title = "FlashChat"

        navigationItem.hidesBackButton = true
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "Log Out",
            style: .plain,
            target: self,
            action: #selector(logoutButtonTapped)
        )
    }

    @objc private func sendButtonTapped() {
        presenter.didTapSend(text: messageTextField.text)
    }

    @objc private func logoutButtonTapped() {
        presenter.didTapLogout()
    }

    private func scrollToBottom() {
        guard !messages.isEmpty else { return }

        let indexPath = IndexPath(row: messages.count - 1, section: 0)
        tableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
    }

    // Shows simple error alert.
    private func showAlert(message: String) {
        let alert = UIAlertController(
            title: "Error",
            message: message,
            preferredStyle: .alert
        )

        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}

extension ChatViewController: ChatViewProtocol {

    func showMessages(_ messages: [Message], currentUserEmail: String?) {
        self.messages = messages
        self.currentUserEmail = currentUserEmail

        tableView.reloadData()
        scrollToBottom()
    }

    func showError(_ message: String) {
        showAlert(message: message)
    }

    func clearInput() {
        messageTextField.text = nil
    }
}

extension ChatViewController: UITableViewDataSource, UITableViewDelegate {

    func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int
    ) -> Int {
        messages.count
    }

    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: MessageCell.identifier,
            for: indexPath
        ) as? MessageCell

        let message = messages[indexPath.row]
        let isOwnMessage = message.sender == currentUserEmail

        cell?.configure(with: message, isOwnMessage: isOwnMessage)

        return cell ?? UITableViewCell()
    }
}
