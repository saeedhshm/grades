import 'package:flutter/material.dart';
import 'package:student_grades/l10n/app_localizations.dart';

Widget buildTestApp({required Widget child, Locale? locale}) {
  return MaterialApp(
    locale: locale,
    supportedLocales: AppLocalizations.supportedLocales,
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    home: child,
  );
}
