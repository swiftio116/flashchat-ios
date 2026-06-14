import Testing
import Foundation
@testable import Flash_Chat_IOS
struct FlashChatIOSTests {
    
    @Test
    func loginWithEmptyEmailShowsError() {
        let mockAuthService = MockAuthService()
        let viewModel = LoginViewModel(authService: mockAuthService)
        
        var receivedError: String?
        
        viewModel.onError = { error in
            receivedError = error
        }
        
        viewModel.login(email: "", password: "123456")
        
        #expect(receivedError == "Enter your email and password")
    }
    
    @Test
    func loginWithEmptyPasswordShowsError() {
        let mockAuthService = MockAuthService()
        let viewModel = LoginViewModel(authService: mockAuthService)
        
        var receivedError: String?
        
        viewModel.onError = { error in
            receivedError = error
        }
        
        viewModel.login(email: "test@mail.com", password: "")
        
        #expect(receivedError == "Enter your email and password")
    }
    
    @Test
    @MainActor
    func loginWithValidCredentialsCallsSuccess() async {
        let mockAuthService = MockAuthService()
        let viewModel = LoginViewModel(authService: mockAuthService)

        var didCallSuccess = false

        viewModel.onSuccess = {
            didCallSuccess = true
        }

        viewModel.login(email: "test@mail.com", password: "123456")

        await Task.yield()

        #expect(didCallSuccess == true)
    }
    
    @Test
    func registerWithEmptyNameShowsError() {
        let mockAuthService = MockAuthService()
        let viewModel = RegisterViewModel(authService: mockAuthService)
        
        var receivedError: String?
        
        viewModel.onError = { error in
            receivedError = error
        }
        
        viewModel.register(name: "", email: "test@mail.com", password: "123456")
        
        #expect(receivedError == "Enter name")
    }
    
    @Test
    func registerWithEmptyEmailShowsError() {
        let mockAuthService = MockAuthService()
        let viewModel = RegisterViewModel(authService: mockAuthService)
        
        var receivedError: String?
        
        viewModel.onError = { error in
            receivedError = error
        }
        
        viewModel.register(name: "Aiaz", email: "", password: "123456")
        
        #expect(receivedError == "Enter email")
    }
    
    @Test
    func registerWithEmptyPasswordShowsError() {
        let mockAuthService = MockAuthService()
        let viewModel = RegisterViewModel(authService: mockAuthService)
        
        var receivedError: String?
        
        viewModel.onError = { error in
            receivedError = error
        }
        
        viewModel.register(name: "Aiaz", email: "test@mail.com", password: "")
        
        #expect(receivedError == "Enter password")
    }
    @Test
    @MainActor
    func startListeningUpdatesMessagesCount() async {
        let mockAuthService = MockAuthService()
        let mockChatService = MockChatService()
        
        mockChatService.messagesResult = .success([
            Message(sender: "user1@mail.com", senderName: "User 1", body: "Hello", date: Date()),
            Message(sender: "user2@mail.com", senderName: "User 2", body: "Hi", date: Date())
        ])
        
        let viewModel = ChatViewModel(
            authService: mockAuthService,
            chatService: mockChatService
        )
        
        viewModel.startListening()
        
        await Task.yield()
        
        #expect(viewModel.messagesCount == 2)
    }

    @Test
    func isCurrentUserMessageReturnsTrueForCurrentUser() {
        let mockAuthService = MockAuthService()
        let mockChatService = MockChatService()
        
        mockAuthService.currentUserEmail = "user@mail.com"
        
        let viewModel = ChatViewModel(
            authService: mockAuthService,
            chatService: mockChatService
        )
        
        let message = Message(
            sender: "user@mail.com",
            senderName: "Aiaz",
            body: "Hello",
            date: Date()
        )
        
        #expect(viewModel.isCurrentUserMessage(message) == true)
    }

    @Test
    func isCurrentUserMessageReturnsFalseForAnotherUser() {
        let mockAuthService = MockAuthService()
        let mockChatService = MockChatService()
        
        mockAuthService.currentUserEmail = "user@mail.com"
        
        let viewModel = ChatViewModel(
            authService: mockAuthService,
            chatService: mockChatService
        )
        
        let message = Message(
            sender: "another@mail.com",
            senderName: "Another User",
            body: "Hello",
            date: Date()
        )
        
        #expect(viewModel.isCurrentUserMessage(message) == false)
    }

    @Test
    func sendEmptyMessageDoesNotCallChatService() {
        let mockAuthService = MockAuthService()
        let mockChatService = MockChatService()
        
        let viewModel = ChatViewModel(
            authService: mockAuthService,
            chatService: mockChatService
        )
        
        viewModel.sendMessage(text: "   ")
        
        #expect(mockChatService.didCallSendMessage == false)
    }
}
