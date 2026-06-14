import Foundation
@testable import Flash_Chat_IOS

final class MockChatService: ChatServicing {
    
    var messagesResult: Result<[Message], Error> = .success([])
    var didCallStopListening = false
    var didCallSendMessage = false
    var sentMessageBody: String?
    
    func startListening(completion: @escaping (Result<[Message], Error>) -> Void) {
        completion(messagesResult)
    }
    
    func stopListening() {
        didCallStopListening = true
    }
    
    func sendMessage(
        sender: String,
        senderName: String,
        body: String,
        completion: @escaping (Error?) -> Void
    ) {
        didCallSendMessage = true
        sentMessageBody = body
        completion(nil)
    }
}
