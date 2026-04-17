import Foundation

final class ChatViewModel {
    private let authService = AuthService()
    private let chatService = ChatService()
    private var messages: [Message] = []

    var onMessagesUpdated: (() -> Void)?
    var onError: ((String) -> Void)?
    var onLogoutSuccess: (() -> Void)?

    func startListening() {
        chatService.startListening { [weak self] result in
            DispatchQueue.main.async {
                guard let self else { return }

                switch result {
                case .success(let messages):
                    self.messages = messages
                    self.onMessagesUpdated?()

                case .failure(let error):
                    self.onError?(error.localizedDescription)
                }
            }
        }
    }

    func stopListening() {
        chatService.stopListening()
    }

    func sendMessage(text: String, completion: (() -> Void)? = nil) {
        let trimmedText = text.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        guard !trimmedText.isEmpty else { return }

        let sender = authService.currentUserEmail ?? "unknown_user"

        authService.fetchCurrentUserName { [weak self] fetchedName in
            guard let self else { return }

            let cleanName = fetchedName?.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
            let senderName = (cleanName?.isEmpty == false) ? cleanName! : "User"

            self.chatService.sendMessage(
                sender: sender,
                senderName: senderName,
                body: trimmedText
            ) { error in
                DispatchQueue.main.async {
                    if let error = error {
                        self.onError?(error.localizedDescription)
                    } else {
                        completion?()
                    }
                }
            }
        }
    }

    func logout() {
        chatService.stopListening()

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
