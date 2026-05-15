import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/category_provider.dart';
import '../models/category_manager.dart';
import 'grades_calculator_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void dispose() {
    super.dispose();
  }

  void _navigateToCalculator() {
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, a1, a2) => const GradesCalculatorScreen(),
        transitionsBuilder: (context, a1, a2, child) =>
            FadeTransition(opacity: a1, child: child),
        transitionDuration: const Duration(milliseconds: 300),
      ),
    );
  }

  void _showCategorySheet({CustomCategory? category}) {
    final nameController = TextEditingController(text: category?.arabicName ?? '');
    Color selectedColor = category?.color ?? const Color(0xFF4F46E5);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setSheetState) => Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
          ),
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(ctx).viewInsets.bottom + 24,
            left: 24,
            right: 24,
            top: 24,
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(child: _SheetHandle()),
                const SizedBox(height: 24),
                Row(
                  children: [
                    _GradientIcon(
                      icon: category == null ? Icons.add_rounded : Icons.edit_rounded,
                    ),
                    const SizedBox(width: 14),
                    Text(
                      category == null ? 'إضافة فئة' : 'تعديل الفئة',
                      style: const TextStyle(
                        fontSize: 22, fontWeight: FontWeight.w800, color: Color(0xFF0F172A),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 28),
                _SectionLabel(text: 'اسم الفئة'),
                const SizedBox(height: 8),
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    hintText: 'مثال: الرياضيات',
                    prefixIcon: Icon(Icons.category_outlined, color: Color(0xFF94A3B8)),
                  ),
                  autofocus: true,
                ),
                const SizedBox(height: 24),
                _SectionLabel(text: 'اختر اللون'),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 12, runSpacing: 12,
                  children: [
                    const Color(0xFF4F46E5), const Color(0xFFE11D48),
                    const Color(0xFF059669), const Color(0xFFD97706),
                    const Color(0xFF7C3AED), const Color(0xFF0891B2),
                    const Color(0xFF2563EB), const Color(0xFFDB2777),
                    const Color(0xFFDC2626), const Color(0xFF65A30D),
                  ].map((color) => GestureDetector(
                    onTap: () => setSheetState(() => selectedColor = color),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      width: 46, height: 46,
                      decoration: BoxDecoration(
                        color: color,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: selectedColor == color ? Colors.white : Colors.transparent,
                          width: 3,
                        ),
                        boxShadow: selectedColor == color
                            ? [BoxShadow(color: color.withValues(alpha: 0.5), blurRadius: 10, spreadRadius: 1)]
                            : [],
                      ),
                      child: selectedColor == color
                          ? const Icon(Icons.check, color: Colors.white, size: 20)
                          : null,
                    ),
                  )).toList(),
                ),
                const SizedBox(height: 28),
                Row(
                  children: [
                    Expanded(child: OutlinedButton(
                      onPressed: () => Navigator.pop(ctx),
                      child: const Text('إلغاء'),
                    )),
                    const SizedBox(width: 12),
                    Expanded(
                      flex: 2,
                      child: _GradientButton(
                        onPressed: () async {
                          final name = nameController.text.trim();
                          if (name.isEmpty) return;
                          final p = Provider.of<CategoryProvider>(context, listen: false);
                          if (category == null) {
                            await p.addCategory(name, name, selectedColor);
                          } else {
                            await p.editCategory(category.id, name, name, selectedColor);
                          }
                          Navigator.pop(ctx);
                        },
                        child: Text(category == null ? 'إضافة' : 'حفظ'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showDeleteSheet(CustomCategory category) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
        ),
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Center(child: _SheetHandle()),
            const SizedBox(height: 24),
            TweenAnimationBuilder<double>(
              tween: Tween(begin: 0, end: 1),
              duration: const Duration(milliseconds: 400),
              builder: (context, value, child) => Transform.scale(
                scale: value,
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFEF2F2),
                    shape: BoxShape.circle,
                    border: Border.all(color: const Color(0xFFFECACA), width: 2),
                  ),
                  child: const Icon(Icons.delete_outline_rounded, color: Color(0xFFE11D48), size: 36),
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'حذف الفئة',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: Color(0xFF0F172A)),
            ),
            const SizedBox(height: 8),
            Text(
              'سيتم حذف "${category.arabicName}"\nنهائياً من القائمة',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 15, color: Colors.grey.shade600, height: 1.5),
            ),
            const SizedBox(height: 28),
            Row(
              children: [
                Expanded(child: OutlinedButton(
                  onPressed: () => Navigator.pop(ctx),
                  child: const Text('إلغاء'),
                )),
                const SizedBox(width: 12),
                Expanded(
                  flex: 2,
                  child: ElevatedButton(
                    onPressed: () async {
                      final p = Provider.of<CategoryProvider>(context, listen: false);
                      await p.deleteCategory(category.id);
                      Navigator.pop(ctx);
                      if (mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(_buildSnack('تم حذف "${category.arabicName}"'));
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFE11D48),
                      foregroundColor: Colors.white,
                    ),
                    child: const Text('حذف'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showWeeksSheet() {
    final p = Provider.of<CategoryProvider>(context, listen: false);
    int weeks = p.weeksCount;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setSheetState) => Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
          ),
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Center(child: _SheetHandle()),
              const SizedBox(height: 24),
              _GradientIcon(icon: Icons.date_range_rounded),
              const SizedBox(height: 20),
              const Text(
                'عدد الأسابيع',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: Color(0xFF0F172A)),
              ),
              const SizedBox(height: 8),
              Text(
                'اختر عدد أسابيع الفصل الدراسي',
                style: TextStyle(fontSize: 15, color: Colors.grey.shade500),
              ),
              const SizedBox(height: 28),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _StepperBtn(
                    icon: Icons.remove_rounded,
                    onTap: () {
                      if (weeks > 1) setSheetState(() => weeks--);
                    },
                  ),
                  Container(
                    width: 100, height: 80,
                    margin: const EdgeInsets.symmetric(horizontal: 20),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [const Color(0xFFEEF2FF), const Color(0xFFE0E7FF)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Center(
                      child: Text(
                        '$weeks',
                        style: const TextStyle(
                          fontSize: 36, fontWeight: FontWeight.w900,
                          color: Color(0xFF4F46E5),
                        ),
                      ),
                    ),
                  ),
                  _StepperBtn(
                    icon: Icons.add_rounded,
                    onTap: () {
                      if (weeks < 52) setSheetState(() => weeks++);
                    },
                  ),
                ],
              ),
              const SizedBox(height: 28),
              Row(
                children: [
                  Expanded(child: OutlinedButton(
                    onPressed: () => Navigator.pop(ctx),
                    child: const Text('إلغاء'),
                  )),
                  const SizedBox(width: 12),
                  Expanded(
                    flex: 2,
                    child: _GradientButton(
                      onPressed: () {
                        p.setWeeksCount(weeks);
                        Navigator.pop(ctx);
                        ScaffoldMessenger.of(context).showSnackBar(_buildSnack('تم حفظ عدد الأسابيع: $weeks'));
                      },
                      child: const Text('حفظ'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  SnackBar _buildSnack(String msg, {bool isError = false}) {
    return SnackBar(
      content: Row(
        children: [
          Icon(isError ? Icons.error_outline_rounded : Icons.check_circle_rounded, color: Colors.white, size: 22),
          const SizedBox(width: 12),
          Expanded(child: Text(msg, style: const TextStyle(fontWeight: FontWeight.w600))),
        ],
      ),
      backgroundColor: isError ? const Color(0xFFE11D48) : const Color(0xFF059669),
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      margin: const EdgeInsets.all(16),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<CategoryProvider>(
      builder: (context, provider, child) {
        if (provider.isLoading) {
          return Scaffold(
            backgroundColor: const Color(0xFFFDF2F8),
            body: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TweenAnimationBuilder<double>(
                    tween: Tween(begin: 0, end: 1),
                    duration: const Duration(seconds: 1),
                    builder: (context, value, child) => Transform.rotate(
                      angle: value * 6.28,
                      child: Container(
                        width: 48, height: 48,
                        child: const CircularProgressIndicator(
                          strokeWidth: 3,
                          color: Color(0xFF4F46E5),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text('جاري التحميل...',
                    style: TextStyle(color: Colors.grey.shade500, fontSize: 15)),
                ],
              ),
            ),
          );
        }

        final cats = provider.categories;

        return Scaffold(
          backgroundColor: const Color(0xFFFDF2F8),
          body: CustomScrollView(
            slivers: [
              SliverAppBar(
                expandedHeight: 130,
                pinned: true,
                backgroundColor: const Color(0xFFFDF2F8),
                surfaceTintColor: Colors.transparent,
                flexibleSpace: FlexibleSpaceBar(
                  titlePadding: const EdgeInsets.only(right: 24, bottom: 18),
                  title: Row(
                    children: [
                      Text('الفئات',
                        style: const TextStyle(
                          fontSize: 26, fontWeight: FontWeight.w900,
                          color: Color(0xFF0F172A),
                        ),
                      ),
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: const Color(0xFF4F46E5).withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          '${cats.length}',
                          style: const TextStyle(
                            fontSize: 13, fontWeight: FontWeight.w800,
                            color: Color(0xFF4F46E5),
                          ),
                        ),
                      ),
                    ],
                  ),
                  background: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          const Color(0xFF4F46E5).withValues(alpha: 0.08),
                          const Color(0xFFFDF2F8),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 8, 20, 0),
                  child: _WeeksBadge(count: provider.weeksCount, onTap: _showWeeksSheet),
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 100),
                sliver: cats.isEmpty
                    ? SliverToBoxAdapter(child: _EmptyList())
                    : SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (context, i) => Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: _CategoryTile(
                              category: cats[i],
                              onEdit: () => _showCategorySheet(category: cats[i]),
                              onDelete: () => _showDeleteSheet(cats[i]),
                            ),
                          ),
                          childCount: cats.length,
                        ),
                      ),
              ),
            ],
          ),
          floatingActionButton: Container(
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF4F46E5), Color(0xFF6366F1)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(18),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF4F46E5).withValues(alpha: 0.35),
                  blurRadius: 16, offset: const Offset(0, 6),
                ),
              ],
            ),
            child: FloatingActionButton.extended(
              onPressed: () => _showCategorySheet(),
              backgroundColor: Colors.transparent,
              elevation: 0,
              icon: const Icon(Icons.add_rounded, size: 24),
              label: const Text('إضافة فئة', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15)),
            ),
          ),
          bottomNavigationBar: Container(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
            decoration: BoxDecoration(color: Colors.white, boxShadow: [
              BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 20, offset: const Offset(0, -4)),
            ]),
            child: SafeArea(
              child: Container(
                height: 56,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF0F172A), Color(0xFF1E293B)],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(color: const Color(0xFF0F172A).withValues(alpha: 0.25), blurRadius: 12, offset: const Offset(0, 4)),
                  ],
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(16),
                    onTap: _navigateToCalculator,
                    child: const Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.calculate_rounded, color: Colors.white, size: 22),
                          SizedBox(width: 10),
                          Text('حاسبة الدرجات',
                            style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w800)),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

