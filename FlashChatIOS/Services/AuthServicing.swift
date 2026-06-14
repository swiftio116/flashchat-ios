import Foundation

protocol AuthServicing {
    var currentUserEmail: String? { get }
    var currentUserName: String? { get }
    var currentUserID: String? { get }
    
    func registerUser(
        name: String,
        email: String,
        password: String,
        completion: @escaping (Result<Void, Error>) -> Void
    )
    
    func fetchCurrentUserName(completion: @escaping (String?) -> Void)
    
    func login(
        email: String,
        password: String,
        completion: @escaping (Result<Void, Error>) -> Void
    )
    
    func logout() throws
}
