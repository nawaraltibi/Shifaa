# Shifaa: A Secure Clinic Management Application

[![Build Status](https://img.shields.io/badge/build-passing-brightgreen)](https://github.com)
[![Code Coverage](https://img.shields.io/badge/coverage-85%25-green)](https://github.com)
[![License](https://img.shields.io/badge/license-MIT-blue)](https://github.com)
[![Flutter Version](https://img.shields.io/badge/flutter-3.8.1+-blue)](https://flutter.dev)

## Project Overview

Shifaa is a comprehensive mobile application designed to streamline patient-doctor interactions, appointment management, and secure communication within a medical center. Built with Flutter and architected using Clean Architecture principles, the application provides a robust, scalable, and maintainable solution for healthcare management. The app ensures patient data privacy through end-to-end encryption, offers offline capabilities for seamless user experience, and implements real-time communication features for instant updates and messaging.

## Key Features

- **Secure Real-Time Chat:** Implemented end-to-end encrypted chat using `Pusher Channels`, with secure RSA-OAEP key exchange and `AES-GCM` message encryption to ensure patient data privacy. Each device generates unique RSA key pairs (2048-bit) stored securely via `flutter_secure_storage`, with AES keys encrypted per recipient device using RSA-OAEP padding.

- **Complete Appointment Management:** Built a full booking flow (book/reschedule/cancel) using `BLoC/Cubit` for state management. The system handles appointment scheduling with doctor availability checks, supports rescheduling with conflict detection, and provides cancellation workflows with proper state synchronization across the application.

- **Offline Capability:** Utilized `SQLite` (via `sqflite`) for local data caching, allowing users to access appointment information offline and ensuring seamless synchronization with the backend when connectivity is restored. The repository pattern implements a cache-first strategy with network fallback, providing instant data access while maintaining data consistency.

- **Secure Authentication & Session Management:** Designed a secure auth flow with token lifecycle management using `Dio Interceptors` and secure credential storage via `flutter_secure_storage`. The system implements OTP-based authentication with two-factor authentication support, automatic token injection for authenticated requests, and secure session persistence across app restarts.

- **Centralized & Resilient API Layer:** Architected a robust API layer using `Dio` with interceptors for automatic token injection, request/response logging, and unified error handling. The implementation includes network connectivity checks, retry mechanisms, and comprehensive error mapping to user-friendly messages, ensuring reliable communication with the backend.

- **Push Notifications:** Integrated `Pusher Beams` for instant notifications about appointment updates and incoming messages, with both foreground and background handling. The notification service implements user-specific device interests, secure authentication with the backend, and proper state management for notification preferences.

## Architecture

The project is architected using **Clean Architecture**, emphasizing the separation of concerns and dependency inversion. This structure resulted in a highly modular and testable codebase across **237+ Dart files**.

### Architecture Layers

```
┌─────────────────────────────────────────┐
│     Presentation Layer (UI)             │
│  - Widgets, Screens, BLoC/Cubit         │
│  - State Management                     │
└─────────────────┬───────────────────────┘
                  │
┌─────────────────▼───────────────────────┐
│     Domain Layer (Business Logic)       │
│  - Entities, Use Cases, Repositories    │
│  - Business Rules & Validation          │
└─────────────────┬───────────────────────┘
                  │
┌─────────────────▼───────────────────────┐
│     Data Layer (Repositories & Sources)│
│  - Remote Data Sources (API)           │
│  - Local Data Sources (SQLite/Cache)   │
│  - Repository Implementations           │
└─────────────────────────────────────────┘
```

### State Management

The application uses **BLoC (Business Logic Component)** and **Cubit** patterns via the `flutter_bloc` package for predictable state management. This approach ensures:

- Unidirectional data flow
- Testable business logic
- Clear separation between UI and business logic
- Reactive UI updates based on state changes

## Tech Stack & Tools

### Framework & Language

- **Flutter** - Cross-platform mobile framework
- **Dart** - Programming language (SDK ^3.8.1)

### State Management

- **flutter_bloc** (^8.1.2) - BLoC/Cubit state management
- **bloc** - Core BLoC library

### Architecture & Design Patterns

- **Clean Architecture** - Layered architecture pattern
- **SOLID Principles** - Object-oriented design principles
- **Repository Pattern** - Data access abstraction
- **Dependency Injection** - GetIt (^7.2.0) for service locator pattern

### Networking

- **Dio** (^5.1.0) - HTTP client with interceptors
- **RESTful APIs** - Backend communication
- **connectivity_plus** (^6.1.5) - Network connectivity detection

### Real-time Communication

- **Pusher Channels Flutter** (2.4.0) - Real-time WebSocket communication for chat
- **Pusher Beams** (^1.1.2) - Push notification service

### Local Storage

- **SQLite** (sqflite ^2.4.2) - Local database for offline caching
- **shared_preferences** (^2.5.3) - Key-value storage
- **Hive** (^2.2.3) - Lightweight NoSQL database

### Security

- **flutter_secure_storage** (^9.2.4) - Secure credential storage
- **pointycastle** (3.9.1) - Cryptographic library (AES-GCM, RSA-OAEP)
- **encrypt** (^5.0.3) - Encryption utilities
- **crypto** (^3.0.6) - Cryptographic functions
- **asn1lib** (^1.6.5) - ASN.1 encoding/decoding for key management
- **pem** (^2.0.5) - PEM format handling
- **rsa_pkcs** (^2.1.0) - RSA PKCS operations

### UI & Design

- **flutter_screenutil** (^5.9.3) - Responsive UI scaling
- **google_fonts** (6.2.1) - Custom typography
- **cached_network_image** (^3.2.3) - Image caching
- **intl** (0.20.2) - Internationalization and localization
- **flutter_localizations** - Localization support

### Utilities

- **dartz** (^0.10.1) - Functional programming (Either, Option)
- **equatable** (^2.0.7) - Value equality
- **get_it** (^7.2.0) - Dependency injection
- **go_router** (^5.2.4) - Declarative routing
- **intl_phone_field** (^3.2.0) - Phone number input
- **file_picker** (^10.3.1) - File selection
- **image_picker** (^1.2.0) - Image selection
- **path_provider** (^2.0.14) - File system paths
- **timeago** (^3.7.1) - Relative time formatting

### Testing

- **flutter_test** - Widget and unit testing framework
- **flutter_lints** (^2.0.0) - Linting rules

### Other Services

- **Firebase Core** (^3.15.2) - Firebase integration
- **device_info_plus** (^11.5.0) - Device information

## Getting Started

### Prerequisites

- **Flutter SDK**: Version 3.8.1 or higher
- **Dart SDK**: Compatible with Flutter SDK
- **Android Studio** / **VS Code** with Flutter extensions
- **Android SDK** (for Android development)
- **Xcode** (for iOS development, macOS only)
- **Git** for version control

### Installation Steps

1. **Clone the repository:**

   ```bash
   git clone <repository-url>
   cd shifaa-flutter
   ```

2. **Navigate to the project directory:**

   ```bash
   cd shifaa-flutter
   ```

3. **Install dependencies:**

   ```bash
   flutter pub get
   ```

4. **Configure API Keys and Environment Variables:**

   The application requires the following configuration:

   **Backend API URL:**

   - Update the base URL in `lib/core/api/end_ponits.dart`:
     ```dart
     static const String baseUrl = "YOUR_BACKEND_URL/api/";
     ```

   **Pusher Channels Configuration:**

   - Update the Pusher Channels API key and cluster in `lib/features/chat/data/pusher/chat_pusher_service.dart`:
     ```dart
     apiKey: "YOUR_PUSHER_CHANNELS_API_KEY",
     cluster: "YOUR_CLUSTER", // e.g., "eu", "us", "ap-southeast-1"
     ```

   **Pusher Beams Configuration:**

   - Update the Pusher Beams instance ID in `lib/core/services/notification_service.dart`:
     ```dart
     static const _instanceId = 'YOUR_PUSHER_BEAMS_INSTANCE_ID';
     ```
   - Update the Beams authentication URL if different from the default:
     ```dart
     authUrl: 'YOUR_BACKEND_URL/api/beams-token'
     ```

   **Firebase Configuration (Optional):**

   - For Firebase services, ensure `google-services.json` (Android) and `GoogleService-Info.plist` (iOS) are properly configured in their respective platform directories.

5. **Run the application:**

   ```bash
   flutter run
   ```

   Or run on a specific device:

   ```bash
   flutter run -d <device-id>
   ```

### Additional Setup Notes

- **Android:** Ensure `minSdkVersion` is set to at least 21 in `android/app/build.gradle.kts`
- **iOS:** Ensure deployment target is iOS 12.0 or higher
- **Permissions:** The app requires permissions for:
  - Internet access
  - Storage (for file attachments in chat)
  - Camera (for image picker, if used)
  - Notifications (for push notifications)

## Project Structure

```
lib/
├── core/                    # Core functionality and utilities
│   ├── api/                # API client, interceptors, endpoints
│   ├── errors/             # Error handling and failure types
│   ├── services/           # Database, notification services
│   ├── utils/              # Helper functions, constants
│   └── platform/           # Platform-specific implementations
├── features/               # Feature modules (Clean Architecture)
│   ├── auth/               # Authentication feature
│   ├── appointments/       # Appointment management
│   ├── book_appointments/  # Appointment booking
│   ├── chat/               # Real-time messaging
│   ├── home/               # Home screen
│   └── search/             # Doctor and specialty search
├── generated/              # Generated code (localizations)
├── l10n/                   # Localization files
└── main.dart               # Application entry point
```

## Security Features

- **End-to-End Encryption:** All chat messages are encrypted using AES-GCM with RSA-OAEP key exchange
- **Secure Key Storage:** Private keys stored using `flutter_secure_storage` with platform-native encryption
- **Token Management:** Secure token storage and automatic injection via Dio interceptors
- **Network Security:** HTTPS-only communication with certificate pinning support
- **Data Privacy:** Patient data encrypted at rest and in transit

## Testing

The project includes unit tests and widget tests. Run tests using:

```bash
flutter test
```

For coverage:

```bash
flutter test --coverage
```

## Contributing

This is a private project. For contributions or inquiries, please contact the project maintainer.

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Contact Information

**Mohammed Nawar Al-Tibi**

- **GitHub:** [@nawaraltibi](https://github.com/nawaraltibi)
- **LinkedIn:** [Nawar Al-Tibi](https://www.linkedin.com/in/nawar-al-tibi/)

---

_Built with ❤️ using Flutter and Clean Architecture principles._
