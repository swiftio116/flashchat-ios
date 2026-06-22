import Foundation

/// Describes chat data operations used by the chat screen.
///
/// This abstraction hides Firestore details from `ChatViewModel`
/// and allows using a mock chat service in unit tests.
protocol ChatServicing {
    func startListening(completion: @escaping (Result<[Message], Error>) -> Void)
    func stopListening()
    
    func sendMessage(
        sender: String,
        senderName: String,
        body: String,
        completion: @escaping (Error?) -> Void
    )
}