// --- Shared Components ---

class _SheetHandle extends StatelessWidget {
  const _SheetHandle();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40, height: 5,
      decoration: BoxDecoration(
        color: Colors.grey.shade300,
        borderRadius: BorderRadius.circular(3),
      ),
    );
  }
}

class _GradientIcon extends StatelessWidget {
  final IconData icon;
  const _GradientIcon({required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF4F46E5), Color(0xFF6366F1)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Icon(icon, color: Colors.white, size: 24),
    );
  }
}

class _GradientButton extends StatelessWidget {
  final VoidCallback onPressed;
  final Widget child;
  const _GradientButton({required this.onPressed, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF4F46E5), Color(0xFF6366F1)],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          foregroundColor: Colors.white,
          elevation: 0,
        ),
        child: child,
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  final String text;
  const _SectionLabel({required this.text});

  @override
  Widget build(BuildContext context) {
    return Text(text, style: const TextStyle(
      fontSize: 13, fontWeight: FontWeight.w600, color: Color(0xFF64748B),
    ));
  }
}

class _StepperBtn extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  const _StepperBtn({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: const Color(0xFFEEF2FF),
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Container(
          width: 56, height: 56,
          alignment: Alignment.center,
          child: Icon(icon, color: const Color(0xFF4F46E5), size: 26),
        ),
      ),
    );
  }
}

