import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:student_grades/models/category_manager.dart';
import 'package:student_grades/providers/category_provider.dart';
import 'package:student_grades/screens/grades_calculator_screen.dart';
import 'package:student_grades/widgets/results_card.dart';
import 'package:student_grades/widgets/week_scores_card.dart';
import '../helpers/test_app.dart';
import '../helpers/test_fixtures.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  Future<CategoryProvider> buildLoadedProvider(List<CustomCategory> categories) async {
    setMockPrefsForCategories(useCustom: true, categories: categories);
    final provider = CategoryProvider();
    while (provider.isLoading) {
      await Future<void>.delayed(Duration.zero);
    }
    return provider;
  }

  testWidgets('renders 12 week cards', (tester) async {
    final categories = [buildCategory(id: '1', name: 'Math', arabicName: 'Math AR')];
    final provider = await buildLoadedProvider(categories);

    await tester.pumpWidget(
      buildTestApp(
        locale: const Locale('en'),
        child: ChangeNotifierProvider.value(
          value: provider,
          child: const GradesCalculatorScreen(),
        ),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.byType(WeekScoresCard), findsNWidgets(12));
  });

  testWidgets('shows validation error when incomplete', (tester) async {
    final categories = [buildCategory(id: '1', name: 'Math', arabicName: 'Math AR')];
    final provider = await buildLoadedProvider(categories);

    await tester.pumpWidget(
      buildTestApp(
        locale: const Locale('en'),
        child: ChangeNotifierProvider.value(
          value: provider,
          child: const GradesCalculatorScreen(),
        ),
      ),
    );

    await tester.pumpAndSettle();

    final calculateFinder = find.text('Calculate');
    await tester.scrollUntilVisible(
      calculateFinder,
      300,
      scrollable: find.byType(SingleChildScrollView),
    );
    await tester.tap(calculateFinder);
    await tester.pumpAndSettle();

    expect(find.text('Please fill all fields'), findsOneWidget);
  });

  testWidgets('shows results after all fields are filled', (tester) async {
    final categories = [buildCategory(id: '1', name: 'Math', arabicName: 'Math AR')];
    final provider = await buildLoadedProvider(categories);

    await tester.pumpWidget(
      buildTestApp(
        locale: const Locale('en'),
        child: ChangeNotifierProvider.value(
          value: provider,
          child: const GradesCalculatorScreen(),
        ),
      ),
    );

    await tester.pumpAndSettle();

    final fields = tester.widgetList<TextFormField>(find.byType(TextFormField)).toList();
    expect(fields.length, 12);

    for (final field in fields) {
      field.controller?.text = '90';
      field.onChanged?.call('90');
    }
    await tester.pump();

    final calculateFinder = find.text('Calculate');
    await tester.scrollUntilVisible(
      calculateFinder,
      300,
      scrollable: find.byType(SingleChildScrollView),
    );
    await tester.tap(calculateFinder);
    await tester.pumpAndSettle();

    expect(find.byType(ResultsCard), findsOneWidget);
  });
}
