import 'category_manager.dart';

class StudentScores {
  final Map<CustomCategory, List<double?>> customScores;

  StudentScores({
    required this.customScores,
  });

  double getCategoryAverage(CustomCategory category) {
    final categoryScores = customScores[category] ?? [];
    final validScores = categoryScores.where((score) => score != null).cast<double>().toList();
    if (validScores.isEmpty) return 0.0;
    return validScores.reduce((a, b) => a + b) / validScores.length;
  }

  double getFinalScore() {
    double total = 0.0;
    for (final category in customScores.keys) {
      // print("=-=-=->>>>>>>> ${getCategoryAverage(category)}");
      total += getCategoryAverage(category);
    }
    // print("=-=-=->>>>>>>> $total");
    return customScores.keys.isEmpty ? 0.0 : total ;
  }

  bool isComplete() {
    for (final category in customScores.keys) {
      final categoryScores = customScores[category] ?? [];
      if (categoryScores.length != customScores.values.first.length) return false;
      if (categoryScores.any((score) => score == null || score < 0 || score > 100)) return false;
    }
    return true;
  }

  factory StudentScores.empty({required List<CustomCategory> categories, int weeksCount = 12}) {
    final scores = <CustomCategory, List<double?>>{};
    for (final category in categories) {
      scores[category] = List.filled(weeksCount, null);
    }
    return StudentScores(customScores: scores);
  }
}