# AIopoly

This project demonstrates how to leverage Vertex AI's text generation capabilities within a Flutter app to create unique Monopoly properties based on user-provided themes. 

This Flutter app is meant to work in conjunction with the Functions repo, which actually makes the call to the Vertex APIs. https://github.com/cjwhitsitt/aiopoly-functions

## Key Features:

- **Creative Content Generation:** Utilizes Vertex AI's Gemini Pro model to generate original Monopoly property names and descriptions tailored to specific themes. 
- **Serverless Backend:** Employs Firebase Functions to streamline the interaction between the Flutter app and Vertex AI.
- **Theme-Based Customization:** Allows users to input their desired themes, resulting in personalized game experiences.
- **Visual Organization:** Presents the generated properties in a clear and user-friendly format, categorized by color groups.

## Technologies Used:

- **Flutter:** Multi-platform mobile app development framework for building natively compiled apps for iOS, Android, web, and desktop from a single codebase.
- **Firebase Functions:** A serverless platform for building and hosting backend services with automatic scaling and high availability.
- **Vertex AI:** A Google Cloud platform offering a suite of machine learning services, including text generation capabilities with various models.

## Getting Started:

1. **Setup the Functions project**

   https://github.com/cjwhitsitt/aiopoly-functions

   This will also setup the Google Cloud and Firebase project needed for this sample.

3. **Install Flutterfire**
   ```bash
   dart pub global activate flutterfire_cli
   ```

4. **Clone the repository:**
   ```bash
   git clone https://github.com/cjwhitsitt/aiopoly-flutter
   cd aiopoly-flutter
   ```

5. **Configure Firebase**
   ```bash
   flutterfire configure
   # Choose your Firebase project then your desired platforms
   ```

6. **Connect to Functions**

   If using deployed Functions and not a local emulator, comment out this line:
   ```dart
   Future<void> main() async {
     WidgetsFlutterBinding.ensureInitialized();

     await Firebase.initializeApp(
       options: DefaultFirebaseOptions.currentPlatform,
     );
     Service.useEmulators(); // comment out this line if using deployed Functions

     runApp(const MyApp());
   }
   ```

8. **Run the app:**
   ```bash
   flutter run
   ```

## Usage:

1. Enter a theme of your choice in the app's input field.
2. The app will send the theme to the Firebase Function.
3. The Function will call the Gemini Pro model in Vertex AI to generate properties based on the theme.
4. The generated properties will be displayed in the app, organized by color groups.
