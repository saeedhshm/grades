import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:student_grades/main.dart';
import 'package:student_grades/providers/category_provider.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  testWidgets('StudentGradesApp builds with default locale', (tester) async {
    await tester.pumpWidget(
      ChangeNotifierProvider(
        create: (_) => CategoryProvider(),
        child: const StudentGradesApp(),
      ),
    );

    final app = tester.widget<MaterialApp>(find.byType(MaterialApp));
    expect(app.locale, const Locale('ar'));
  });
}
