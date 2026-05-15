// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get appTitle => 'حاسبة درجات الطالب';

  @override
  String get studentName => 'اسم الطالب';

  @override
  String get studentNameHint => 'أدخل اسم الطالب';

  @override
  String get week => 'الأسبوع';

  @override
  String get homework => 'الواجبات';

  @override
  String get activities => 'الأنشطة';

  @override
  String get math => 'الرياضيات';

  @override
  String get science => 'العلوم';

  @override
  String get english => 'الإنجليزية';

  @override
  String get calculate => 'احسب';

  @override
  String get clear => 'مسح';

  @override
  String get results => 'النتائج';

  @override
  String categoryAverage(Object category) {
    return 'متوسط $category';
  }

  @override
  String get finalScore => 'الدرجة النهائية';

  @override
  String get validationRequired => 'يرجى ملء جميع الحقول';

  @override
  String get validationNameRequired => 'اسم الطالب مطلوب';

  @override
  String get languageToggle => 'EN';
}
