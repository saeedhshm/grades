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
  final TextEditingController _weeksController = TextEditingController(text: '12');

  @override
  void dispose() {
    _weeksController.dispose();
    super.dispose();
  }

  void _navigateToCalculator() {
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => const GradesCalculatorScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(1.0, 0.0);
          const end = Offset.zero;
          const curve = Curves.easeInOutCubic;
          var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
          return SlideTransition(position: animation.drive(tween), child: child);
        },
      ),
    );
  }

  void _showAddEditCategoryDialog({CustomCategory? category}) {
    final arabicNameController = TextEditingController(text: category?.arabicName ?? '');
    Color selectedColor = category?.color ?? const Color(0xFF6366F1);

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: const Color(0xFF6366F1).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          category == null ? Icons.add_circle_outline : Icons.edit_outlined,
                          color: const Color(0xFF6366F1),
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        category == null ? 'إضافة فئة جديدة' : 'تعديل الفئة',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF1E1B4B),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  TextField(
                    controller: arabicNameController,
                    decoration: const InputDecoration(
                      labelText: 'اسم الفئة',
                      hintText: 'مثال: الرياضيات',
                      prefixIcon: Icon(Icons.category_outlined),
                    ),
                    textCapitalization: TextCapitalization.words,
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'اختر اللون',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF64748B),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: [
                      const Color(0xFF6366F1),
                      const Color(0xFFEF4444),
                      const Color(0xFF10B981),
                      const Color(0xFFF59E0B),
                      const Color(0xFF8B5CF6),
                      const Color(0xFF14B8A6),
                      const Color(0xFF3B82F6),
                      const Color(0xFFEC4899),
                    ].map((color) => GestureDetector(
                      onTap: () => setState(() => selectedColor = color),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          color: color,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: selectedColor == color ? Colors.white : Colors.transparent,
                            width: 3,
                          ),
                          boxShadow: selectedColor == color
                              ? [
                                  BoxShadow(
                                    color: color.withOpacity(0.4),
                                    blurRadius: 8,
                                    spreadRadius: 2,
                                  ),
                                ]
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
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('إلغاء'),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () async {
                            final arabicName = arabicNameController.text.trim();

                            if (arabicName.isEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: const Text('يرجى إدخال اسم الفئة'),
                                  backgroundColor: Colors.red.shade400,
                                  behavior: SnackBarBehavior.floating,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                              );
                              return;
                            }

                            final provider = Provider.of<CategoryProvider>(context, listen: false);
                            if (category == null) {
                              await provider.addCategory(arabicName, arabicName, selectedColor);
                            } else {
                              await provider.editCategory(category.id, arabicName, arabicName, selectedColor);
                            }
                            if (mounted) Navigator.pop(context);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF6366F1),
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
      ),
    );
  }

  void _showDeleteConfirmation(CustomCategory category) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.red.shade50,
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.delete_outline, color: Colors.red.shade400, size: 32),
              ),
              const SizedBox(height: 16),
              const Text(
                'حذف الفئة',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF1E1B4B),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'هل أنت متأكد من حذف فئة "${category.arabicName}"؟',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.grey.shade600,
                ),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('إلغاء'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () async {
                        final provider = Provider.of<CategoryProvider>(context, listen: false);
                        await provider.deleteCategory(category.id);
                        Navigator.pop(context);
                        if (mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('تم حذف فئة "${category.arabicName}"'),
                              backgroundColor: const Color(0xFF10B981),
                              behavior: SnackBarBehavior.floating,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red.shade400,
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
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<CategoryProvider>(
      builder: (context, provider, child) {
        if (provider.isLoading) {
          return const Scaffold(
            body: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircularProgressIndicator(
                    color: Color(0xFF6366F1),
                  ),
                  SizedBox(height: 16),
                  Text(
                    'جاري التحميل...',
                    style: TextStyle(
                      color: Color(0xFF64748B),
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
          );
        }

        final categories = provider.categories;

        return Scaffold(
          backgroundColor: const Color(0xFFF8F9FC),
          appBar: AppBar(
            title: const Text('إدارة الفئات'),
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
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
                child: Container(
                  padding: const EdgeInsets.all(20),
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
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: const Color(0xFF6366F1).withOpacity(0.1),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Icon(
                              Icons.calendar_today_outlined,
                              color: Color(0xFF6366F1),
                              size: 20,
                            ),
                          ),
                          const SizedBox(width: 10),
                          const Text(
                            'عدد الأسابيع',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF1E1B4B),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        controller: _weeksController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          hintText: 'أدخل عدد الأسابيع',
                          prefixIcon: const Icon(Icons.numbers_outlined, color: Color(0xFF64748B)),
                          suffixIcon: Container(
                            margin: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: const Color(0xFF6366F1),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Material(
                              color: Colors.transparent,
                              child: InkWell(
                                borderRadius: BorderRadius.circular(10),
                                onTap: () {
                                  final count = int.tryParse(_weeksController.text);
                                  if (count != null && count > 0) {
                                    provider.setWeeksCount(count);
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text('تم حفظ عدد الأسابيع: $count'),
                                        backgroundColor: const Color(0xFF10B981),
                                        behavior: SnackBarBehavior.floating,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                      ),
                                    );
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: const Text('يرجى إدخال رقم صحيح أكبر من صفر'),
                                        backgroundColor: Colors.red.shade400,
                                        behavior: SnackBarBehavior.floating,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                      ),
                                    );
                                  }
                                },
                                child: const Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 12),
                                  child: Text(
                                    'حفظ',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: categories.isEmpty
                    ? Center(
                        child: Padding(
                          padding: const EdgeInsets.all(32),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                padding: const EdgeInsets.all(24),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF6366F1).withOpacity(0.08),
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  Icons.folder_open_outlined,
                                  size: 64,
                                  color: const Color(0xFF6366F1).withOpacity(0.6),
                                ),
                              ),
                              const SizedBox(height: 20),
                              const Text(
                                'لا توجد فئات بعد',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w700,
                                  color: Color(0xFF1E1B4B),
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'أضف المواد التي تريد حساب درجاتها',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 15,
                                  color: Colors.grey.shade500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        itemCount: categories.length,
                        itemBuilder: (context, index) {
                          final category = categories[index];
                          return TweenAnimationBuilder<double>(
                            duration: Duration(milliseconds: 200 + (index * 50)),
                            tween: Tween(begin: 0.0, end: 1.0),
                            builder: (context, value, child) {
                              return Transform.translate(
                                offset: Offset(0, 20 * (1 - value)),
                                child: Opacity(
                                  opacity: value,
                                  child: child,
                                ),
                              );
                            },
                            child: Card(
                              margin: const EdgeInsets.only(bottom: 12),
                              child: ListTile(
                                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                leading: Container(
                                  width: 48,
                                  height: 48,
                                  decoration: BoxDecoration(
                                    color: category.color.withOpacity(0.12),
                                    borderRadius: BorderRadius.circular(14),
                                  ),
                                  child: Center(
                                    child: Text(
                                      category.arabicName.isNotEmpty ? category.arabicName[0] : '?',
                                      style: TextStyle(
                                        color: category.color,
                                        fontWeight: FontWeight.w700,
                                        fontSize: 20,
                                      ),
                                    ),
                                  ),
                                ),
                                title: Text(
                                  category.arabicName,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 16,
                                  ),
                                ),
                                subtitle: Text(
                                  category.name,
                                  style: TextStyle(
                                    color: Colors.grey.shade500,
                                    fontSize: 13,
                                  ),
                                ),
                                trailing: provider.isUsingCustomCategories
                                    ? Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          _buildActionButton(
                                            icon: Icons.edit_outlined,
                                            color: const Color(0xFF6366F1),
                                            onTap: () => _showAddEditCategoryDialog(category: category),
                                          ),
                                          const SizedBox(width: 4),
                                          _buildActionButton(
                                            icon: Icons.delete_outline,
                                            color: Colors.red.shade400,
                                            onTap: () => _showDeleteConfirmation(category),
                                          ),
                                        ],
                                      )
                                    : null,
                              ),
                            ),
                          );
                        },
                      ),
              ),
            ],
          ),
          floatingActionButton: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              gradient: const LinearGradient(
                colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)],
              ),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF6366F1).withOpacity(0.3),
                  blurRadius: 12,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: FloatingActionButton.extended(
              onPressed: () => _showAddEditCategoryDialog(),
              backgroundColor: Colors.transparent,
              elevation: 0,
              icon: const Icon(Icons.add, color: Colors.white),
              label: const Text(
                'إضافة فئة',
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
              ),
            ),
          ),
          bottomNavigationBar: Container(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.04),
                  blurRadius: 20,
                  offset: const Offset(0, -4),
                ),
              ],
            ),
            child: SafeArea(
              child: Container(
                height: 56,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)],
                  ),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF6366F1).withOpacity(0.3),
                      blurRadius: 12,
                      offset: const Offset(0, 6),
                    ),
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
                          Icon(Icons.calculate_outlined, color: Colors.white),
                          SizedBox(width: 10),
                          Text(
                            'الانتقال إلى حاسبة الدرجات',
                            style: TextStyle(
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
          ),
        );
      },
    );
  }

  Widget _buildActionButton({required IconData icon, required Color color, required VoidCallback onTap}) {
    return Material(
      color: color.withOpacity(0.1),
      borderRadius: BorderRadius.circular(10),
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(8),
          child: Icon(icon, color: color, size: 20),
        ),
      ),
    );
  }
}
