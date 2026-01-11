# StudyMatch

StudyMatch is a Flutter application designed to help students find compatible study partners based on interests, subjects, and availability. It provides an intuitive swipe-based interface to discover matches, view profiles, and start conversations.

## Key Features

- Swipe interface to like or pass on potential study partners
- Student profiles with avatar, subjects, interests, and availability
- Match management and basic messaging (demo/stubbed UI)
- Local sample data in `assets/data/students.json` for quick testing
- Theming and responsive layout for mobile platforms (Android/iOS)

## Project Structure (high level)

- `lib/` — Application source code (UI, state management, features)
- `assets/` — Images and sample data (avatars, `students.json`)
- `android/`, `ios/`, `web/`, `windows/`, `linux/`, `macos/` — Platform folders
- `test/` — Widget and unit tests

## Getting Started (run locally)

1. Ensure you have Flutter installed: https://docs.flutter.dev/get-started/install
2. From the project root, fetch packages:

```bash
flutter pub get
```

3. Run the app on a connected device or emulator:

```bash
flutter run
```

4. To run tests:

```bash
flutter test
```

## Notes for Developers

- Sample student data lives at `assets/data/students.json` and can be modified for testing.
- The main entry point is `lib/main.dart`.
- The app uses a lightweight local state approach; check `core/stores` and `app/` for theming and settings.

## Contributing

Contributions are welcome. Please open issues or pull requests with clear descriptions of changes. For large features, open an issue first to discuss the approach.

## License

This project does not include a license file. Add a `LICENSE` if you intend to publish or share under a specific license.

---

If you'd like, I can shorten this README, add badges, or include screenshots and run instructions for specific platforms. Tell me which you'd prefer.
