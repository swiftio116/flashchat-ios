import Foundation

final class RegisterViewModel {
    private let authService = AuthService()

    var onSuccess: (() -> Void)?
    var onError: ((String) -> Void)?

    func register(name: String?, email: String?, password: String?) {
        guard let name = name?.trimmingCharacters(in: .whitespacesAndNewlines),
              !name.isEmpty else {
            onError?("Введите имя")
            return
        }

        guard let email = email?.trimmingCharacters(in: .whitespacesAndNewlines),
              !email.isEmpty else {
            onError?("Введите email")
            return
        }

        guard let password = password,
              !password.isEmpty else {
            onError?("Введите пароль")
            return
        }

        authService.registerUser(name: name, email: email, password: password) { [weak self] result in
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
