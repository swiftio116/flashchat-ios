import UIKit

class ChatViewController: UIViewController {
    
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var messageTextfield: UITextField!
    
    private let viewModel = ChatViewModel()
    
    private let timeFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
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
        
        viewModel.loadMessages()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    private func bindViewModel() {
        viewModel.onMessagesUpdated = { [weak self] in
            DispatchQueue.main.async {
                guard let self = self else { return }
                
                self.tableView.reloadData()
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
                    let lastRow = self.viewModel.messagesCount - 1
                    if lastRow >= 0,
                       self.tableView.numberOfRows(inSection: 0) > lastRow {
                        let indexPath = IndexPath(row: lastRow, section: 0)
                        self.tableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
                    }
                }
            }
        }
        
        viewModel.onError = { [weak self] errorMessage in
            DispatchQueue.main.async {
                let alert = UIAlertController(
                    title: "Ошибка",
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
        guard let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        
        let keyboardHeight = keyboardFrame.cgRectValue.height
        bottomConstraint.constant = keyboardHeight
        
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }
    
    @objc private func keyboardWillHide(notification: Notification) {
        bottomConstraint.constant = 0
        
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }
    
    @IBAction func sendPressed(_ sender: UIButton) {
        viewModel.sendMessage(text: messageTextfield.text ?? "") { [weak self] in
            DispatchQueue.main.async {
                self?.messageTextfield.text = ""
                self?.view.endEditing(true)
            }
        }
    }
    
    @IBAction func logOutPressed(_ sender: UIBarButtonItem) {
        viewModel.logout()
    }
}

extension ChatViewController: UITableViewDataSource {
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
        
        // 🔥 АНИМАЦИЯ
        cell.alpha = 0
        cell.transform = CGAffineTransform(translationX: 0, y: 10)
        
        UIView.animate(withDuration: 0.25) {
            cell.alpha = 1
            cell.transform = .identity
        }
        
        return cell
    }
}

extension ChatViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let text = textField.text,
           !text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            
            viewModel.sendMessage(text: text) { [weak self] in
                DispatchQueue.main.async {
                    self?.messageTextfield.text = ""
                    self?.view.endEditing(true)
                }
            }
        }
        return true
    }
}
