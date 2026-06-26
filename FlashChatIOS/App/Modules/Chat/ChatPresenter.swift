import Foundation

final class ChatPresenter {

    weak var view: ChatViewProtocol?

    private let chatService: ChatServicing
    private let authService: AuthServicing
    private weak var coordinator: AppCoordinator?

    init(
        chatService: ChatServicing,
        authService: AuthServicing,
        coordinator: AppCoordinator
    ) {
        self.chatService = chatService
        self.authService = authService
        self.coordinator = coordinator
    }

    // Starts chat updates.
    func viewDidLoad() {
        chatService.startListening { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let messages):
                    self?.view?.showMessages(
                        messages,
                        currentUserEmail: self?.authService.currentUserEmail
                    )

                case .failure(let error):
                    self?.view?.showError(error.localizedDescription)
                }
            }
        }
    }

    // Stops chat updates.
    func viewDidDisappear() {
        chatService.stopListening()
    }

    // Send button action.
    func didTapSend(text: String?) {
        guard let text = text?.trimmingCharacters(in: .whitespacesAndNewlines),
              !text.isEmpty else {
            return
        }

        guard let email = authService.currentUserEmail else {
            view?.showError("User not found")
            return
        }

        let name = authService.currentUserName ?? email

        chatService.sendMessage(
            sender: email,
            senderName: name,
            body: text
        ) { [weak self] error in
            DispatchQueue.main.async {
                if let error = error {
                    self?.view?.showError(error.localizedDescription)
                } else {
                    self?.view?.clearInput()
                }
            }
        }
    }

    func didTapLogout() {
        do {
            try authService.logout()
            coordinator?.logout()
        } catch {
            view?.showError(error.localizedDescription)
        }
    }
}
