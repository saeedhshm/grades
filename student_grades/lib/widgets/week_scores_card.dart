import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../l10n/app_localizations.dart';
import '../models/category_manager.dart';

class WeekScoresCard extends StatelessWidget {
  final int weekNumber;
  final List<CustomCategory> categories;
  final Map<CustomCategory, TextEditingController> controllers;
  final Map<CustomCategory, FocusNode> focusNodes;
  final Function(CustomCategory, double?) onScoreChanged;
  final Function(CustomCategory, int) onNext;
  final VoidCallback? onLastField;

  const WeekScoresCard({
    super.key,
    required this.weekNumber,
    required this.categories,
    required this.controllers,
    required this.focusNodes,
    required this.onScoreChanged,
    required this.onNext,
    this.onLastField,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)],
                ),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.calendar_today_outlined, color: Colors.white, size: 16),
                  const SizedBox(width: 6),
                  Text(
                    '${AppLocalizations.of(context)!.week} $weekNumber',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            ...categories.asMap().entries.map((entry) {
              final index = entry.key;
              final category = entry.value;
              final isLastCategory = index == categories.length - 1;
              return Padding(
                padding: EdgeInsets.only(bottom: index < categories.length - 1 ? 14 : 0),
                child: Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: category.color.withOpacity(0.12),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Center(
                        child: Container(
                          width: 12,
                          height: 12,
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
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF1E1B4B),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 12),
                    SizedBox(
                      width: 90,
                      child: TextFormField(
                        controller: controllers[category],
                        focusNode: focusNodes[category],
                        keyboardType: TextInputType.numberWithOptions(decimal: true),
                        textAlign: TextAlign.center,
                        textInputAction: isLastCategory && onLastField != null
                            ? TextInputAction.done
                            : TextInputAction.next,
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
                        ],
                        style: const TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 16,
                        ),
                        decoration: InputDecoration(
                          hintText: '0',
                          hintStyle: TextStyle(
                            color: Colors.grey.shade300,
                            fontWeight: FontWeight.w500,
                          ),
                          filled: true,
                          fillColor: const Color(0xFFF8F9FC),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: Colors.grey.shade200),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: Colors.grey.shade200),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: category.color, width: 2),
                          ),
                          contentPadding: const EdgeInsets.symmetric(vertical: 10),
                        ),
                        onFieldSubmitted: (_) {
                          if (isLastCategory && onLastField != null) {
                            onLastField!();
                          } else {
                            onNext(category, weekNumber - 1);
                          }
                        },
                        onChanged: (value) {
                          final score = double.tryParse(value);
                          onScoreChanged(category, score);
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'مطلوب';
                          }
                          final score = double.tryParse(value);
                          if (score == null || score < 0 || score > 100) {
                            return '0-100';
                          }
                          return null;
                        },
                      ),
                    ),
                  ],
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}
