import Foundation

final class LoginPresenter {

    weak var view: LoginViewProtocol?

    private let authService: AuthServicing
    private weak var coordinator: AppCoordinating?

    init(authService: AuthServicing, coordinator: AppCoordinating) {

        self.authService = authService

        self.coordinator = coordinator

    }

    func didTapLogin(email: String?, password: String?) {
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

        authService.login(email: email, password: password) { [weak self] result in
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
