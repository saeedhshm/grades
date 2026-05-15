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
    final lastIdx = categories.length - 1;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE7E5E4)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF0D9488), Color(0xFF0F766E)],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: Row(
              children: [
                const Icon(Icons.calendar_today_rounded, color: Colors.white, size: 16),
                const SizedBox(width: 8),
                Text(
                  '${AppLocalizations.of(context)!.week} $weekNumber',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 15,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(18, 14, 18, 16),
            child: Column(
              children: categories.asMap().entries.map((e) {
                final i = e.key;
                final cat = e.value;
                final isLast = i == lastIdx;
                return Padding(
                  padding: EdgeInsets.only(bottom: i < lastIdx ? 12 : 0),
                  child: Row(
                    children: [
                      Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          color: cat.color.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(11),
                        ),
                        child: Center(
                          child: Container(
                            width: 10,
                            height: 10,
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
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF292524),
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 10),
                      SizedBox(
                        width: 84,
                        child: TextFormField(
                          controller: controllers[cat],
                          focusNode: focusNodes[cat],
                          keyboardType: TextInputType.numberWithOptions(decimal: true),
                          textAlign: TextAlign.center,
                          textInputAction:
                              isLast && onLastField != null ? TextInputAction.done : TextInputAction.next,
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
                          ],
                          style: const TextStyle(
                              fontWeight: FontWeight.w700, fontSize: 15, color: Color(0xFF292524)),
                          decoration: InputDecoration(
                            hintText: '0',
                            hintStyle:
                                TextStyle(color: Colors.grey.shade300, fontWeight: FontWeight.w500),
                            filled: true,
                            fillColor: const Color(0xFFF5F5F4),
                            contentPadding: const EdgeInsets.symmetric(vertical: 9),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(11),
                              borderSide: BorderSide.none,
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(11),
                              borderSide: const BorderSide(color: Color(0xFFE7E5E4)),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(11),
                              borderSide: BorderSide(color: cat.color, width: 1.5),
                            ),
                          ),
                          onFieldSubmitted: (_) {
                            if (isLast && onLastField != null) {
                              onLastField!();
                            } else {
                              onNext(cat, weekNumber - 1);
                            }
                          },
                          onChanged: (v) => onScoreChanged(cat, double.tryParse(v)),
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
