import Foundation

protocol ChatViewProtocol: AnyObject {
    func showMessages(_ messages: [Message])
    func showError(_ message: String)
    func clearInput()
}
