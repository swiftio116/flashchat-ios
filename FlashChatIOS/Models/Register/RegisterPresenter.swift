import Foundation

final class RegisterPresenter {

    weak var view: RegisterViewProtocol?

    private let authService: AuthServicing
    private weak var coordinator: AppCoordinator?

    init(authService: AuthServicing, coordinator: AppCoordinator) {
        self.authService = authService
        self.coordinator = coordinator
    }

    // Register button action.
    func didTapRegister(email: String?, password: String?) {
        guard let email = email?.trimmingCharacters(in: .whitespacesAndNewlines),
              !email.isEmpty else {
            view?.showError("Enter email")
            return
        }

        guard let password = password,
              !password.isEmpty else {
            view?.showError("Enter password")
            return
        }

        view?.setLoading(true)

        authService.registerUser(
            name: email,
            email: email,
            password: password
        ) { [weak self] result in
            DispatchQueue.main.async {
                self?.view?.setLoading(false)

                switch result {
                case .success:
                    self?.coordinator?.showChat()

                case .failure(let error):
                    self?.view?.showError(error.localizedDescription)
                }
            }
        }
    }
}
