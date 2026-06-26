import UIKit

final class AppCoordinator: AppCoordinating {
    private let window: UIWindow
    private let container: DependencyContainer
    private let navigationController = UINavigationController()

    init(window: UIWindow, container: DependencyContainer) {
        self.window = window
        self.container = container
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
            authService: container.authService,
            coordinator: self
        )

        let viewController = LoginViewController(presenter: presenter)
        presenter.view = viewController

        navigationController.pushViewController(viewController, animated: true)
    }

    func showRegister() {
        let presenter = RegisterPresenter(
            authService: container.authService,
            coordinator: self
        )

        let viewController = RegisterViewController(presenter: presenter)
        presenter.view = viewController

        navigationController.pushViewController(viewController, animated: true)
    }
    func showChat() {
        let presenter = ChatPresenter(
            chatService: container.chatService,
            authService: container.authService,
            coordinator: self
        )

        let viewController = ChatViewController(presenter: presenter)
        presenter.view = viewController

        navigationController.setViewControllers([viewController], animated: true)
    }
    
    func logout() {
        showWelcome()
    }
}
