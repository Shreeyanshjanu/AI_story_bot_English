# StoraAI — AI Storytelling App

<p align="center">
  <img src="assets/images/your_icon.jpg" width="120" alt="StoraAI Logo" />
</p>

<p align="center">
  A beautifully crafted mobile app that generates and narrates personalized stories using AI.
  Built with Flutter and powered by Groq's LLaMA 3.3 model.
</p>

<p align="center">
  <img src="https://img.shields.io/badge/Flutter-3.x-blue?logo=flutter" />
  <img src="https://img.shields.io/badge/Firebase-Auth-orange?logo=firebase" />
  <img src="https://img.shields.io/badge/Groq-LLaMA3.3-purple" />
  <img src="https://img.shields.io/badge/Platform-Android%20%7C%20iOS-green" />
</p>

---

## Features

- **AI Story Generation** — Type any idea and get a unique, engaging story instantly using Groq's LLaMA 3.3 70B model
- **Text-to-Speech Narration** — Stories are read aloud automatically with real-time word highlighting
- **Beautiful Animations** — Lottie animations throughout the app including a cinematic loading screen
- **Firebase Authentication** — Secure email/password sign up and sign in
- **Side Drawer Menu** — Smooth animated side menu for navigation
- **Suggestion Chips** — Quick story ideas to get you started
- **Story Screen** — Clean reading UI with play/pause/replay controls and a shimmer progress bar

---

## Screenshots

| Login | Home | Generating | Story |
|-------|------|------------|-------|
| ![Login](screenshots/login.png) | ![Home](screenshots/home.png) | ![Generating](screenshots/generating.png) | ![Story](screenshots/story.png) |

> Add your screenshots in a `/screenshots` folder in the root of the project.

---

## Tech Stack

| Technology | Usage |
|------------|-------|
| Flutter | Cross-platform mobile framework |
| Firebase Auth | User authentication |
| Groq API (LLaMA 3.3 70B) | AI story generation |
| Flutter TTS | Text-to-speech narration |
| Lottie | Animations |
| flutter_dotenv | Environment variable management |

---

## Project Structure
```
lib/
├── authentication/
│   ├── login_screen.dart       # Sign in screen
│   └── signup_screen.dart      # Sign up screen
├── screens/
│   ├── home_screen.dart        # Main home screen
│   ├── story_screen.dart       # Story reading + TTS screen
│   └── generating_screen.dart  # Loading animation screen
├── services/
│   ├── groq_service.dart       # Groq API integration
│   └── tts_service.dart        # Text-to-speech service
├── widgets/
│   └── side_drawer.dart        # Animated side menu
└── utils/
    └── glass_snackbar.dart     # Custom glass-effect dialog
```

---

## Getting Started

### Prerequisites

- Flutter SDK 3.x
- A [Firebase](https://firebase.google.com) project with Authentication enabled
- A [Groq](https://console.groq.com) API key

### Installation

**1. Clone the repository**
```bash
git clone https://github.com/yourusername/StoraAI.git
cd StoraAI
```

**2. Install dependencies**
```bash
flutter pub get
```

**3. Set up environment variables**

Create a `.env` file in the root of the project:
```env
GROQ_API_KEY=your_groq_api_key_here
```

**4. Set up Firebase**

- Create a Firebase project at [console.firebase.google.com](https://console.firebase.google.com)
- Enable **Email/Password** authentication
- Run FlutterFire CLI to generate `firebase_options.dart`:
```bash
dart pub global activate flutterfire_cli
flutterfire configure
```

**5. Run the app**
```bash
flutter run
```

---

## Environment Variables

Create a `.env` file in the project root:
```env
GROQ_API_KEY=your_groq_api_key_here
```

Make sure `.env` is added to `.gitignore`:
```
.env
```

---

## Key Dependencies
```yaml
dependencies:
  firebase_core: latest
  firebase_auth: latest
  flutter_tts: latest
  lottie: latest
  http: latest
  flutter_dotenv: latest
```

---

## How It Works
```
User types a story idea
        ↓
Groq LLaMA 3.3 generates a 500–800 word story
        ↓
Story Screen opens with the full text
        ↓
Flutter TTS reads it aloud
        ↓
Current word is highlighted in real time
```

---

## Contributing

Pull requests are welcome. For major changes, please open an issue first to discuss what you would like to change.

---

## License

This project is licensed under the MIT License — see the [LICENSE](LICENSE) file for details.

---

## Acknowledgements

- [Groq](https://groq.com) for the blazing fast LLaMA inference API
- [Firebase](https://firebase.google.com) for authentication
- [LottieFiles](https://lottiefiles.com) for the animations
- [Flutter](https://flutter.dev) for the framework

---

<p align="center">
  Made with ❤️ using Flutter
</p>
