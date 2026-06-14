import Foundation

final class LoginViewModel {
    private let authService: AuthServicing

    var onSuccess: (() -> Void)?
    var onError: ((String) -> Void)?

    init(authService: AuthServicing = AuthService()) {
        self.authService = authService
    }

    func login(email: String?, password: String?) {
        guard let email = email?.trimmingCharacters(in: .whitespacesAndNewlines),
              !email.isEmpty,
              let password = password,
              !password.isEmpty else {
            onError?("Enter your email and password")
            return
        }

        authService.login(email: email, password: password) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success:
                    self?.onSuccess?()
                case .failure(let error):
                    self?.onError?(error.localizedDescription)
                }
            }
        }
    }
}
