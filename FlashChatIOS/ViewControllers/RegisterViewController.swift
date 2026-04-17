import UIKit

class RegisterViewController: UIViewController {

    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!

    private let viewModel = RegisterViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bindViewModel()
    }

    private func setupUI() {
        nameTextField.text = ""
        emailTextField.text = ""
        passwordTextField.text = ""

        nameTextField.attributedPlaceholder = NSAttributedString(
            string: "Name",
            attributes: [.foregroundColor: UIColor.black.withAlphaComponent(0.5)]
        )

        emailTextField.attributedPlaceholder = NSAttributedString(
            string: "Email",
            attributes: [.foregroundColor: UIColor.gray]
        )

        passwordTextField.attributedPlaceholder = NSAttributedString(
            string: "Password",
            attributes: [.foregroundColor: UIColor.gray]
        )

        nameTextField.isSecureTextEntry = false
        emailTextField.isSecureTextEntry = false
        passwordTextField.isSecureTextEntry = true

        [nameTextField, emailTextField, passwordTextField].forEach {
            $0?.layer.cornerRadius = 20
            $0?.clipsToBounds = true
            $0?.backgroundColor = UIColor.white.withAlphaComponent(0.8)
        }

        nameTextField.setLeftPadding(16)
        emailTextField.setLeftPadding(16)
        passwordTextField.setLeftPadding(16)
    }

    private func bindViewModel() {
        viewModel.onSuccess = { [weak self] in
            DispatchQueue.main.async {
                self?.performSegue(withIdentifier: K.registerSegue, sender: self)
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
    }

    @IBAction func registerPressed(_ sender: UIButton) {
        viewModel.register(
            name: nameTextField.text,
            email: emailTextField.text,
            password: passwordTextField.text
        )
    }
}

extension UITextField {
    func setLeftPadding(_ amount: CGFloat) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: 1))
        leftView = paddingView
        leftViewMode = .always
    }
}
