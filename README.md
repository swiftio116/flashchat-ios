# Flash Chat iOS

Flash Chat is a simple iOS chat app built with Swift, UIKit and Firebase.

The project was refactored from Storyboard/MVVM to programmatic UIKit with MVP, Coordinator and Dependency Injection.

## Features

- Email registration
- Email login
- Realtime chat with Firestore
- Sending and receiving messages
- Logout
- Custom message cell
- Own and incoming message styles

## Tech Stack

- Swift
- UIKit
- Programmatic UI
- Auto Layout
- Firebase Auth
- Firestore
- MVP
- Coordinator
- Dependency Injection
- XCTest
- Git

## Architecture

The app uses MVP with Coordinator.

```text
ViewController -> Presenter -> Service
                 |
                 v
              Coordinator
```

### ViewController

Responsible for UI only:

- building layout
- handling user actions
- showing errors
- updating table view

### Presenter

Responsible for screen logic:

- validating input
- calling services
- preparing data for view
- asking coordinator to navigate

### Coordinator

Responsible for navigation between screens:

- Welcome
- Login
- Register
- Chat
- Logout

### Services

Firebase logic is hidden behind protocols:

- `AuthServicing`
- `ChatServicing`

This makes the app easier to test and change.

## Project Structure

```text
FlashChatIOS
├── App
│   ├── AppCoordinator.swift
│   ├── Core
│   └── Modules
│       ├── Welcome
│       │   ├── WelcomeViewController.swift
│       │   ├── WelcomePresenter.swift
│       │   └── WelcomeViewProtocol.swift
│       │
│       ├── Login
│       │   ├── LoginViewController.swift
│       │   ├── LoginPresenter.swift
│       │   └── LoginViewProtocol.swift
│       │
│       ├── Register
│       │   ├── RegisterViewController.swift
│       │   ├── RegisterPresenter.swift
│       │   └── RegisterViewProtocol.swift
│       │
│       └── Chat
│           ├── ChatViewController.swift
│           ├── ChatPresenter.swift
│           └── ChatViewProtocol.swift
│
├── DI
│   └── DependencyContainer.swift
│
├── Models
│   └── Message.swift
│
├── Services
│   ├── AuthServicing.swift
│   ├── AuthService.swift
│   ├── ChatServicing.swift
│   └── ChatService.swift
│
├── Views
│   └── MessageCell.swift
│
└── SupportingFiles
    └── Constants.swift
```

## Programmatic UI

The app does not use Storyboard or XIB for main screens.

UI is built with UIKit and native Auto Layout.

Removed from the main flow:

- Storyboard navigation
- IBOutlet
- IBAction
- XIB message cell

## Main Screens

### Welcome

Start screen with navigation to login and registration.

### Login

Login screen with email and password validation.

### Register

Registration screen with email and password validation.

### Chat

Chat screen with realtime messages from Firestore.

Messages are displayed with custom `MessageCell`.

## Dependency Injection

App services are created in `DependencyContainer`.

```swift
final class DependencyContainer {

    let authService: AuthServicing
    let chatService: ChatServicing

    init() {
        self.authService = AuthService()
        self.chatService = ChatService()
    }
}
```

`AppCoordinator` receives the container and passes services into presenters.

## Testing

The project contains test doubles for services:

- `MockAuthService`
- `MockChatService`

These mocks can be used for testing presenters without Firebase.

## Firebase Setup

The real Firebase config file is not included in the repository.

Add your own file:

```text
GoogleService-Info.plist
```

Use the example file as a reference:

```text
GoogleService-Info.example.plist
```

## Notes

This project is focused on clean UIKit basics:

- screen layout from code
- simple MVP
- navigation through Coordinator
- Firebase behind service protocols
- small testable components
