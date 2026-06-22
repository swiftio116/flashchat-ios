# 🚀 FlashChat iOS

A real-time iOS chat application built with **Swift**, **UIKit**, **Firebase**, **MVVM architecture**, **Dependency Injection**, and **Unit Testing**.

The project demonstrates real-time messaging, Firebase Authentication, Cloud Firestore integration, protocol-based service abstraction, testable ViewModels, code documentation, and unit testing with mock services.

---

## 📱 Demo

![FlashChat Demo](Screenshots/flashchat-demo.gif)

> Real-time messaging, attachments, and smooth UI interactions.

---

## ✨ Features

- 🔐 Authentication: login and registration via Firebase Auth
- 💬 Real-time messaging with Cloud Firestore listener
- 🧠 MVVM architecture
- 🔌 Dependency Injection using protocols and `DependencyContainer`
- 🧪 Unit testing with mock services
- 🖼 Custom message cells for incoming and outgoing messages
- 👤 Avatar generation based on username initials
- 🕒 Message timestamps
- 📜 Auto-scroll to the latest message
- ⌨️ Smooth keyboard handling with constraints
- 📱 UIKit-based responsive interface

### 📎 Attachments UI

- 📷 Camera
- 🖼 Photo Library
- 📄 Files
- 📍 Location UI

---

## 📸 Screenshots

### 🚀 Welcome Screen

![Welcome](Screenshots/Welcome.png)

### 🔐 Login Screen

![Login](Screenshots/Login.png)

### 📝 Register Screen

![Register](Screenshots/Register.png)

### 💬 Chat Screen

![Chat](Screenshots/Chat.png)

### 📎 Attachment Menu

![Attachment Menu](Screenshots/attachment-menu.png)

---

## 🛠 Tech Stack

