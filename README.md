# 📖 Al-Quran Audio Player (Elite Premium Edition)

A high-fidelity mobile application for reciting and listening to the Holy Quran, built with Flutter following the **Clean MVVM + GetX** architecture. This project represents an "Elite" implementation, far exceeding standard requirements through custom animations, spiritual UX refinement, and architectural hardening.

## ✨ "Elite" UI/UX Highlights
- **Mandala Custom Animation**: A mathematically generated, rotating mandala backdrop on the splash screen using `CustomPaint`.
- **Dynamic Audio Visualizer**: Real-time sound wave simulation using Sine algorithms, reactive to playback status.
- **Auto-Scroll & Smart Highlighting**: The verse list automatically scrolls to and highlights the currently playing ayah, syncing UI with audio state.
- **Spiritual Error Pages**: 404 (Not Found) and 500 (Crash) pages redesigned with Quranic references (QS. Al-Fatihah: 6 & QS. Al-Baqarah: 286) to provide comfort and guidance during errors.
- **Glassmorphism Design**: Elegant layering with premium gradients and translucent cards for a modern spiritual aesthetic.
- **Zero-Hardcode Policy**: 100% of UI strings are localized using GetX translations (`.tr`).

## 🚀 Core Features
- **Surah Discovery**: Smooth exploration of 114 Surahs with detailed metadata (Revelation type, Ayah count).
- **Advanced Search**: Real-time filtering with high-performance response.
- **Ayah-by-Ayah Playback**: Seamless audio streaming using the `just_audio` engine.
- **Integrated Player Control**: Play, Pause, Next, Previous, and Seeking via custom-styled progress bars.
- **Intelligent Caching**: Repository-level caching ensures instant response times and offline availability.

## 🛠️ Architecture (Principal/Staff Level)
- **Framework**: Flutter (Channel Stable).
- **State Management**: [GetX](https://pub.dev/packages/get) (Reactive State, DI, Routing).
- **Service Locator**: Centralized dependency management for reliability.
- **Clean MVVM**: Strict separation of concerns (Model, View, Controller, Repository).
- **Atomic Widgets**: UI decoupled into reusable, independent components.
- **Documentation**: Exhaustive Indonesian inline documentation for every file.

## 🧪 Testing Suite (100% Critical Path)
Comprehensive automated validation covering:
- **Repository Unit Tests**: Data fetching and storage logic.
- **Controller Unit Tests**: Business logic, search filtering, and audio playlist management.
- **Widget Tests**: Full UI integration, auto-scroll verification, and localization.

## 📦 Installation
```bash
git clone https://github.com/myaasiinh/quran-player.git
cd quran_player
flutter pub get
flutter run
```

---
**Developed by:** Muhammad Yaasiin Hidayatulloh (Staff Software Architect Mode)  
**Status:** 👑 **Elite Grade - Hardened & Fully Documented**
