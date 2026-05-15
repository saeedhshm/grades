import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:student_grades/providers/category_provider.dart';
import 'package:student_grades/screens/home_screen.dart';
import '../helpers/test_app.dart';
import '../helpers/test_fixtures.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  testWidgets('shows categories when available', (tester) async {
    final categories = [
      buildCategory(id: '1', name: 'Math', arabicName: 'Math AR'),
      buildCategory(id: '2', name: 'Science', arabicName: 'Science AR'),
    ];
    setMockPrefsForCategories(useCustom: true, categories: categories);

    await tester.pumpWidget(
      buildTestApp(
        child: ChangeNotifierProvider(
          create: (_) => CategoryProvider(),
          child: const HomeScreen(),
        ),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.byType(ListTile), findsNWidgets(2));
    expect(find.text('Math'), findsOneWidget);
    expect(find.text('Science'), findsOneWidget);
    expect(find.byIcon(Icons.edit), findsWidgets);
    expect(find.byIcon(Icons.delete), findsWidgets);
  });

  testWidgets('shows empty state when no categories', (tester) async {
    setMockPrefsForCategories(useCustom: false, categories: []);

    await tester.pumpWidget(
      buildTestApp(
        child: ChangeNotifierProvider(
          create: (_) => CategoryProvider(),
          child: const HomeScreen(),
        ),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.byType(ListView), findsNothing);
    expect(find.byType(ListTile), findsNothing);
  });
}
