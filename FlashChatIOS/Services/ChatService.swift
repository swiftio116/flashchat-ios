import Foundation
import FirebaseFirestore

final class ChatService {
    private let db = Firestore.firestore()
    private var listener: ListenerRegistration?

    func startListening(completion: @escaping (Result<[Message], Error>) -> Void) {
        listener?.remove()

        listener = db.collection("messages")
            .order(by: "date")
            .addSnapshotListener { snapshot, error in
                if let error = error {
                    completion(.failure(error))
                    return
                }

                guard let documents = snapshot?.documents else {
                    completion(.success([]))
                    return
                }

                let messages: [Message] = documents.compactMap { document in
                    let data = document.data()

                    guard
                        let sender = data["sender"] as? String,
                        let body = data["body"] as? String,
                        let timestamp = data["date"] as? Timestamp
                    else {
                        return nil
                    }

                    let rawSenderName = (data["senderName"] as? String)?
                        .trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)

                    let fallbackName = sender.components(separatedBy: "@").first ?? "User"
                    let finalSenderName = (rawSenderName?.isEmpty == false) ? rawSenderName! : fallbackName

                    return Message(
                        sender: sender,
                        senderName: finalSenderName,
                        body: body,
                        date: timestamp.dateValue()
                    )
                }

                completion(.success(messages))
            }
    }

    func stopListening() {
        listener?.remove()
        listener = nil
    }

    func sendMessage(
        sender: String,
        senderName: String,
        body: String,
        completion: @escaping (Error?) -> Void
    ) {
        let cleanSenderName = senderName.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        let finalSenderName = cleanSenderName.isEmpty
            ? (sender.components(separatedBy: "@").first ?? "User")
            : cleanSenderName

        let messageData: [String: Any] = [
            "sender": sender,
            "senderName": finalSenderName,
            "body": body,
            "date": Timestamp(date: Date())
        ]

        db.collection("messages").addDocument(data: messageData) { error in
            completion(error)
        }
    }
}
