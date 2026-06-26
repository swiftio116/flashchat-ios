import UIKit

final class AppCoordinator {

    // Main app window.
    private let window: UIWindow

    // Handles navigation between screens.
    private let navigationController = UINavigationController()

    init(window: UIWindow) {
        self.window = window
    }

    // Starts the app flow.
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
        let viewController = UIViewController()
        viewController.view.backgroundColor = .systemBlue
        viewController.title = "Login"

        navigationController.pushViewController(viewController, animated: true)
    }

    func showRegister() {
        let viewController = UIViewController()
        viewController.view.backgroundColor = .systemTeal
        viewController.title = "Register"

        navigationController.pushViewController(viewController, animated: true)
    }
}
