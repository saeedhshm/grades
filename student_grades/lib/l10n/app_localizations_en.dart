// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Student Grades Calculator';

  @override
  String get studentName => 'Student Name';

  @override
  String get studentNameHint => 'Enter student name';

  @override
  String get week => 'Week';

  @override
  String get homework => 'Homework';

  @override
  String get activities => 'Activities';

  @override
  String get math => 'Math';

  @override
  String get science => 'Science';

  @override
  String get english => 'English';

  @override
  String get calculate => 'Calculate';

  @override
  String get clear => 'Clear';

  @override
  String get results => 'Results';

  @override
  String categoryAverage(Object category) {
    return '$category Average';
  }

  @override
  String get finalScore => 'Final Score';

  @override
  String get validationRequired => 'Please fill all fields';

  @override
  String get validationNameRequired => 'Student name is required';

  @override
  String get languageToggle => 'AR';
}
