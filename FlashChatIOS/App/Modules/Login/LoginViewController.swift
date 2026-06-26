import UIKit

final class LoginViewController: UIViewController {

    private let presenter: LoginPresenter

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

    // Login action button.
    private lazy var loginButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Log In", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 20, weight: .semibold)
        button.backgroundColor = .systemBlue
        button.tintColor = .white
        button.layer.cornerRadius = 12
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(loginButtonTapped), for: .touchUpInside)
        return button
    }()

    // Shows loading state.
    private let activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .medium)
        indicator.hidesWhenStopped = true
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
    }()

    init(presenter: LoginPresenter) {
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
        title = "Log In"

        view.addSubview(emailTextField)
        view.addSubview(passwordTextField)
        view.addSubview(loginButton)
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

            loginButton.leadingAnchor.constraint(equalTo: emailTextField.leadingAnchor),
            loginButton.trailingAnchor.constraint(equalTo: emailTextField.trailingAnchor),
            loginButton.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 24),
            loginButton.heightAnchor.constraint(equalToConstant: 56),

            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.topAnchor.constraint(equalTo: loginButton.bottomAnchor, constant: 24)
        ])
    }

    @objc private func loginButtonTapped() {
        presenter.didTapLogin(
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

extension LoginViewController: LoginViewProtocol {

    func setLoading(_ isLoading: Bool) {
        loginButton.isEnabled = !isLoading

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
