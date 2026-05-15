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
    final double pct = maxScore > 0 ? (finalScore / maxScore) * 100 : 0.0;

    Color scoreColor(double v) {
      if (v >= 90) return const Color(0xFF059669);
      if (v >= 75) return const Color(0xFF0D9488);
      if (v >= 60) return const Color(0xFFD97706);
      return const Color(0xFFE11D48);
    }

    String scoreGrade(double v) {
      if (v >= 90) return 'ممتاز';
      if (v >= 75) return 'جيد جداً';
      if (v >= 60) return 'جيد';
      if (v >= 50) return 'مقبول';
      return 'ضعيف';
    }

    final sColor = scoreColor(pct);

    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF292524),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF292524).withValues(alpha: 0.15),
            blurRadius: 24,
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
                    color: Colors.white.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.emoji_events_rounded, color: Color(0xFFF59E0B), size: 22),
                ),
                const SizedBox(width: 12),
                Text(
                  AppLocalizations.of(context)!.results,
                  style: const TextStyle(
                    fontSize: 20,
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
                color: Colors.white.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(18),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        finalScore.toStringAsFixed(1),
                        style: const TextStyle(
                          fontSize: 46,
                          fontWeight: FontWeight.w900,
                          color: Colors.white,
                          letterSpacing: -1.5,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 6, left: 6),
                        child: Text(
                          '/ $maxScore',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.white.withValues(alpha: 0.5),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 6),
                    decoration: BoxDecoration(
                      color: sColor.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      scoreGrade(pct),
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: sColor,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            ...studentScores.customScores.keys.map((cat) {
              final avg = studentScores.getCategoryAverage(cat);
              return Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Row(
                  children: [
                    Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: cat.color.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(9),
                      ),
                      child: Center(
                        child: Container(
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: cat.color,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        cat.getLocalizedName(context),
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        avg.toStringAsFixed(1),
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }),
            const SizedBox(height: 8),
            Center(
              child: Container(
                height: 3,
                width: 60,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
