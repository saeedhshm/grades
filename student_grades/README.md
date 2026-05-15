# Student Grades Calculator

A bilingual Flutter mobile app for calculating student grades across 5 categories over a 12-week period. Supports English and Arabic languages with RTL layout.

## Features

- **5 Categories**: Homework, Activities, Math, Science, English
- **12 Weeks**: Each category has one score per week (60 total input fields)
- **Bilingual Support**: English/Arabic language toggle with RTL layout
- **Calculation Logic**: 
  - Category Average = (Week1 + Week2 + ... + Week12) ÷ 12
  - Final Score = Sum of all category averages
- **User Interface**: 
  - Single scrollable page with Material Design 3
  - Color-coded categories with legend
  - Results card with individual averages and final score
  - Input validation and error handling

## Screenshots

*Coming soon*

## Prerequisites

- Flutter SDK 3.0 or higher
- Dart SDK 3.10.3 or higher
- Android Studio / Xcode (for mobile development)
- Git

## Installation

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd student_grades
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Generate localization files**
   ```bash
   flutter gen-l10n
   ```

## Running the App

### Development Mode

```bash
flutter run
```

### Build for Android

```bash
# Debug build
flutter build apk --debug

# Release build
flutter build apk --release
```

### Build for iOS

```bash
# Debug build
flutter build ios --debug

# Release build
flutter build ios --release
```

### Build for Web

```bash
flutter build web
```

## Project Structure

```
student_grades/
├── lib/
│   ├── l10n/                    # Localization files
│   │   ├── app_en.arb           # English translations
│   │   ├── app_ar.arb           # Arabic translations
│   │   └── app_localizations.dart # Generated localization delegate
│   ├── models/                  # Data models
│   │   ├── category.dart        # Category enum with colors
│   │   └── student_scores.dart  # Student scores data structure
│   ├── screens/                 # UI screens
│   │   └── grades_calculator_screen.dart # Main calculator screen
│   ├── widgets/                 # Reusable widgets
│   │   ├── results_card.dart    # Results display widget
│   │   └── week_scores_card.dart # Weekly scores input widget
│   └── main.dart                # App entry point
├── android/                     # Android-specific configuration
├── ios/                        # iOS-specific configuration
├── pubspec.yaml                # Flutter dependencies
├── l10n.yaml                   # Localization configuration
└── README.md                   # This file
```

## Localization

The app supports English and Arabic languages. Language files are located in `lib/l10n/`:

- `app_en.arb` - English translations
- `app_ar.arb` - Arabic translations

To add a new language:
1. Create a new ARB file (e.g., `app_es.arb` for Spanish)
2. Add translations following the existing format
3. Update `supportedLocales` in `main.dart`
4. Run `flutter gen-l10n` to generate new localization files

## Architecture

### Data Models

**Category Enum**: Defines the 5 score categories with localized names and colors

**StudentScores**: Main data structure that:
- Stores student name and all 60 scores
- Calculates category averages
- Computes final score
- Validates input completeness

### State Management

Uses Flutter's built-in `StatefulWidget` for:
- Score input management
- Language switching
- Results display
- Form validation

### Widget Architecture

- **GradesCalculatorScreen**: Main screen with form and results
- **WeekScoresCard**: Reusable weekly score input card
- **ResultsCard**: Results display with gradient background

## Configuration

### Android

The Android configuration uses Kotlin and modern Gradle setup. Key files:
- `android/app/build.gradle.kts` - Build configuration
- `android/app/src/main/AndroidManifest.xml` - App manifest

### iOS

The iOS configuration supports multiple orientations and includes:
- `ios/Runner/Info.plist` - App configuration
- Portrait and landscape support
- iPad compatibility

## Testing

Run the test suite:

```bash
flutter test
```

## Troubleshooting

### Common Issues

1. **Localization files not found**
   - Run `flutter gen-l10n` to generate localization files
   - Ensure `l10n.yaml` is present in the project root

2. **Build failures**
   - Run `flutter clean` then `flutter pub get`
   - Check Flutter SDK version compatibility

3. **Language toggle not working**
   - Verify `supportedLocales` in `main.dart`
   - Check ARB files for proper formatting

### Performance

- The app uses lazy loading for widgets
- Input validation prevents unnecessary rebuilds
- Results are only calculated when all fields are complete

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Add tests if applicable
5. Submit a pull request

## License

This project is open source and available under the [MIT License](LICENSE).

## Support

For issues and questions:
- Create an issue in the repository
- Check existing issues for solutions
- Review the troubleshooting section above

## Changelog

### v1.0.0
- Initial release
- Bilingual support (English/Arabic)
- 5 categories with 12 weeks each
- Material Design 3 UI
- Input validation
- Results calculation and display