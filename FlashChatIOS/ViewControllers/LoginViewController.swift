import UIKit

class LoginViewController: UIViewController {
    
    @IBOutlet weak var emailTextfield: UITextField!
    @IBOutlet weak var passwordTextfield: UITextField!
    
    private let viewModel = LoginViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindViewModel()
    }
    
    private func bindViewModel() {
        viewModel.onSuccess = { [weak self] in
            DispatchQueue.main.async {
                self?.performSegue(withIdentifier: K.loginSegue, sender: self)
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
    }
    
    @IBAction func loginPressed(_ sender: UIButton) {
        viewModel.login(
            email: emailTextfield.text,
            password: passwordTextfield.text
        )
    }
}
