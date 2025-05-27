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

| Light Mode | Dark Mode | Language Switch |
|------------|-----------|-----------------|
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
