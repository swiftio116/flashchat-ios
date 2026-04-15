import Foundation
import FirebaseAuth
import FirebaseFirestore

final class AuthService {
    private let auth = Auth.auth()
    private let db = Firestore.firestore()

    var currentUserEmail: String? {
        auth.currentUser?.email
    }

    var currentUserID: String? {
        auth.currentUser?.uid
    }

    func registerUser(
        name: String,
        email: String,
        password: String,
        completion: @escaping (Result<Void, Error>) -> Void
    ) {
        let cleanName = name.trimmingCharacters(in: .whitespacesAndNewlines)
        let cleanEmail = email.trimmingCharacters(in: .whitespacesAndNewlines)

        auth.createUser(withEmail: cleanEmail, password: password) { [weak self] result, error in
            guard let self else { return }

            if let error {
                completion(.failure(error))
                return
            }

            guard let user = result?.user else {
                let error = NSError(
                    domain: "AuthService",
                    code: -1,
                    userInfo: [NSLocalizedDescriptionKey: "Не удалось создать пользователя"]
                )
                completion(.failure(error))
                return
            }

            let userData: [String: Any] = [
                "uid": user.uid,
                "name": cleanName,
                "email": cleanEmail,
                "avatarLetter": String(cleanName.prefix(1)).uppercased(),
                "createdAt": Timestamp(date: Date())
            ]

            self.db.collection("users").document(user.uid).setData(userData) { error in
                if let error {
                    completion(.failure(error))
                } else {
                    completion(.success(()))
                }
            }
        }
    }

    func login(
        email: String,
        password: String,
        completion: @escaping (Result<Void, Error>) -> Void
    ) {
        let cleanEmail = email.trimmingCharacters(in: .whitespacesAndNewlines)

        auth.signIn(withEmail: cleanEmail, password: password) { _, error in
            if let error {
                completion(.failure(error))
            } else {
                completion(.success(()))
            }
        }
    }

    func logout() throws {
        try auth.signOut()
    }
}
