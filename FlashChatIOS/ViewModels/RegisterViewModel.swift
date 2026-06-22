import Foundation

/// Handles registration validation and user creation flow.
final class RegisterViewModel {
    
    private let authService: AuthServicing
    
    var onSuccess: (() -> Void)?
    var onError: ((String) -> Void)?
    
    /// Injects an authentication service to keep registration logic testable.
    init(authService: AuthServicing) {
        self.authService = authService
    }
    
    func register(name: String?, email: String?, password: String?) {
        guard let name = name?.trimmingCharacters(in: .whitespacesAndNewlines),
              !name.isEmpty else {
            onError?("Enter name")
            return
        }
        
        guard let email = email?.trimmingCharacters(in: .whitespacesAndNewlines),
              !email.isEmpty else {
            onError?("Enter email")
            return
        }
        
        guard let password = password,
              !password.isEmpty else {
            onError?("Enter password")
            return
        }
        
        authService.registerUser(
            name: name,
            email: email,
            password: password
        ) { [weak self] result in
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
