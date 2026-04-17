import UIKit

final class ChatViewController: UIViewController {
    
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var messageTextfield: UITextField!
    
    @IBOutlet weak var attachButton: UIButton!
    private let viewModel = ChatViewModel()
    
    private let timeFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        messageTextfield.delegate = self
        tableView.keyboardDismissMode = .interactive
        
        title = K.appName
        navigationItem.hidesBackButton = true
        
        tableView.register(
            UINib(nibName: K.cellNibName, bundle: nil),
            forCellReuseIdentifier: K.cellIdentifier
        )
        
        setupKeyboardObservers()
        setupTapGesture()
        bindViewModel()
        
        viewModel.startListening()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
        viewModel.stopListening()
    }
    
    private func bindViewModel() {
        viewModel.onMessagesUpdated = { [weak self] in
            guard let self else { return }
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
                self.scrollToBottom(animated: true)
            }
        }
        
        viewModel.onError = { [weak self] errorMessage in
            DispatchQueue.main.async {
                let alert = UIAlertController(
                    title: "Error",
                    message: errorMessage,
                    preferredStyle: .alert
                )
                alert.addAction(UIAlertAction(title: "OK", style: .default))
                self?.present(alert, animated: true)
            }
        }
        
        viewModel.onLogoutSuccess = { [weak self] in
            DispatchQueue.main.async {
                self?.navigationController?.popToRootViewController(animated: true)
            }
        }
    }
    
    private func setupKeyboardObservers() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillHide),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
    }
    
    private func setupTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        tableView.addGestureRecognizer(tapGesture)
    }
    
    @objc private func handleTap() {
        view.endEditing(true)
    }
    
    @objc private func keyboardWillShow(notification: Notification) {
        guard let keyboardFrameValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else {
            return
        }
        
        let keyboardHeight = keyboardFrameValue.cgRectValue.height
        bottomConstraint.constant = keyboardHeight
        
        UIView.animate(withDuration: 0.25) {
            self.view.layoutIfNeeded()
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
            self.scrollToBottom(animated: true)
        }
    }
    
    @objc private func keyboardWillHide(notification: Notification) {
        bottomConstraint.constant = 0
        
        UIView.animate(withDuration: 0.25) {
            self.view.layoutIfNeeded()
        }
    }
    
    @IBAction func sendPressed(_ sender: UIButton) {
        sendCurrentMessage()
    }
    
    @IBAction func logOutPressed(_ sender: UIBarButtonItem) {
        viewModel.logout()
    }
    
    private func sendCurrentMessage() {
        let text = messageTextfield.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        guard !text.isEmpty else { return }
        
        viewModel.sendMessage(text: text) { [weak self] in
            DispatchQueue.main.async {
                self?.messageTextfield.text = ""
                self?.scrollToBottom(animated: true)
            }
        }
    }
    
    private func scrollToBottom(animated: Bool) {
        let count = viewModel.messagesCount
        guard count > 0 else { return }
        
        let lastRow = count - 1
        
        guard tableView.numberOfSections > 0,
              tableView.numberOfRows(inSection: 0) > lastRow else {
            return
        }
        
        let indexPath = IndexPath(row: lastRow, section: 0)
        
        DispatchQueue.main.async {
            self.tableView.scrollToRow(at: indexPath, at: .bottom, animated: animated)
        }
    }
}

extension ChatViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.messagesCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: K.cellIdentifier,
            for: indexPath
        ) as! MessageCell
        
        let message = viewModel.message(at: indexPath.row)
        
        cell.configure(
            with: message,
            isCurrentUser: viewModel.isCurrentUserMessage(message),
            formatter: timeFormatter
        )
        
        cell.alpha = 0
        cell.transform = CGAffineTransform(translationX: 0, y: 10)
        
        UIView.animate(withDuration: 0.2) {
            cell.alpha = 1
            cell.transform = .identity
        }
        
        return cell
    }
}

extension ChatViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        sendCurrentMessage()
        return false
    }
}
