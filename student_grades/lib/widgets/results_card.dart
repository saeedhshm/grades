import 'dart:math' as math;
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

    Color sc(double v) {
      if (v >= 90) return const Color(0xFF059669);
      if (v >= 75) return const Color(0xFF4F46E5);
      if (v >= 60) return const Color(0xFFD97706);
      return const Color(0xFFE11D48);
    }

    String sg(double v) {
      if (v >= 90) return 'ممتاز';
      if (v >= 75) return 'جيد جداً';
      if (v >= 60) return 'جيد';
      if (v >= 50) return 'مقبول';
      return 'ضعيف';
    }

    final sColor = sc(pct);
    final grade = sg(pct);

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 24,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            // Header
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFEF3C7),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.emoji_events_rounded, color: Color(0xFFD97706), size: 22),
                ),
                const SizedBox(width: 12),
                Text(
                  AppLocalizations.of(context)!.results,
                  style: const TextStyle(
                    fontSize: 20, fontWeight: FontWeight.w800, color: Color(0xFF0F172A),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            // Circular progress
            SizedBox(
              height: 180,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox(
                    width: 180, height: 180,
                    child: TweenAnimationBuilder<double>(
                      tween: Tween(begin: 0, end: pct / 100),
                      duration: const Duration(milliseconds: 1000),
                      curve: Curves.easeOutCubic,
                      builder: (context, value, child) {
                        return CustomPaint(
                          painter: _CircularProgressPainter(
                            progress: value,
                            color: sColor,
                            backgroundColor: const Color(0xFFF1F5F9),
                            strokeWidth: 14,
                          ),
                          child: child,
                        );
                      },
                      child: const SizedBox(width: 180, height: 180),
                    ),
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        finalScore.toStringAsFixed(1),
                        style: const TextStyle(
                          fontSize: 40, fontWeight: FontWeight.w900,
                          color: Color(0xFF0F172A), letterSpacing: -2,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '/ $maxScore',
                        style: TextStyle(
                          fontSize: 14, fontWeight: FontWeight.w600,
                          color: Colors.grey.shade500,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            // Grade badge
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [sColor.withValues(alpha: 0.12), sColor.withValues(alpha: 0.06)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: sColor.withValues(alpha: 0.2)),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 10, height: 10,
                    decoration: BoxDecoration(color: sColor, shape: BoxShape.circle),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    grade,
                    style: TextStyle(
                      fontSize: 16, fontWeight: FontWeight.w800, color: sColor,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '${pct.toStringAsFixed(1)}%',
                    style: TextStyle(
                      fontSize: 13, fontWeight: FontWeight.w600,
                      color: sColor.withValues(alpha: 0.7),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            // Category breakdown
            ...studentScores.customScores.keys.map((cat) {
              final avg = studentScores.getCategoryAverage(cat);
              return Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF8FAFC),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 38, height: 38,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [cat.color.withValues(alpha: 0.15), cat.color.withValues(alpha: 0.08)],
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Center(
                          child: Container(
                            width: 10, height: 10,
                            decoration: BoxDecoration(color: cat.color, shape: BoxShape.circle),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          cat.getLocalizedName(context),
                          style: const TextStyle(
                            fontSize: 14, fontWeight: FontWeight.w600, color: Color(0xFF0F172A),
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: const Color(0xFFE2E8F0)),
                        ),
                        child: Text(
                          avg.toStringAsFixed(1),
                          style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w800, color: Color(0xFF0F172A),
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

class _CircularProgressPainter extends CustomPainter {
  final double progress;
  final Color color;
  final Color backgroundColor;
  final double strokeWidth;

  _CircularProgressPainter({
    required this.progress,
    required this.color,
    required this.backgroundColor,
    required this.strokeWidth,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - strokeWidth) / 2;

    final bgPaint = Paint()
      ..color = backgroundColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    canvas.drawCircle(center, radius, bgPaint);

    final fgPaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -math.pi / 2,
      2 * math.pi * progress,
      false,
      fgPaint,
    );
  }

  @override
  bool shouldRepaint(covariant _CircularProgressPainter oldDelegate) =>
      oldDelegate.progress != progress;
}
