import Foundation

protocol RegisterViewProtocol: AnyObject {
    func setLoading(_ isLoading: Bool)
    func showError(_ message: String)
}

