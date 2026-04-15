struct K {
    
    static let appName = "FlashChat"
    
    static let registerSegue = "RegisterToChat"
    static let loginSegue = "LoginToChat"
    static let welcomeSegue = "WelcomeToChat"
    
    static let cellNibName = "MessageCell"
    static let cellIdentifier = "ReusableCell"
    
    struct FStore {
        static let collectionName = "messages"
        static let senderField = "sender"
        static let senderNameField = "senderName"
        static let bodyField = "body"
        static let dateField = "date"
    }
}
