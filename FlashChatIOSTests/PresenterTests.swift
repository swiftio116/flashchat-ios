import XCTest
@testable import Flash_Chat_IOS

final class PresenterTests: XCTestCase {

    func testLoginShowsErrorWhenEmailIsEmpty() {
        let view = LoginViewSpy()
        let presenter = LoginPresenter(
            authService: AuthServiceMock(),
            coordinator: CoordinatorMock()
        )

        presenter.view = view
        presenter.didTapLogin(email: "", password: "123456")

        XCTAssertEqual(view.errorMessage, "Enter email")
    }

    func testLoginShowsErrorWhenPasswordIsEmpty() {
        let view = LoginViewSpy()
        let presenter = LoginPresenter(
            authService: AuthServiceMock(),
            coordinator: CoordinatorMock()
        )

        presenter.view = view
        presenter.didTapLogin(email: "test@mail.com", password: "")

        XCTAssertEqual(view.errorMessage, "Enter password")
    }

    func testLoginSuccessOpensChat() {
        let view = LoginViewSpy()
        let coordinator = CoordinatorMock()
        let authService = AuthServiceMock()

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
            authService: AuthServiceMock(),
            coordinator: CoordinatorMock()
        )

        presenter.view = view
        presenter.didTapRegister(email: "test@mail.com", password: "")

        XCTAssertEqual(view.errorMessage, "Enter password")
    }

    func testChatDoesNotSendEmptyMessage() {
        let view = ChatViewSpy()
        let chatService = ChatServiceMock()

        let presenter = ChatPresenter(
            chatService: chatService,
            authService: AuthServiceMock(),
            coordinator: CoordinatorMock()
        )

        presenter.view = view
        presenter.didTapSend(text: "   ")

        XCTAssertFalse(chatService.didSendMessage)
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

    func showMessages(_ messages: [Message], currentUserEmail: String?) {}

    func showError(_ message: String) {
        errorMessage = message
    }

    func clearInput() {
        didClearInput = true
    }
}

// MARK: - Mocks

private final class CoordinatorMock: AppCoordinating {

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

private final class AuthServiceMock: AuthServicing {

    var currentUserEmail: String? = "test@mail.com"
    var currentUserName: String? = "Test User"
    var currentUserID: String? = "123"

    func registerUser(
        name: String,
        email: String,
        password: String,
        completion: @escaping (Result<Void, Error>) -> Void
    ) {
        completion(.success(()))
    }

    func fetchCurrentUserName(completion: @escaping (String?) -> Void) {
        completion(currentUserName)
    }

    func login(
        email: String,
        password: String,
        completion: @escaping (Result<Void, Error>) -> Void
    ) {
        completion(.success(()))
    }

    func logout() throws {}
}

private final class ChatServiceMock: ChatServicing {

    var didSendMessage = false

    func startListening(
        completion: @escaping (Result<[Message], Error>) -> Void
    ) {}

    func stopListening() {}

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
