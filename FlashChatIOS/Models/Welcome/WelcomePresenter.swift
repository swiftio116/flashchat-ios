import Foundation

final class WelcomePresenter {

    weak var view: WelcomeViewProtocol?

    private weak var coordinator: AppCoordinator?

    init(coordinator: AppCoordinator) {
        self.coordinator = coordinator
    }

    // Called when the view is loaded.
    func viewDidLoad() {
        view?.setTitle("⚡️FlashChat")
    }

    func loginButtonTapped() {
        coordinator?.showLogin()
    }

    func registerButtonTapped() {
        coordinator?.showRegister()
    }
}
