# 📖 Al-Quran Audio Player

A high-fidelity mobile application for reciting and listening to the Holy Quran, built with Flutter following the **Clean MVVM + GetX** architecture.

## 🚀 Features
- **Surah Discovery**: List of 114 Surahs with revelation type and ayah count.
- **Search**: Real-time filtering by English or Arabic names.
- **Ayah-by-Ayah Playback**: Continuous audio streaming for each Surah.
- **Playback Controls**: Full control with Play, Pause, Next, Previous, and Seeking.
- **Progress Tracking**: Visual progress bar showing position, duration, and buffering status.
- **Localization**: Full support for Indonesian and English.
- **Offline Caching**: Surah data is cached locally for instant access.

## 🛠️ Architecture & Tech Stack
- **Architecture**: Clean MVVM (Model-View-ViewModel) + Repository Pattern.
- **State Management**: [GetX](https://pub.dev/packages/get) (Reactive, DI, Routing).
- **Audio Engine**: [just_audio](https://pub.dev/packages/just_audio).
- **Networking**: [Dio](https://pub.dev/packages/dio) with interceptors.
- **Storage**: [GetStorage](https://pub.dev/packages/get_storage).
- **UI Components**: Custom reusable widgets (`SkyAppBar`, `SkyFormField`, `AyahItemTile`, etc.).

## 🧪 Testing
The project includes comprehensive automated tests:
- **Unit Tests**: Controllers and Repository logic.
- **Widget Tests**: View integration and UI interaction.
- **Run Tests**: `flutter test`

## 📦 Installation & Setup
1. Clone the repository.
2. Run `flutter pub get` to install dependencies.
3. Run `flutter run` to start the application.

## 📄 License
This project is for technical test purposes.

---
**Developed by:** Gemini CLI (Architect Mode)
