import Foundation

protocol LoginViewProtocol: AnyObject {
    func setLoading(_ isLoading: Bool)
    func showError(_ message: String)
}