- [Swift](https://www.swift.org/)
- [UIKit](https://developer.apple.com/documentation/uikit)
- [Firebase Authentication](https://firebase.google.com/docs/auth)
- [Cloud Firestore](https://firebase.google.com/docs/firestore)
- Swift Package Manager
- MVVM Architecture
- Dependency Injection
- Unit Testing
- Auto Layout
- UITableView
- Git & GitHub

---

## 🧪 Testing

The project includes **10 Unit Tests** for ViewModels and business logic.

### LoginViewModel Tests

- Empty email validation
- Empty password validation
- Successful login flow

### RegisterViewModel Tests

- Empty name validation
- Empty email validation
- Empty password validation

### ChatViewModel Tests

- Message listener updates message count
- Current user message detection
- Other user message detection
- Empty message validation

### Mock Services

The test suite uses:

- `MockAuthService`
- `MockChatService`

This allows ViewModels to be tested independently from Firebase and network dependencies.

---

## 🧱 Architecture

The project follows **MVVM (Model-View-ViewModel)**.

### Architecture Flow

```text
ViewController
      ↓
DependencyContainer
      ↓
ViewModel
      ↓
Service Protocols
      ↓
Firebase Services
      ↓
Firebase
```

### Architecture Diagram

```text
┌───────────────────┐
│  ViewController   │
└─────────┬─────────┘
          ↓
┌───────────────────┐
│DependencyContainer│
└─────────┬─────────┘
          ↓
┌───────────────────┐
│     ViewModel     │
└─────────┬─────────┘
          ↓
┌───────────────────┐
│ Service Protocols │
│ Auth / Chat       │
└─────────┬─────────┘
          ↓
┌───────────────────┐
│ Firebase Services │
│ AuthService       │
│ ChatService       │
└─────────┬─────────┘
          ↓
┌───────────────────┐
│     Firebase      │
│ Auth + Firestore  │
└───────────────────┘
```

### Why MVVM?

- Separates UI from business logic
- Improves testability
- Makes the code easier to scale
- Reduces ViewController complexity
- Keeps Firebase logic outside ViewControllers

### ViewControllers

Responsible for:

- UI rendering
- User interactions
- Navigation
- Binding with ViewModels

### ViewModels

Responsible for:

- Input validation
- Presentation logic
- Authentication flow
- Chat logic
- Communication with service protocols

### Models

Responsible for representing app data structures, such as chat messages.

### Services

Responsible for Firebase communication:

- Authentication
- Firestore message loading
- Firestore message sending
- User profile fetching

---

## 🔌 Dependency Injection

Services are injected into ViewModels through protocols.

### Dependency Container

`DependencyContainer` builds app dependencies in one place and provides configured ViewModels to ViewControllers.

```swift
final class DependencyContainer {
    static let shared = DependencyContainer()

    func makeLoginViewModel() -> LoginViewModel
    func makeRegisterViewModel() -> RegisterViewModel
    func makeChatViewModel() -> ChatViewModel
}
```

This prevents ViewModels from creating concrete Firebase services directly.

### Protocols

- `AuthServicing`
- `ChatServicing`

### Production Services

- `AuthService`
- `ChatService`

### Test Services

- `MockAuthService`
- `MockChatService`

This improves testability, maintainability, and separation of concerns.

---

## 🔥 Firebase Integration

The application uses Firebase for:

### Authentication

- User registration
- User login
- User logout

### Cloud Firestore

- Real-time message storage
- Real-time message updates
- User profile data
- Sender name support

---

## 🔐 Firebase Configuration

The real `GoogleService-Info.plist` file is not committed to the repository.

The repository includes a safe template:

```text
FlashChatIOS/GoogleService-Info.example.plist
```

To run the project locally:

1. Create a Firebase project
2. Download your own `GoogleService-Info.plist`
3. Add it to the `FlashChatIOS` folder
4. Make sure the file is included in the app target

The real Firebase config file is ignored by Git.

---

## 🔄 App Flow

```text
Welcome Screen
      ↓
Login / Register
      ↓
Firebase Authentication
      ↓
Chat Screen
      ↓
Send / Receive Messages in Real Time
```

---

## ⚙️ Technical Highlights

- Real-time updates using Firestore listeners
- Asynchronous data handling via closures
- Clean separation of layers with MVVM
- Safe UI updates on the main thread
- Dynamic UITableView with reusable cells
- Keyboard-aware layout using constraints
- Custom avatar generation without backend images
- Protocol-based Dependency Injection
- Centralized dependency creation with `DependencyContainer`
- Unit testing with mock services
- Concise code documentation for key architecture components

---

## 🧪 Challenges & Solutions

### Real-time UI Synchronization

**Challenge:** Avoid UI glitches during message updates.

**Solution:**

- Firestore listener
- Safe reload logic
- Scroll-to-bottom handling after updates

### Auto-scroll Stability

**Challenge:** Avoid crashes when scrolling after table reloads.

**Solution:**

- Section and row validation
- Delayed scrolling with `DispatchQueue.main.async`

### Keyboard Handling

**Challenge:** Prevent the keyboard from overlapping the input field.

**Solution:**

- Observed keyboard notifications
- Adjusted bottom constraint dynamically

### Firebase Dependency Isolation

**Challenge:** Keep Firebase-specific logic outside ViewModels and make ViewModels testable.

**Solution:**

- Added service protocols
- Injected services into ViewModels
- Added `DependencyContainer`
- Used mock services in unit tests

---

## 📌 Current Status

✅ MVP Completed

Implemented:

- Firebase Authentication: Login / Register / Logout
- Firestore real-time messaging
- Chat UI with custom cells
- Attachment menu UI
- Keyboard handling
- Auto-scroll
- MVVM architecture
- Dependency Injection with `DependencyContainer`
- Unit tests with mock services
- Safe Firebase config handling
- Concise code documentation

---

## 📂 Project Structure

```text
FlashChatIOS
├── DI
├── Models
├── Services
├── ViewModels
├── ViewControllers
├── Views
├── SupportingFiles
├── FlashChatIOSTests
├── Assets
└── Screenshots
```

---

## ⚙️ Setup

Clone the repository:

```bash
git clone https://github.com/swiftio116/flashchat-ios.git
cd flashchat-ios
```

Open the project:

```bash
open FlashChatIOS.xcodeproj
```

Add your Firebase configuration file:

```text
FlashChatIOS/GoogleService-Info.plist
```

You can use the example file as a reference:

```text
FlashChatIOS/GoogleService-Info.example.plist
```

Run the project in Xcode.

---

## 📚 What I Learned

- Working with Firebase Authentication
- Working with Cloud Firestore real-time updates
- Applying MVVM architecture in UIKit
- Using Dependency Injection through protocols
- Creating a simple dependency container
- Writing unit tests with mock services
- Separating ViewController logic from business logic
- Documenting key Swift components with concise code comments
- Building reusable custom UITableView cells
- Handling keyboard-driven layout changes
- Managing Git and GitHub workflow
- Keeping sensitive configuration files out of the repository

---

## 🎯 My Contribution

- Designed chat UI and message cell layout
- Refactored the project to MVVM architecture
- Implemented Firestore real-time listener
- Built keyboard-aware input system
- Added attachment menu UI
- Implemented auto-scroll and smooth UX behavior
- Added Dependency Injection for Auth and Chat services
- Added `DependencyContainer` for centralized dependency creation
- Added unit tests for Login, Register, and Chat ViewModels
- Removed real Firebase config from the repository
- Added safe Firebase config example file
- Added concise code documentation for key components

---

## 📌 Future Improvements

- ✔ Read receipts
- 🖼 Media upload with Firebase Storage
- 👥 Group chats
- 🟢 Online / offline status
- 🔔 Push notifications
- 📎 Image sharing
- 📱 SwiftUI migration

---

## 👨‍💻 Author

**Aiaz Muzafarov**

- GitHub: [swiftio116](https://github.com/swiftio116)
- LinkedIn: [Aiaz Muzafarov](https://www.linkedin.com/in/aiaz-muzafarov-546a4a288)
````
