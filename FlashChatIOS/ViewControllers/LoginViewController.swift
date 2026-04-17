import UIKit

final class LoginViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    private let viewModel = LoginViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindViewModel()
    }
    
    @IBAction func loginPressed(_ sender: UIButton) {
        viewModel.login(
            email: emailTextField.text,
            password: passwordTextField.text
        )
    }
    
    private func bindViewModel() {
        viewModel.onSuccess = { [weak self] in
            self?.performSegue(withIdentifier: K.loginSegue, sender: self)
        }
        
        viewModel.onError = { [weak self] errorMessage in
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
