# Water Tracker

Water Tracker is a Flutter Android application designed to help groups seamlessly track shared water bottle expenses. It features payment rotation and 'paying on behalf' logic, making it easy to manage shared costs among friends, family, or colleagues.

## Features

*   **Group Management**: Create multiple groups and manage members within each group.
*   **Payment Rotation**: Automatically tracks whose turn it is to pay next.
*   **Pay on Behalf**: Allows a member to pay for someone else's turn, creating an internal "debt" that is automatically resolved in future rotations.
*   **Payment Summary**: View a history of payments grouped by month, and see how much each member has contributed.
*   **Home Screen Widget**: A native Android Home Screen Widget to quickly view whose turn it is and mark payments without opening the app.

## Architecture & Tech Stack

*   **Flutter**: Cross-platform UI framework (currently focusing on Android).
*   **Provider**: State management solution for managing application state.
*   **sqflite**: Local SQLite database storage for persisting groups, members, payments, and debts.
*   **home_widget**: Integration for the native Android Home Screen Widget.

## Getting Started

### Prerequisites

*   Flutter SDK (see [Flutter installation guide](https://docs.flutter.dev/get-started/install))
*   Android Studio or another suitable IDE with the Flutter plugin installed.

### Installation

1.  Clone the repository:
    ```bash
    git clone https://github.com/yourusername/water_tracker.git
    cd water_tracker
    ```
2.  Install dependencies:
    ```bash
    flutter pub get
    ```

### Running the App

*   **Debug Mode (Android)**: Use the following command to build and run the app in debug mode on a connected Android device or emulator.
    ```bash
    flutter run
    ```
    Or to just build the APK:
    ```bash
    flutter build apk --debug
    ```

### Testing

Run the test suite using:

```bash
flutter test
```

### Static Analysis

Run static code analysis to ensure code quality:

```bash
flutter analyze
```

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.
