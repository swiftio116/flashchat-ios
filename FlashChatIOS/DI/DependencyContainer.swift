import Foundation

final class DependencyContainer {

    // Shared app services.
    let authService: AuthServicing
    let chatService: ChatServicing

    init() {
        self.authService = AuthService()
        self.chatService = ChatService()
    }
}
