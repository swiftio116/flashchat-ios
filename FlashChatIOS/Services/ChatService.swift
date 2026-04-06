import Foundation
import FirebaseFirestore

final class ChatService {
    
    private let db = Firestore.firestore()
    
    func loadMessages(completion: @escaping (Result<[Message], Error>) -> Void) {
        db.collection(K.FStore.collectionName)
            .order(by: K.FStore.dateField)
            .addSnapshotListener { querySnapshot, error in
                if let error = error {
                    completion(.failure(error))
                    return
                }
                
                var messages: [Message] = []
                
                querySnapshot?.documents.forEach { document in
                    let data = document.data()
                    
                    if let sender = data[K.FStore.senderField] as? String,
                       let body = data[K.FStore.bodyField] as? String,
                       let date = data[K.FStore.dateField] as? Double {
                        
                        let message = Message(sender: sender, body: body, date: date)
                        messages.append(message)
                    
                    }
                }
                
                completion(.success(messages))
            }
    }
    
    func sendMessage(sender: String, body: String, completion: @escaping (Error?) -> Void) {
        db.collection(K.FStore.collectionName).addDocument(data: [
            K.FStore.senderField: sender,
            K.FStore.bodyField: body,
            K.FStore.dateField: Date().timeIntervalSince1970
        ]) { error in
            completion(error)
        }
    }
}
