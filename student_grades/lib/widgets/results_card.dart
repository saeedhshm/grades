import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';
import '../models/student_scores.dart';

class ResultsCard extends StatelessWidget {
  final StudentScores studentScores;

  const ResultsCard({super.key, required this.studentScores});

  @override
  Widget build(BuildContext context) {
    final finalScore = studentScores.getFinalScore();
    final maxScore = studentScores.customScores.length * 100;
    final double scorePercentage = maxScore > 0 ? (finalScore / maxScore) * 100 : 0.0;

    Color getScoreColor(double percentage) {
      if (percentage >= 90) return const Color(0xFF10B981);
      if (percentage >= 75) return const Color(0xFF6366F1);
      if (percentage >= 60) return const Color(0xFFF59E0B);
      return Colors.red.shade400;
    }

    String getScoreGrade(double percentage) {
      if (percentage >= 90) return 'ممتاز';
      if (percentage >= 75) return 'جيد جداً';
      if (percentage >= 60) return 'جيد';
      if (percentage >= 50) return 'مقبول';
      return 'ضعيف';
    }

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            const Color(0xFF6366F1),
            const Color(0xFF8B5CF6),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF6366F1).withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.emoji_events_outlined,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  AppLocalizations.of(context)!.results,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.15),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        finalScore.toStringAsFixed(1),
                        style: const TextStyle(
                          fontSize: 42,
                          fontWeight: FontWeight.w900,
                          color: Colors.white,
                          letterSpacing: -1,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '/ $maxScore',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Colors.white.withOpacity(0.7),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                    decoration: BoxDecoration(
                      color: getScoreColor(scorePercentage).withOpacity(0.3),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      getScoreGrade(scorePercentage),
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: getScoreColor(scorePercentage),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            ...studentScores.customScores.keys.map((category) {
              final average = studentScores.getCategoryAverage(category);
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          color: category.color.withOpacity(0.3),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Center(
                          child: Container(
                            width: 10,
                            height: 10,
                            decoration: BoxDecoration(
                              color: category.color,
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          category.getLocalizedName(context),
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          average.toStringAsFixed(1),
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}
