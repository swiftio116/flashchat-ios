import Foundation

/// Handles chat screen logic: loading messages, sending messages and logout.
final class ChatViewModel {
    
    private let authService: AuthServicing
    private let chatService: ChatServicing
    
    private var messages: [Message] = []
    
    var onMessagesUpdated: (() -> Void)?
    var onError: ((String) -> Void)?
    var onLogoutSuccess: (() -> Void)?
    
    /// Injects auth and chat services to keep Firebase dependencies outside the ViewModel.
    init(
        authService: AuthServicing,
        chatService: ChatServicing
    ) {
        self.authService = authService
        self.chatService = chatService
    }
    
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
        let trimmedText = text.trimmingCharacters(in: .whitespacesAndNewlines)
        
        guard !trimmedText.isEmpty else {
            return
        }
        
        let sender = authService.currentUserEmail ?? "unknown_user"
        
        authService.fetchCurrentUserName { [weak self] fetchedName in
            guard let self else { return }
            
            let cleanName = fetchedName?.trimmingCharacters(in: .whitespacesAndNewlines)
            let senderName = (cleanName?.isEmpty == false) ? cleanName! : "User"
            
            self.chatService.sendMessage(
                sender: sender,
                senderName: senderName,
                body: trimmedText
            ) { error in
                DispatchQueue.main.async {
                    if let error {
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
