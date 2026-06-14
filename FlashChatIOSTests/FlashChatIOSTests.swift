import Testing
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
}
