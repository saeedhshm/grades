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

class _GradesCalculatorScreenState extends State<GradesCalculatorScreen>
    with SingleTickerProviderStateMixin {
  late StudentScores _studentScores;
  late List<Map<CustomCategory, TextEditingController>> _controllers;
  late List<Map<CustomCategory, FocusNode>> _focusNodes;
  late int _weeksCount;
  bool _showResults = false;
  late AnimationController _animCtrl;
  late Animation<double> _fadeIn;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final List<GlobalKey> _weekKeys = [];

  @override
  void initState() {
    super.initState();
    _animCtrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 500));
    _fadeIn = CurvedAnimation(parent: _animCtrl, curve: Curves.easeOutCubic);
    _init();
  }

  void _init() {
    final p = Provider.of<CategoryProvider>(context, listen: false);
    final cats = p.categories;
    _weeksCount = p.weeksCount;
    _studentScores = StudentScores.empty(categories: cats, weeksCount: _weeksCount);
    _controllers = List.generate(_weeksCount, (wi) {
      final map = <CustomCategory, TextEditingController>{};
      for (final c in cats) {
        map[c] = TextEditingController(text: '');
      }
      return map;
    });
    _focusNodes = List.generate(_weeksCount, (wi) {
      final map = <CustomCategory, FocusNode>{};
      for (final c in cats) {
        map[c] = FocusNode();
      }
      return map;
    });
  }

  void _moveNext(CustomCategory cat, int weekIdx) {
    final p = Provider.of<CategoryProvider>(context, listen: false);
    final cats = p.categories;
    final i = cats.indexOf(cat);
    if (i < cats.length - 1) {
      _focusNodes[weekIdx][cats[i + 1]]?.requestFocus();
    } else if (weekIdx < _weeksCount - 1) {
      final next = weekIdx + 1;
      _focusNodes[next][cats.first]?.requestFocus();
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (_weekKeys.length > next) {
          Scrollable.ensureVisible(_weekKeys[next].currentContext!,
              duration: const Duration(milliseconds: 250), curve: Curves.easeOut, alignment: 0.05);
        }
      });
    }
  }

  void _calculate() {
    if (!_studentScores.isComplete()) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Row(children: [
          const Icon(Icons.info_outline, color: Colors.white, size: 20),
          const SizedBox(width: 10),
          Expanded(child: Text(AppLocalizations.of(context)!.validationRequired,
              style: const TextStyle(fontWeight: FontWeight.w600))),
        ]),
        backgroundColor: const Color(0xFFE11D48),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      ));
      return;
    }
    setState(() => _showResults = true);
    _animCtrl.forward(from: 0);
    FocusScope.of(context).unfocus();
  }

  void _clear() {
    final p = Provider.of<CategoryProvider>(context, listen: false);
    final cats = p.categories;
    setState(() {
      _weeksCount = p.weeksCount;
      _studentScores = StudentScores.empty(categories: cats, weeksCount: _weeksCount);
      _showResults = false;
      for (int w = 0; w < _weeksCount; w++) {
        for (final c in cats) _controllers[w][c]?.text = '';
      }
    });
  }

  @override
  void dispose() {
    _animCtrl.dispose();
    for (final w in _focusNodes) {
      for (final f in w.values) f.dispose();
    }
    for (final w in _controllers) {
      for (final c in w.values) c.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _weekKeys
      ..clear()
      ..addAll(List.generate(_weeksCount, (_) => GlobalKey()));

    return Scaffold(
      backgroundColor: const Color(0xFFFAFAF9),
      appBar: AppBar(title: Text(AppLocalizations.of(context)!.appTitle)),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    ...List.generate(_weeksCount, (wi) => Padding(
                      key: _weekKeys[wi],
                      padding: const EdgeInsets.only(bottom: 14),
                      child: Consumer<CategoryProvider>(
                        builder: (_, p, __) => WeekScoresCard(
                          weekNumber: wi + 1,
                          categories: p.categories,
                          controllers: _controllers[wi],
                          focusNodes: _focusNodes[wi],
                          onScoreChanged: (c, v) => _onChanged(c, wi, v),
                          onNext: (c, _) => _moveNext(c, wi),
                          onLastField: _calculate,
                        ),
                      ),
                    )),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Row(
                        children: [
                          Expanded(
                            child: SizedBox(
                              height: 54,
                              child: ElevatedButton.icon(
                                onPressed: _calculate,
                                icon: const Icon(Icons.calculate_rounded, size: 22),
                                label: Text(AppLocalizations.of(context)!.calculate),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF0D9488),
                                  foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(16)),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: SizedBox(
                              height: 54,
                              child: OutlinedButton.icon(
                                onPressed: _clear,
                                icon: const Icon(Icons.refresh_rounded, size: 22),
                                label: Text(AppLocalizations.of(context)!.clear),
                                style: OutlinedButton.styleFrom(
                                  foregroundColor: const Color(0xFF292524),
                                  side: const BorderSide(color: Color(0xFFD6D3D1)),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(16)),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (_showResults) ...[
                      const SizedBox(height: 8),
                      FadeTransition(
                        opacity: _fadeIn,
                        child: SlideTransition(
                          position: Tween<Offset>(begin: const Offset(0, 0.15), end: Offset.zero)
                              .animate(_fadeIn),
                          child: ResultsCard(studentScores: _studentScores),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _onChanged(CustomCategory cat, int weekIdx, double? v) {
    setState(() {
      _studentScores.customScores[cat]?[weekIdx] = v;
      _showResults = false;
    });
  }
}
