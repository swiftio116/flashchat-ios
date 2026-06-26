import Foundation

protocol ChatViewProtocol: AnyObject {
    func showMessages(_ messages: [Message], currentUserEmail: String?)
    func showError(_ message: String)
    func clearInput()
}
