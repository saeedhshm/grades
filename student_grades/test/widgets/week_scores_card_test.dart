import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:student_grades/l10n/app_localizations.dart';
import 'package:student_grades/models/category_manager.dart';
import 'package:student_grades/widgets/week_scores_card.dart';
import '../helpers/test_app.dart';

void main() {
  testWidgets('renders week label and localized category name', (tester) async {
    final category = CustomCategory(
      id: '1',
      name: 'Math',
      arabicName: 'Math AR',
      color: Colors.blue,
    );
    final controller = TextEditingController();
    addTearDown(controller.dispose);

    await tester.pumpWidget(
      buildTestApp(
        locale: const Locale('en'),
        child: WeekScoresCard(
          weekNumber: 1,
          categories: [category],
          controllers: {category: controller},
          onScoreChanged: (_, __) {},
        ),
      ),
    );

    final context = tester.element(find.byType(WeekScoresCard));
    final localizations = AppLocalizations.of(context)!;

    expect(find.text('${localizations.week} 1'), findsOneWidget);
    expect(find.text('Math'), findsOneWidget);
  });

  testWidgets('onScoreChanged receives parsed value', (tester) async {
    final category = CustomCategory(
      id: '1',
      name: 'Math',
      arabicName: 'Math AR',
      color: Colors.blue,
    );
    final controller = TextEditingController();
    addTearDown(controller.dispose);

    double? lastScore;

    await tester.pumpWidget(
      buildTestApp(
        locale: const Locale('en'),
        child: WeekScoresCard(
          weekNumber: 1,
          categories: [category],
          controllers: {category: controller},
          onScoreChanged: (_, score) => lastScore = score,
        ),
      ),
    );

    await tester.enterText(find.byType(TextFormField), '95.5');
    await tester.pump();

    expect(lastScore, 95.5);
  });

  testWidgets('uses arabicName when locale is ar', (tester) async {
    final category = CustomCategory(
      id: '1',
      name: 'Math',
      arabicName: 'Math AR',
      color: Colors.blue,
    );
    final controller = TextEditingController();
    addTearDown(controller.dispose);

    await tester.pumpWidget(
      buildTestApp(
        locale: const Locale('ar'),
        child: WeekScoresCard(
          weekNumber: 1,
          categories: [category],
          controllers: {category: controller},
          onScoreChanged: (_, __) {},
        ),
      ),
    );

    expect(find.text('Math AR'), findsOneWidget);
  });
}
