import UIKit

final class RegisterViewController: UIViewController {

    private let presenter: RegisterPresenter

    // Email input field.
    private let emailTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Email"
        textField.borderStyle = .roundedRect
        textField.keyboardType = .emailAddress
        textField.autocapitalizationType = .none
        textField.autocorrectionType = .no
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()

    // Password input field.
    private let passwordTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Password"
        textField.borderStyle = .roundedRect
        textField.isSecureTextEntry = true
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()

    // Register action button.
    private lazy var registerButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Register", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 20, weight: .semibold)
        button.backgroundColor = .systemTeal
        button.tintColor = .white
        button.layer.cornerRadius = 12
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(registerButtonTapped), for: .touchUpInside)
        return button
    }()

    // Shows loading state.
    private let activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .medium)
        indicator.hidesWhenStopped = true
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
    }()

    init(presenter: RegisterPresenter) {
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
    }

    // Sets up views and layout.
    private func setupUI() {
        view.backgroundColor = .systemBackground
        title = "Register"

        view.addSubview(emailTextField)
        view.addSubview(passwordTextField)
        view.addSubview(registerButton)
        view.addSubview(activityIndicator)

        NSLayoutConstraint.activate([
            emailTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
            emailTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32),
            emailTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 80),
            emailTextField.heightAnchor.constraint(equalToConstant: 48),

            passwordTextField.leadingAnchor.constraint(equalTo: emailTextField.leadingAnchor),
            passwordTextField.trailingAnchor.constraint(equalTo: emailTextField.trailingAnchor),
            passwordTextField.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 16),
            passwordTextField.heightAnchor.constraint(equalToConstant: 48),

            registerButton.leadingAnchor.constraint(equalTo: emailTextField.leadingAnchor),
            registerButton.trailingAnchor.constraint(equalTo: emailTextField.trailingAnchor),
            registerButton.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 24),
            registerButton.heightAnchor.constraint(equalToConstant: 56),

            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.topAnchor.constraint(equalTo: registerButton.bottomAnchor, constant: 24)
        ])
    }

    @objc private func registerButtonTapped() {
        presenter.didTapRegister(
            email: emailTextField.text,
            password: passwordTextField.text
        )
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

extension RegisterViewController: RegisterViewProtocol {

    func setLoading(_ isLoading: Bool) {
        registerButton.isEnabled = !isLoading

        if isLoading {
            activityIndicator.startAnimating()
        } else {
            activityIndicator.stopAnimating()
        }
    }

    func showError(_ message: String) {
        showAlert(message: message)
    }
}