class _WeeksBadge extends StatelessWidget {
  final int count;
  final VoidCallback onTap;
  const _WeeksBadge({required this.count, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 12, offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFEEF2FF),
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Icon(Icons.calendar_month_rounded, color: Color(0xFF4F46E5), size: 24),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('عدد الأسابيع',
                  style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16, color: Color(0xFF0F172A))),
                Text('أسابيع الفصل الدراسي',
                  style: TextStyle(fontSize: 13, color: Colors.grey.shade500)),
              ],
            ),
          ),
          GestureDetector(
            onTap: onTap,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: const Color(0xFFEEF2FF),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('$count',
                    style: const TextStyle(
                      fontWeight: FontWeight.w900, fontSize: 20, color: Color(0xFF4F46E5))),
                  const SizedBox(width: 8),
                  Icon(Icons.edit_rounded, size: 14, color: const Color(0xFF94A3B8)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _EmptyList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(40),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(28),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [const Color(0xFFEEF2FF), const Color(0xFFE0E7FF)],
              ),
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.school_rounded, size: 64,
              color: const Color(0xFF4F46E5).withValues(alpha: 0.5)),
          ),
          const SizedBox(height: 28),
          const Text('لا توجد فئات',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: Color(0xFF0F172A))),
          const SizedBox(height: 10),
          Text('أضف المواد التي تريد حساب درجاتها',
            style: TextStyle(fontSize: 15, color: Colors.grey.shade500)),
        ],
      ),
    );
  }
}

