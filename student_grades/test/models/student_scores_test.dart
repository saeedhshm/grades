import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:student_grades/models/category_manager.dart';
import 'package:student_grades/models/student_scores.dart';

void main() {
  test('getCategoryAverage returns 0 for empty scores', () {
    final category = CustomCategory(
      id: '1',
      name: 'Math',
      arabicName: 'Math AR',
      color: Colors.blue,
    );

    final scores = StudentScores(customScores: {
      category: <double?>[],
    });

    expect(scores.getCategoryAverage(category), 0.0);
  });

  test('getCategoryAverage ignores nulls', () {
    final category = CustomCategory(
      id: '1',
      name: 'Math',
      arabicName: 'Math AR',
      color: Colors.blue,
    );

    final scores = StudentScores(customScores: {
      category: <double?>[null, 50.0, 100.0],
    });

    expect(scores.getCategoryAverage(category), 75.0);
  });

  test('getFinalScore averages category averages', () {
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
      ..[categoryA] = <double?>[80.0]
      ..[categoryB] = <double?>[100.0];
    final scores = StudentScores(customScores: customScores);

    expect(scores.customScores.length, 2);
    expect(scores.getFinalScore(), 90.0);
  });

  test('getFinalScore returns 0 with no categories', () {
    final scores = StudentScores(customScores: {});

    expect(scores.getFinalScore(), 0.0);
  });

  test('isComplete validates lengths and ranges', () {
    final category = CustomCategory(
      id: '1',
      name: 'Math',
      arabicName: 'Math AR',
      color: Colors.blue,
    );

    final incomplete = StudentScores(customScores: {
      category: List<double?>.filled(11, 90.0),
    });
    expect(incomplete.isComplete(), isFalse);

    final invalid = StudentScores(customScores: {
      category: List<double?>.filled(12, 110.0),
    });
    expect(invalid.isComplete(), isFalse);

    final complete = StudentScores(customScores: {
      category: List<double?>.filled(12, 95.0),
    });
    expect(complete.isComplete(), isTrue);
  });

  test('empty factory creates 12 slots per category', () {
    final categories = [
      CustomCategory(
        id: '1',
        name: 'Math',
        arabicName: 'Math AR',
        color: Colors.blue,
      ),
      CustomCategory(
        id: '2',
        name: 'Science',
        arabicName: 'Science AR',
        color: Colors.green,
      ),
    ];

    final scores = StudentScores.empty(categories: categories);

    expect(scores.customScores.length, 2);
    for (final category in categories) {
      expect(scores.customScores[category], isNotNull);
      expect(scores.customScores[category]!.length, 12);
      expect(scores.customScores[category]!.every((value) => value == null), isTrue);
    }
  });
}
