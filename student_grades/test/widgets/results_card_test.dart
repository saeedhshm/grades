import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:student_grades/models/category_manager.dart';
import 'package:student_grades/models/student_scores.dart';
import 'package:student_grades/widgets/results_card.dart';
import '../helpers/test_app.dart';

void main() {
  testWidgets('renders category averages and final score', (tester) async {
    final categoryA = CustomCategory(
      id: '1',
      name: 'Math',
      arabicName: 'Math AR',
      color: Colors.blue,
    );
    final categoryB = CustomCategory(
      id: '2',
      name: 'Science',
      arabicName: 'Science AR',
      color: Colors.green,
    );

    final customScores = LinkedHashMap<CustomCategory, List<double?>>.identity()
      ..[categoryA] = <double?>[80.0, 90.0]
      ..[categoryB] = <double?>[100.0];
    final scores = StudentScores(customScores: customScores);

    await tester.pumpWidget(
      buildTestApp(
        locale: const Locale('en'),
        child: ResultsCard(studentScores: scores),
      ),
    );

    expect(find.text('85.0'), findsOneWidget);
    expect(find.text('100.0'), findsOneWidget);
    expect(find.text('92.5'), findsOneWidget);
  });
}