class _CategoryTile extends StatelessWidget {
  final CustomCategory category;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  const _CategoryTile({required this.category, required this.onEdit, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    final c = category.color;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.03), blurRadius: 12, offset: const Offset(0, 4)),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(22),
        child: InkWell(
          borderRadius: BorderRadius.circular(22),
          onTap: onEdit,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  width: 54, height: 54,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [c.withValues(alpha: 0.15), c.withValues(alpha: 0.08)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Center(
                    child: Text(
                      category.arabicName.isNotEmpty ? category.arabicName[0] : '?',
                      style: TextStyle(color: c, fontWeight: FontWeight.w900, fontSize: 22),
                    ),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(category.arabicName,
                        style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16, color: Color(0xFF0F172A))),
                      const SizedBox(height: 4),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: c.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(category.name,
                          style: TextStyle(fontSize: 12, color: c, fontWeight: FontWeight.w600)),
                      ),
                    ],
                  ),
                ),
                _ActionIcon(icon: Icons.edit_rounded, color: const Color(0xFF94A3B8), onTap: onEdit),
                const SizedBox(width: 6),
                _ActionIcon(icon: Icons.delete_outline_rounded, color: const Color(0xFFE11D48), onTap: onDelete),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ActionIcon extends StatelessWidget {
  final IconData icon;
  final Color color;
  final VoidCallback onTap;
  const _ActionIcon({required this.icon, required this.color, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: color.withValues(alpha: 0.08),
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Container(padding: const EdgeInsets.all(10), child: Icon(icon, color: color, size: 20)),
      ),
    );
  }
}
