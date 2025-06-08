# 🎯 QuizMaster Pro

<div align="center">

![Flutter](https://img.shields.io/badge/Flutter-%2302569B.svg?style=for-the-badge&logo=Flutter&logoColor=white)
![Firebase](https://img.shields.io/badge/Firebase-%23039BE5.svg?style=for-the-badge&logo=firebase)
![Dart](https://img.shields.io/badge/dart-%230175C2.svg?style=for-the-badge&logo=dart&logoColor=white)

</div>

## 📱 About The Project

QuizMaster Pro is a modern, feature-rich quiz application built with Flutter and Firebase. It offers an engaging and interactive quiz experience with real-time feedback, sound effects, and a beautiful user interface.

## ✨ Features

- 🎮 Interactive quiz interface
- 🔐 User authentication with Firebase
- 🎵 Sound effects for correct/incorrect answers
- ⏱️ Timer functionality
- 🎉 Celebration effects
- 🌐 Multi-language support
- 💾 Local data persistence
- 📊 Score tracking
- 📱 Responsive design

## 🛠️ Built With

- [Flutter](https://flutter.dev/) - UI Framework
- [Firebase](https://firebase.google.com/) - Backend & Authentication
- [Riverpod](https://riverpod.dev/) - State Management
- [Google Fonts](https://fonts.google.com/) - Typography
- [Shared Preferences](https://pub.dev/packages/shared_preferences) - Local Storage
- [Audio Players](https://pub.dev/packages/audioplayers) - Sound Effects
- [Confetti](https://pub.dev/packages/confetti) - Celebration Effects

## 🚀 Getting Started

### Prerequisites

- Flutter SDK (^3.6.2)
- Dart SDK
- Firebase account
- Android Studio / VS Code

### Installation

1. Clone the repository
```bash
git clone https://github.com/YessineELEUCHI/QuizMaster-Pro.git
```

2. Install dependencies
```bash
flutter pub get
```

3. Configure Firebase
   - Create a new Firebase project
   - Add your Android/iOS app to the Firebase project
   - Download and add the configuration files
   - Enable Authentication and Firestore

4. Run the app
```bash
flutter run
```

## 📁 Project Structure

```
lib/
├── controller/    # Business logic
├── l10n/         # Localization files
├── model/        # Data models
├── screens/      # UI screens
├── service/      # API services
├── widget/       # Reusable widgets
└── main.dart     # Entry point
```

## 🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## 📝 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 👨‍💻 Author

**Yessine ELEUCHI**
- GitHub: [@YessineELEUCHI](https://github.com/YessineELEUCHI)

## 🙏 Acknowledgments

- Flutter team for the amazing framework
- Firebase for the backend services
- All the package maintainers who made this project possible

---

<div align="center">
Made with ❤️ by Yessine ELEUCHI
</div>

# 📱 Flutter Quiz App

A modern, multilingual quiz app built with **Flutter**, using **Firebase Authentication**, **Firestore**, and **Push Notifications**. It supports **English**, **Français**, and **العربية**. Users can play quizzes, track their score history, and get notified about updates and reminders.

---

## 🚀 Features

- 🧠 Play quizzes by category, difficulty, and number of questions
- 🌍 Supports **English, French, Arabic** (with RTL support)
- 🔐 **Firebase Authentication** (Email & Anonymous)
- 📊 **Score history** saved to **Firestore**
- 🕹️ Theme switcher (Light / Dark Mode)
- 🔔 **Local & Push Notifications** using `flutter_local_notifications` and `firebase_messaging`

---

## 📦 Tech Stack

| Tool | Usage |
|------|-------|
| Flutter | Frontend Framework |
| Firebase Auth | User Authentication |
| Cloud Firestore | Storing scores |
| FCM + flutter_local_notifications | Push & Local notifications |
| `intl` | Translations & localization |
| `provider` | State Management |

---

## 📸 Screenshots

| Light Mode | Dark Mode | scores History                |
|------------|-----------|-------------------------------|
| ![light](screenshots/light.png) | ![dark](screenshots/dark.png) | ![lang](screenshots/lang.png) |

---

## 🧪 Setup Instructions

### 1. 🔧 Prerequisites

- Flutter 3.x
- Firebase project set up with Firestore, Auth, and FCM enabled

### 2. 🔥 Firebase Configuration

- Create a Firebase project at https://console.firebase.google.com
- Enable:
    - Authentication (Email/Password or Anonymous)
    - Firestore Database
    - Cloud Messaging
- Download `google-services.json` and place it in `android/app/`

### 3. ⚙️ Android Configuration

In `android/app/build.gradle`:

```gradle
compileOptions {
    sourceCompatibility JavaVersion.VERSION_1_8
    targetCompatibility JavaVersion.VERSION_1_8
    coreLibraryDesugaringEnabled true
}

dependencies {
    implementation "com.android.tools:desugar_jdk_libs:2.0.3"
}
