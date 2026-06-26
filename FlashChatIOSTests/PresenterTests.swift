import XCTest
@testable import Flash_Chat_IOS

final class PresenterTests: XCTestCase {

    func testLoginShowsErrorWhenEmailIsEmpty() {
        let view = LoginViewSpy()
        let presenter = LoginPresenter(
            authService: TestAuthService(),
            coordinator: TestCoordinator()
        )

        presenter.view = view
        presenter.didTapLogin(email: "", password: "123456")

        XCTAssertEqual(view.errorMessage, "Enter email")
    }

    func testLoginShowsErrorWhenPasswordIsEmpty() {
        let view = LoginViewSpy()
        let presenter = LoginPresenter(
            authService: TestAuthService(),
            coordinator: TestCoordinator()
        )

        presenter.view = view
        presenter.didTapLogin(email: "test@mail.com", password: "")

        XCTAssertEqual(view.errorMessage, "Enter password")
    }

    func testLoginSuccessOpensChat() {
        let view = LoginViewSpy()
        let coordinator = TestCoordinator()
        let authService = TestAuthService()

        let presenter = LoginPresenter(
            authService: authService,
            coordinator: coordinator
        )

        let expectation = expectation(description: "Login finished")

        view.onLoadingChanged = { isLoading in
            if isLoading == false {
                expectation.fulfill()
            }
        }

        presenter.view = view
        presenter.didTapLogin(email: "test@mail.com", password: "123456")

        wait(for: [expectation], timeout: 1)

        XCTAssertTrue(coordinator.didShowChat)
    }

    func testRegisterShowsErrorWhenPasswordIsEmpty() {
        let view = RegisterViewSpy()
        let presenter = RegisterPresenter(
            authService: TestAuthService(),
            coordinator: TestCoordinator()
        )

        presenter.view = view
        presenter.didTapRegister(email: "test@mail.com", password: "")

        XCTAssertEqual(view.errorMessage, "Enter password")
    }

    func testChatDoesNotSendEmptyMessage() {
        let view = ChatViewSpy()
        let chatService = TestChatService()

        let presenter = ChatPresenter(
            chatService: chatService,
            authService: TestAuthService(),
            coordinator: TestCoordinator()
        )

        presenter.view = view
        presenter.didTapSend(text: "   ")

        XCTAssertFalse(chatService.didSendMessage)
    }

    func testChatClearsInputAfterSuccessfulSend() {
        let view = ChatViewSpy()
        let chatService = TestChatService()
        let authService = TestAuthService()

        authService.currentUserEmail = "test@mail.com"
        authService.currentUserName = "Test User"

        let presenter = ChatPresenter(
            chatService: chatService,
            authService: authService,
            coordinator: TestCoordinator()
        )

        let expectation = expectation(description: "Message sent")

        view.onClearInput = {
            expectation.fulfill()
        }

        presenter.view = view
        presenter.didTapSend(text: "Hello")

        wait(for: [expectation], timeout: 1)

        XCTAssertTrue(chatService.didSendMessage)
        XCTAssertTrue(view.didClearInput)
    }

    func testChatLogoutCallsCoordinator() {
        let view = ChatViewSpy()
        let coordinator = TestCoordinator()

        let presenter = ChatPresenter(
            chatService: TestChatService(),
            authService: TestAuthService(),
            coordinator: coordinator
        )

        presenter.view = view
        presenter.didTapLogout()

        XCTAssertTrue(coordinator.didLogout)
    }
}

// MARK: - View Spies

private final class LoginViewSpy: LoginViewProtocol {

    var errorMessage: String?
    var loadingStates: [Bool] = []
    var onLoadingChanged: ((Bool) -> Void)?

    func setLoading(_ isLoading: Bool) {
        loadingStates.append(isLoading)
        onLoadingChanged?(isLoading)
    }

    func showError(_ message: String) {
        errorMessage = message
    }
}

private final class RegisterViewSpy: RegisterViewProtocol {

    var errorMessage: String?

    func setLoading(_ isLoading: Bool) {}

    func showError(_ message: String) {
        errorMessage = message
    }
}

private final class ChatViewSpy: ChatViewProtocol {

    var errorMessage: String?
    var didClearInput = false
    var onClearInput: (() -> Void)?

    func showMessages(_ messages: [Message], currentUserEmail: String?) {}

    func showError(_ message: String) {
        errorMessage = message
    }

    func clearInput() {
        didClearInput = true
        onClearInput?()
    }
}

// MARK: - Test Doubles

private final class TestCoordinator: AppCoordinating {

    var didShowLogin = false
    var didShowRegister = false
    var didShowChat = false
    var didLogout = false

    func showLogin() {
        didShowLogin = true
    }

    func showRegister() {
        didShowRegister = true
    }

    func showChat() {
        didShowChat = true
    }

    func logout() {
        didLogout = true
    }
}

private final class TestAuthService: AuthServicing {

    var currentUserEmail: String? = "test@mail.com"
    var currentUserName: String? = "Test User"
    var currentUserID: String? = "123"

    var loginResult: Result<Void, Error> = .success(())
    var registerResult: Result<Void, Error> = .success(())
    var shouldFailLogout = false

    func registerUser(
        name: String,
        email: String,
        password: String,
        completion: @escaping (Result<Void, Error>) -> Void
    ) {
        completion(registerResult)
    }

    func fetchCurrentUserName(completion: @escaping (String?) -> Void) {
        completion(currentUserName)
    }

    func login(
        email: String,
        password: String,
        completion: @escaping (Result<Void, Error>) -> Void
    ) {
        completion(loginResult)
    }

    func logout() throws {
        if shouldFailLogout {
            throw NSError(
                domain: "TestAuthService",
                code: -1,
                userInfo: [NSLocalizedDescriptionKey: "Logout failed"]
            )
        }
    }
}

private final class TestChatService: ChatServicing {

    var didSendMessage = false
    var didStartListening = false
    var didStopListening = false

    func startListening(
        completion: @escaping (Result<[Message], Error>) -> Void
    ) {
        didStartListening = true
    }

    func stopListening() {
        didStopListening = true
    }

    func sendMessage(
        sender: String,
        senderName: String,
        body: String,
        completion: @escaping (Error?) -> Void
    ) {
        didSendMessage = true
        completion(nil)
    }
}
