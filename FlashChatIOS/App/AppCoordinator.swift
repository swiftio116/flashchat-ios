import UIKit

final class AppCoordinator {

    private let window: UIWindow
    private let navigationController = UINavigationController()

    private let authService: AuthServicing = AuthService()

    init(window: UIWindow) {
        self.window = window
    }

    func start() {
        showWelcome()

        window.rootViewController = navigationController
        window.makeKeyAndVisible()
    }

    func showWelcome() {
        let presenter = WelcomePresenter(coordinator: self)
        let viewController = WelcomeViewController(presenter: presenter)

        presenter.view = viewController
        navigationController.setViewControllers([viewController], animated: false)
    }

    func showLogin() {
        let presenter = LoginPresenter(
            authService: authService,
            coordinator: self
        )

        let viewController = LoginViewController(presenter: presenter)
        presenter.view = viewController

        navigationController.pushViewController(viewController, animated: true)
    }

    func showRegister() {
        let presenter = RegisterPresenter(
            authService: authService,
            coordinator: self
        )

        let viewController = RegisterViewController(presenter: presenter)
        presenter.view = viewController

        navigationController.pushViewController(viewController, animated: true)
    }

    func showChat() {
        let viewController = UIViewController()
        viewController.view.backgroundColor = .systemBackground
        viewController.title = "Chat"

        navigationController.setViewControllers([viewController], animated: true)
    }
}
