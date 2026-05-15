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
      for (final c in cats) map[c] = TextEditingController(text: '');
      return map;
    });
    _focusNodes = List.generate(_weeksCount, (wi) {
      final map = <CustomCategory, FocusNode>{};
      for (final c in cats) map[c] = FocusNode();
      return map;
    });
    _weekKeys
      ..clear()
      ..addAll(List.generate(_weeksCount, (_) => GlobalKey()));
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
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        margin: const EdgeInsets.all(16),
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
    for (final w in _focusNodes) {
      for (final f in w.values) f.dispose();
    }
    for (final w in _controllers) {
      for (final c in w.values) c.dispose();
    }
    setState(() {
      _weeksCount = p.weeksCount;
      _studentScores = StudentScores.empty(categories: cats, weeksCount: _weeksCount);
      _controllers = List.generate(_weeksCount, (wi) {
        final map = <CustomCategory, TextEditingController>{};
        for (final c in cats) map[c] = TextEditingController(text: '');
        return map;
      });
      _focusNodes = List.generate(_weeksCount, (wi) {
        final map = <CustomCategory, FocusNode>{};
        for (final c in cats) map[c] = FocusNode();
        return map;
      });
      _weekKeys
        ..clear()
        ..addAll(List.generate(_weeksCount, (_) => GlobalKey()));
      _showResults = false;
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

    return Scaffold(
      backgroundColor: const Color(0xFFFDF2F8),
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.appTitle),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                const Color(0xFF4F46E5).withValues(alpha: 0.06),
                const Color(0xFFFDF2F8),
              ],
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 100),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // Progress indicator bar
              Container(
                margin: const EdgeInsets.only(bottom: 16),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: const Color(0xFFE2E8F0)),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: const Color(0xFFEEF2FF),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(Icons.assignment_rounded, color: Color(0xFF4F46E5), size: 22),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('إدخال الدرجات',
                            style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15, color: Color(0xFF0F172A))),
                          const SizedBox(height: 4),
                          Text('$_weeksCount أسابيع - ${_studentScores.customScores.length} مواد',
                            style: TextStyle(fontSize: 13, color: Colors.grey.shade500)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              // Week cards
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
                    onLastField: wi == _weeksCount - 1 ? _calculate : null,
                  ),
                ),
              )),
              const SizedBox(height: 4),
              // Action buttons
              Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 56,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF4F46E5), Color(0xFF6366F1)],
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                        ),
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF4F46E5).withValues(alpha: 0.3),
                            blurRadius: 12, offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(16),
                          onTap: _calculate,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.calculate_rounded, color: Colors.white, size: 22),
                              const SizedBox(width: 10),
                              Text(AppLocalizations.of(context)!.calculate,
                                style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w700)),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Container(
                      height: 56,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: const Color(0xFFCBD5E1), width: 1.5),
                      ),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(16),
                          onTap: _clear,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.refresh_rounded, color: const Color(0xFF64748B), size: 22),
                              const SizedBox(width: 10),
                              Text(AppLocalizations.of(context)!.clear,
                                style: const TextStyle(color: Color(0xFF0F172A), fontSize: 16, fontWeight: FontWeight.w700)),
                            ],
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
                  opacity: _fadeIn,
                  child: SlideTransition(
                    position: Tween<Offset>(begin: const Offset(0, 0.15), end: Offset.zero).animate(_fadeIn),
                    child: ResultsCard(studentScores: _studentScores),
                  ),
                ),
              ],
            ],
          ),
        ),
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
