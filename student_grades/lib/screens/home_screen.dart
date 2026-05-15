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
  final TextEditingController _weeksController = TextEditingController();

  @override
  void dispose() {
    _weeksController.dispose();
    super.dispose();
  }

  void _navigateToCalculator() {
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, a1, a2) => const GradesCalculatorScreen(),
        transitionsBuilder: (context, a1, a2, child) {
          return FadeTransition(opacity: a1, child: child);
        },
        transitionDuration: const Duration(milliseconds: 300),
      ),
    );
  }

  void _showCategorySheet({CustomCategory? category}) {
    final nameController = TextEditingController(text: category?.arabicName ?? '');
    Color selectedColor = category?.color ?? const Color(0xFF0D9488);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setSheetState) => Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
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
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: const Color(0xFF0D9488).withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Icon(
                        category == null ? Icons.add_rounded : Icons.edit_rounded,
                        color: const Color(0xFF0D9488),
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 14),
                    Text(
                      category == null ? 'إضافة فئة' : 'تعديل الفئة',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF292524),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                const Text(
                  'اسم الفئة',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF78716C),
                  ),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    hintText: 'مثال: الرياضيات',
                    prefixIcon: Icon(Icons.category_outlined, color: Color(0xFFA8A29E)),
                  ),
                  autofocus: true,
                ),
                const SizedBox(height: 24),
                const Text(
                  'اللون',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF78716C),
                  ),
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 14,
                  runSpacing: 14,
                  children: [
                    const Color(0xFF0D9488),
                    const Color(0xFFE11D48),
                    const Color(0xFF059669),
                    const Color(0xFFD97706),
                    const Color(0xFF7C3AED),
                    const Color(0xFF0891B2),
                    const Color(0xFF2563EB),
                    const Color(0xFFDB2777),
                  ].map((color) => GestureDetector(
                    onTap: () => setSheetState(() => selectedColor = color),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: color,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: selectedColor == color ? Colors.white : Colors.transparent,
                          width: 3,
                        ),
                        boxShadow: selectedColor == color
                            ? [BoxShadow(color: color.withValues(alpha: 0.4), blurRadius: 10, spreadRadius: 1)]
                            : [],
                      ),
                      child: selectedColor == color
                          ? const Icon(Icons.check, color: Colors.white, size: 22)
                          : null,
                    ),
                  )).toList(),
                ),
                const SizedBox(height: 28),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.pop(ctx),
                        child: const Text('إلغاء'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      flex: 2,
                      child: ElevatedButton(
                        onPressed: () async {
                          final name = nameController.text.trim();
                          if (name.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              _buildSnack('يرجى إدخال اسم الفئة', isError: true),
                            );
                            return;
                          }
                          final provider = Provider.of<CategoryProvider>(context, listen: false);
                          if (category == null) {
                            await provider.addCategory(name, name, selectedColor);
                          } else {
                            await provider.editCategory(category.id, name, name, selectedColor);
                          }
                          Navigator.pop(ctx);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF0D9488),
                          foregroundColor: Colors.white,
                        ),
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
          borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        ),
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFFEF2F2),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.delete_outline_rounded, color: Color(0xFFE11D48), size: 32),
            ),
            const SizedBox(height: 16),
            const Text(
              'حذف الفئة',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: Color(0xFF292524),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'سيتم حذف "${category.arabicName}" نهائياً',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 15, color: Colors.grey.shade600),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(ctx),
                    child: const Text('إلغاء'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  flex: 2,
                  child: ElevatedButton(
                    onPressed: () async {
                      final provider = Provider.of<CategoryProvider>(context, listen: false);
                      await provider.deleteCategory(category.id);
                      Navigator.pop(ctx);
                      if (mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          _buildSnack('تم حذف "${category.arabicName}"'),
                        );
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

  SnackBar _buildSnack(String msg, {bool isError = false}) {
    return SnackBar(
      content: Row(
        children: [
          Icon(isError ? Icons.error_outline : Icons.check_circle_outline,
               color: Colors.white, size: 20),
          const SizedBox(width: 10),
          Expanded(child: Text(msg, style: const TextStyle(fontWeight: FontWeight.w600))),
        ],
      ),
      backgroundColor: isError ? const Color(0xFFE11D48) : const Color(0xFF059669),
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<CategoryProvider>(
      builder: (context, provider, child) {
        if (provider.isLoading) {
          return Scaffold(
            backgroundColor: const Color(0xFFFAFAF9),
            body: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    width: 36,
                    height: 36,
                    child: CircularProgressIndicator(
                      strokeWidth: 3,
                      color: const Color(0xFF0D9488).withValues(alpha: 0.6),
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text('جاري التحميل...',
                    style: TextStyle(color: Color(0xFFA8A29E), fontSize: 14)),
                ],
              ),
            ),
          );
        }

        final categories = provider.categories;
        if (_weeksController.text.isEmpty) {
          _weeksController.text = provider.weeksCount.toString();
        }

        return Scaffold(
          backgroundColor: const Color(0xFFFAFAF9),
          appBar: AppBar(
            title: const Text('الفئات'),
            actions: [
              Padding(
                padding: const EdgeInsets.only(left: 8),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFF0D9488).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    '${categories.length} فئة',
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF0D9488),
                    ),
                  ),
                ),
              ),
            ],
          ),
          body: Column(
            children: [
              Container(
                margin: const EdgeInsets.fromLTRB(20, 4, 20, 0),
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: const Color(0xFFE7E5E4), width: 1),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: const Color(0xFF0D9488).withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(Icons.date_range_rounded, color: Color(0xFF0D9488), size: 22),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('عدد الأسابيع',
                            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14, color: Color(0xFF292524))),
                          const SizedBox(height: 2),
                          Text('حدد عدد أسابيع الفصل الدراسي',
                            style: TextStyle(fontSize: 12, color: Colors.grey.shade500)),
                        ],
                      ),
                    ),
                    SizedBox(
                      width: 80,
                      child: TextField(
                        controller: _weeksController,
                        keyboardType: TextInputType.number,
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.symmetric(vertical: 10),
                          fillColor: const Color(0xFFF5F5F4),
                          suffix: GestureDetector(
                            onTap: () {
                              final count = int.tryParse(_weeksController.text);
                              if (count != null && count > 0 && count <= 52) {
                                provider.setWeeksCount(count);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  _buildSnack('تم حفظ عدد الأسابيع: $count'),
                                );
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  _buildSnack('أدخل رقماً بين 1 و 52', isError: true),
                                );
                              }
                            },
                            child: const Icon(Icons.check_circle_rounded,
                              color: Color(0xFF0D9488), size: 20),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              Expanded(
                child: categories.isEmpty
                    ? Center(
                        child: Padding(
                          padding: const EdgeInsets.all(40),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                padding: const EdgeInsets.all(28),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFF5F5F4),
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(Icons.book_outlined,
                                  size: 56, color: Colors.grey.shade400),
                              ),
                              const SizedBox(height: 24),
                              const Text('لا توجد فئات',
                                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: Color(0xFF292524))),
                              const SizedBox(height: 8),
                              Text('أضف المواد التي تريد حساب درجاتها',
                                style: TextStyle(fontSize: 15, color: Colors.grey.shade500)),
                            ],
                          ),
                        ),
                      )
                    : ListView.separated(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        itemCount: categories.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 10),
                        itemBuilder: (context, index) {
                          final cat = categories[index];
                          return _CategoryCard(
                            category: cat,
                            onEdit: () => _showCategorySheet(category: cat),
                            onDelete: () => _showDeleteSheet(cat),
                          );
                        },
                      ),
              ),
            ],
          ),
          floatingActionButton: SizedBox(
            height: 56,
            child: FloatingActionButton.extended(
              onPressed: () => _showCategorySheet(),
              backgroundColor: const Color(0xFF0D9488),
              foregroundColor: Colors.white,
              icon: const Icon(Icons.add_rounded),
              label: const Text('إضافة فئة', style: TextStyle(fontWeight: FontWeight.w600)),
            ),
          ),
          bottomNavigationBar: Container(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
            color: Colors.white,
            child: SafeArea(
              child: SizedBox(
                height: 56,
                child: ElevatedButton.icon(
                  onPressed: _navigateToCalculator,
                  icon: const Icon(Icons.calculate_rounded),
                  label: const Text('حاسبة الدرجات'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF292524),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
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

class _CategoryCard extends StatelessWidget {
  final CustomCategory category;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _CategoryCard({
    required this.category,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFE7E5E4)),
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(18),
        child: InkWell(
          borderRadius: BorderRadius.circular(18),
          onTap: onEdit,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: category.color.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Center(
                    child: Text(
                      category.arabicName.isNotEmpty ? category.arabicName[0] : '?',
                      style: TextStyle(
                        color: category.color,
                        fontWeight: FontWeight.w800,
                        fontSize: 20,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(category.arabicName,
                        style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16, color: Color(0xFF292524))),
                      const SizedBox(height: 2),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: category.color.withValues(alpha: 0.08),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(category.name,
                          style: TextStyle(fontSize: 11, color: category.color, fontWeight: FontWeight.w600)),
                      ),
                    ],
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Material(
                        color: Colors.transparent,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(10),
                          onTap: onEdit,
                          child: const Padding(
                            padding: EdgeInsets.all(10),
                            child: Icon(Icons.edit_rounded, size: 18, color: Color(0xFF78716C)),
                          ),
                        ),
                      ),
                      Material(
                        color: Colors.transparent,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(10),
                          onTap: onDelete,
                          child: const Padding(
                            padding: EdgeInsets.all(10),
                            child: Icon(Icons.delete_outline_rounded, size: 18, color: Color(0xFFE11D48)),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
