# 📍 Flutter Location Tracking App (Hiring Assignment)

A production-style Flutter application that tracks user location in real time using foreground and background services, persists location history locally, and displays it in a clean UI using MVVM architecture.

---

## 🚀 Features

### 📍 Location Tracking

- Real-time foreground location tracking
- Background location tracking using Android foreground service
- Distance-based filtering to avoid noisy GPS updates

### 💾 Data Persistence

- Local storage using Hive database
- Stores latitude, longitude, and timestamp
- Efficient write optimization (only significant movement saved)

### 🔔 Background Service

- Runs location tracking in background
- Persistent foreground notification
- Handles service start/stop cleanly

### 📊 History Management

- Real-time location history updates
- Timestamped entries
- Reactive UI using Provider + ChangeNotifier

### 🧩 Architecture

- MVVM (Model–View–ViewModel)
- Clean separation of:
  - UI layer
  - Business logic (VM)
  - Services (Location, Storage, Background)

---

## 🛠 Tech Stack

- Flutter
- Dart
- Provider (State Management)
- Hive (Local Storage)
- Geolocator
- Flutter Background Service

---

## 📱 App Flow

1. User grants location permission
2. App fetches current location
3. User starts tracking
4. Background service begins location updates
5. Locations are filtered using distance threshold
6. Data is stored locally in Hive
7. History screen displays real-time updates

---

## 🧠 Key Design Decisions

### 📌 Distance Filtering

To prevent excessive storage writes and GPS noise, location updates are only saved when the user moves beyond a defined threshold (10 meters).

### 📌 Background Architecture

Background tracking is handled using a foreground service to ensure stability on Android.

### 📌 MVVM Pattern

Business logic is separated from UI using ViewModels and services for better scalability and maintainability.

## 🔐 Permissions

The application requires the following permissions:

### Android

- ACCESS_FINE_LOCATION
- ACCESS_COARSE_LOCATION
- ACCESS_BACKGROUND_LOCATION
- FOREGROUND_SERVICE
- POST_NOTIFICATIONS

### iOS

- Location When In Use
- Location Always & When In Use

## ⚠️ Known Limitations

- Background tracking behavior may vary across Android OEMs due to battery optimization policies.
- Persistent foreground notifications may behave differently depending on emulator/device configuration.

## 👨‍💻 Author

Muhammad Sohail
Flutter Developer focused on scalable mobile applications, clean architecture, and real-time systems.

## 🌐 Portfolio

Here is my portfolio built in Flutter as well:

<https://sohailokzz-flutter.vercel.app/>

---

## 📦 Installation

```bash
flutter pub get
flutter run
