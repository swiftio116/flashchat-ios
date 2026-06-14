import Foundation
@testable import Flash_Chat_IOS
final class MockAuthService: AuthServicing {
    
    var currentUserEmail: String?
    var currentUserName: String?
    var currentUserID: String?
    
    var loginResult: Result<Void, Error> = .success(())
    var registerResult: Result<Void, Error> = .success(())
    var logoutShouldThrow = false
    
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
        if logoutShouldThrow {
            throw NSError(
                domain: "MockAuthService",
                code: -1,
                userInfo: [NSLocalizedDescriptionKey: "Logout failed"]
            )
        }
    }
}
