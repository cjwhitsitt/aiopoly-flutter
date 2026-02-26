# AIopoly Project Guidelines

This file contains strict instructions for future AI coding assistants working on the AIopoly project. All changes must adhere to these guidelines to ensure consistency, maintainability, and code quality.

## 1. Project Overview

AIopoly is a Flutter application that generates Monopoly property names and descriptions based on user-provided themes. It utilizes Google's Gemini API via Firebase Functions or direct calls for content generation.

## 2. Architecture

The project follows a simple, feature-based structure:

- `lib/data/`: Contains data models (`create_response.dart`, `property_group.dart`, `property.dart`) and the `Service` class (`service.dart`) for API interactions.
- `lib/routes/`: Contains screen implementations (`home_route.dart`, `result_route.dart`). Files are named with the suffix `_route.dart`.
- `lib/utils/`: Utility functions and constants (e.g., `constants.dart` for logging, `hex_color.dart` for color parsing).
- `lib/main.dart`: The application entry point and theme configuration.

## 3. State Management

- **Local State**: Use `setState` for managing local widget state (e.g., loading indicators, form validation).
- **Data Passing**: Pass data between screens using constructor arguments.
- **Future Features**: Incorporate `flutter_bloc` for managing complex state and business logic in new features.
- **Avoid Complexity**: For simple features, stick to `setState` and simple prop drilling.

## 4. Routing

- **Navigation**: Use `Navigator.of(context)` for navigation.
- **Route Definition**: Routes are defined as `StatefulWidget` or `StatelessWidget` classes in `lib/routes/`.
- **Pushing Routes**: Use `MaterialPageRoute` to push new screens onto the stack.
  ```dart
  Navigator.of(context).push(MaterialPageRoute(builder: (context) {
    return NextRoute(data: data);
  }));
  ```

## 5. Gemini API Integration

- **Service Class**: All API interactions must be encapsulated within the `Service` class in `lib/data/service.dart`.
- **Endpoints**: The `Service` class supports two endpoints:
    - `ServiceEndpoint.firebase`: Calls a Firebase Cloud Function named `create`.
    - `ServiceEndpoint.direct`: specific implementation using `firebase_ai` to call Gemini directly (`FirebaseAI.googleAI().generativeModel`).
- **Model Configuration**:
    - Model: `gemini-2.5-flash-lite`
    - Response MIME Type: `application/json`
    - Schema: Defined using `Schema` objects to ensure structured JSON output.
- **Data Models**: Use `CreateResponse`, `PropertyGroup`, and `Property` to parse and handle API responses.

## 6. UI & Styling

- **Material 3**: The app uses Material 3 (`useMaterial3: true` in `ThemeData`).
- **Components**: Use standard Flutter widgets:
    - `Scaffold`, `AppBar`, `Column`, `Row`, `ListView`, `Card`, `TextField`, `TextButton`, `CircularProgressIndicator`.
    - Use `AlertDialog.adaptive` for dialogs.
- **Styling**: Access colors via `Theme.of(context).colorScheme`.
    - Example: `backgroundColor: Theme.of(context).colorScheme.inversePrimary`

## 7. Error Handling

- **User Feedback**: Display user-friendly error messages using `AlertDialog`.
    - Catch errors in `onError` callbacks or `try-catch` blocks.
- **Logging**: Log errors to the console in debug mode using `kDebugMode` or the helper `dLog` in `lib/utils/constants.dart`.
- **Graceful Failure**: Ensure the UI remains responsive and provides a way to retry or dismiss the error.

## 8. Formatting & Linting

- **Linter**: Follow the rules defined in `analysis_options.yaml`, which includes `flutter_lints`.
- **Formatting**:
    - Use 2 spaces for indentation.
    - Use trailing commas in widget trees for better readability.
    - Ensure all code is formatted using `dart format`.
- **Imports**: Organize imports: Dart core, packages, then project files.

## 9. Testing

- **Widget Tests**: Maintain basic widget tests in `test/`.
- **Verification**: Before submitting changes, ensure the app compiles and runs without errors.
