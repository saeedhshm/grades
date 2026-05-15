import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../l10n/app_localizations.dart';
import '../models/category_manager.dart';
import '../models/student_scores.dart';
import '../providers/category_provider.dart';
import '../widgets/week_scores_card.dart';
import '../widgets/results_card.dart';

class GradesCalculatorScreen extends StatefulWidget {
  const GradesCalculatorScreen({super.key});

  @override
  State<GradesCalculatorScreen> createState() => _GradesCalculatorScreenState();
}

class _GradesCalculatorScreenState extends State<GradesCalculatorScreen> with SingleTickerProviderStateMixin {
  late StudentScores _studentScores;
  late List<Map<CustomCategory, TextEditingController>> _controllers;
  late int _weeksCount;
  bool _showResults = false;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
    _initializeScores();
  }

  void _initializeScores() {
    final provider = Provider.of<CategoryProvider>(context, listen: false);
    final categories = provider.categories;
    _weeksCount = provider.weeksCount;
    _studentScores = StudentScores.empty(categories: categories, weeksCount: _weeksCount);
    _controllers = List.generate(_weeksCount, (weekIndex) {
      final weekControllers = <CustomCategory, TextEditingController>{};
      for (final category in categories) {
        final score = _studentScores.customScores[category]?[weekIndex];
        weekControllers[category] = TextEditingController(
          text: score?.toString() ?? '',
        );
      }
      return weekControllers;
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    for (final weekControllers in _controllers) {
      for (final controller in weekControllers.values) {
        controller.dispose();
      }
    }
    super.dispose();
  }

  void _onScoreChanged(CustomCategory category, int weekIndex, double? score) {
    setState(() {
      _studentScores.customScores[category]?[weekIndex] = score;
      _showResults = false;
    });
  }

  void _calculate() {
    if (!_studentScores.isComplete()) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Icon(Icons.warning_amber_rounded, color: Colors.white),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  AppLocalizations.of(context)!.validationRequired,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
          backgroundColor: Colors.red.shade400,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      );
      return;
    }

    setState(() {
      _showResults = true;
    });
    _animationController.forward(from: 0);
    FocusScope.of(context).unfocus();
  }

  void _clear() {
    final provider = Provider.of<CategoryProvider>(context, listen: false);
    final categories = provider.categories;

    setState(() {
      _weeksCount = provider.weeksCount;
      _studentScores = StudentScores.empty(categories: categories, weeksCount: _weeksCount);
      _showResults = false;

      for (int weekIndex = 0; weekIndex < _weeksCount; weekIndex++) {
        for (final category in categories) {
          _controllers[weekIndex][category]?.text = '';
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FC),
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context)!.appTitle,
          style: const TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 18,
          ),
        ),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                const Color(0xFF6366F1).withOpacity(0.1),
                Colors.white,
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
              child: Column(
                children: [
                  ...List.generate(_weeksCount, (weekIndex) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: Consumer<CategoryProvider>(
                        builder: (context, provider, child) {
                          return WeekScoresCard(
                            weekNumber: weekIndex + 1,
                            categories: provider.categories,
                            controllers: _controllers[weekIndex],
                            onScoreChanged: (category, score) => _onScoreChanged(category, weekIndex, score),
                          );
                        },
                      ),
                    );
                  }),
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)],
                            ),
                            borderRadius: BorderRadius.circular(14),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFF6366F1).withOpacity(0.3),
                                blurRadius: 12,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              borderRadius: BorderRadius.circular(14),
                              onTap: _calculate,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(vertical: 16),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Icon(Icons.calculate_outlined, color: Colors.white),
                                    const SizedBox(width: 8),
                                    Text(
                                      AppLocalizations.of(context)!.calculate,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(color: const Color(0xFF6366F1), width: 1.5),
                          ),
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              borderRadius: BorderRadius.circular(14),
                              onTap: _clear,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(vertical: 16),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.refresh_outlined, color: const Color(0xFF6366F1)),
                                    const SizedBox(width: 8),
                                    Text(
                                      AppLocalizations.of(context)!.clear,
                                      style: const TextStyle(
                                        color: Color(0xFF6366F1),
                                        fontSize: 16,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  if (_showResults) ...[
                    const SizedBox(height: 20),
                    FadeTransition(
                      opacity: _fadeAnimation,
                      child: SlideTransition(
                        position: Tween<Offset>(
                          begin: const Offset(0, 0.2),
                          end: Offset.zero,
                        ).animate(_fadeAnimation),
                        child: ResultsCard(studentScores: _studentScores),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
