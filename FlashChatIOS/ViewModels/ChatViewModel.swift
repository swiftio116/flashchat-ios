import Foundation

final class ChatViewModel {
    private let authService = AuthService()
    private let chatService = ChatService()
    private var messages: [Message] = []

    var onMessagesUpdated: (() -> Void)?
    var onLogoutSuccess: (() -> Void)?
    var onError: ((String) -> Void)?

    func loadMessages() {
        chatService.loadMessages { [weak self] result in
            switch result {
            case .success(let messages):
                self?.messages = messages
                self?.onMessagesUpdated?()
            case .failure(let error):
                self?.onError?(error.localizedDescription)
            }
        }
    }

    func sendMessage(text: String, completion: (() -> Void)? = nil) {
        let trimmedText = text.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedText.isEmpty else { return }

        let sender = authService.currentUserEmail ?? "unknown_user"

        chatService.sendMessage(sender: sender, body: trimmedText) { [weak self] error in
            if let error {
                self?.onError?(error.localizedDescription)
            } else {
                completion?()
            }
        }
    }

    func logout() {
        do {
            try authService.logout()
            onLogoutSuccess?()
        } catch {
            onError?(error.localizedDescription)
        }
    }

    func message(at index: Int) -> Message {
        messages[index]
    }

    var messagesCount: Int {
        messages.count
    }

    func isCurrentUserMessage(_ message: Message) -> Bool {
        message.sender == authService.currentUserEmail
    }
}
