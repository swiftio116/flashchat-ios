import Foundation

/// Builds app dependencies and provides configured ViewModels.
///
/// This keeps service creation in one place and prevents ViewModels
/// from creating concrete Firebase services directly.
final class DependencyContainer {
    
    static let shared = DependencyContainer()
    
    private let authService: AuthServicing
    private let chatService: ChatServicing
    
    private init(
        authService: AuthServicing = AuthService(),
        chatService: ChatServicing = ChatService()
    ) {
        self.authService = authService
        self.chatService = chatService
    }
    
    /// Creates a login ViewModel with injected authentication service.
    func makeLoginViewModel() -> LoginViewModel {
        LoginViewModel(authService: authService)
    }
    
    /// Creates a register ViewModel with injected authentication service.
    func makeRegisterViewModel() -> RegisterViewModel {
        RegisterViewModel(authService: authService)
    }
    
    /// Creates a chat ViewModel with injected auth and chat services.
    func makeChatViewModel() -> ChatViewModel {
        ChatViewModel(
            authService: authService,
            chatService: chatService
        )
    }
}
