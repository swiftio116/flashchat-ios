import UIKit

final class WelcomeViewController: UIViewController {

    private let presenter: WelcomePresenter

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 42, weight: .heavy)
        label.textColor = .label
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

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

    init(presenter: WelcomePresenter) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) is unavailable. Use init(presenter:).")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        presenter.viewDidLoad()
    }

    private func setupUI() {
        view.backgroundColor = .systemBackground
        title = "FlashChat"

        view.addSubview(titleLabel)
        view.addSubview(loginButton)
        view.addSubview(registerButton)

        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -120),

            loginButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
            loginButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32),
            loginButton.heightAnchor.constraint(equalToConstant: 56),
            loginButton.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 80),

            registerButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
            registerButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32),
            registerButton.heightAnchor.constraint(equalToConstant: 56),
            registerButton.topAnchor.constraint(equalTo: loginButton.bottomAnchor, constant: 16)
        ])
    }

    @objc private func loginButtonTapped() {
        presenter.loginButtonTapped()
    }

    @objc private func registerButtonTapped() {
        presenter.registerButtonTapped()
    }
}

extension WelcomeViewController: WelcomeViewProtocol {

    func setTitle(_ title: String) {
        titleLabel.text = title
    }
}
