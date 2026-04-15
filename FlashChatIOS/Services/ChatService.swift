import Foundation
import FirebaseFirestore
import FirebaseAuth

final class ChatService {
    
    private let db = Firestore.firestore()
    
    func loadMessages(completion: @escaping (Result<[Message], Error>) -> Void) {
        db.collection(K.FStore.collectionName)
            .order(by: K.FStore.dateField)
            .addSnapshotListener { snapshot, error in
                
                if let error {
                    completion(.failure(error))
                    return
                }
                
                guard let documents = snapshot?.documents else {
                    completion(.success([]))
                    return
                }
                
                var messages: [Message] = []
                
                for doc in documents {
                    let data = doc.data()
                    
                    if let sender = data[K.FStore.senderField] as? String,
                       let senderName = data[K.FStore.senderNameField] as? String,
                       let body = data[K.FStore.bodyField] as? String,
                       let timestamp = data[K.FStore.dateField] as? Timestamp {
                        
                        let message = Message(
                            sender: sender,
                            senderName: senderName,
                            body: body,
                            date: timestamp.dateValue()
                        )
                        
                        messages.append(message)
                    }
                }
                
                completion(.success(messages))
            }
    }
    
    func sendMessage(
        sender: String,
        body: String,
        completion: @escaping (Error?) -> Void
    ) {
        guard let uid = Auth.auth().currentUser?.uid else {
            completion(NSError(domain: "ChatService", code: -1, userInfo: [
                NSLocalizedDescriptionKey: "Пользователь не авторизован"
            ]))
            return
        }
        
        db.collection("users").document(uid).getDocument { [weak self] snapshot, error in
            guard let self else { return }
            
            if let error {
                completion(error)
                return
            }
            
            let senderName = snapshot?.data()?["name"] as? String ?? "Unknown"
            
            let messageData: [String: Any] = [
                K.FStore.senderField: sender,
                K.FStore.senderNameField: senderName,
                K.FStore.bodyField: body,
                K.FStore.dateField: Timestamp(date: Date())
            ]
            
            self.db.collection(K.FStore.collectionName).addDocument(data: messageData) { error in
                completion(error)
            }
        }
    }
}
