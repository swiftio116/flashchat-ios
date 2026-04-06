import Foundation

final class ChatViewModel {
    
    private let chatService = ChatService()
    private let authService = AuthService()
    
    var messages: [Message] = []
    
    var onMessagesUpdated: (() -> Void)?
    var onError: ((String) -> Void)?
    var onLogoutSuccess: (() -> Void)?
    
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
        
        let sender = authService.currentUserEmail ?? "test_user"
        
        chatService.sendMessage(sender: sender, body: trimmedText) { [weak self] error in
            if let error = error {
                self?.onError?(error.localizedDescription)
            } else {
                completion?()
            }
        }
    }
    
    func logout() {
        authService.logout { [weak self] result in
            switch result {
            case .success:
                self?.onLogoutSuccess?()
            case .failure(let error):
                self?.onError?(error.localizedDescription)
            }
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
