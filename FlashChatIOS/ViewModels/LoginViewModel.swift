import Foundation

final class LoginViewModel {
    
    private let authService = AuthService()
    
    var onSuccess: (() -> Void)?
    var onError: ((String) -> Void)?
    
    func login(email: String?, password: String?) {
        guard let email = email, !email.isEmpty,
              let password = password, !password.isEmpty else {
            onError?("Введите email и пароль")
            return
        }
        
        authService.login(email: email, password: password) { [weak self] result in
            switch result {
            case .success:
                self?.onSuccess?()
            case .failure(let error):
                self?.onError?(error.localizedDescription)
            }
        }
    }
}
