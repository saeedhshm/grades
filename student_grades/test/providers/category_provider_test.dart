import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:student_grades/providers/category_provider.dart';
import '../helpers/test_fixtures.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  Future<void> waitForProvider(CategoryProvider provider) async {
    while (provider.isLoading) {
      await Future<void>.delayed(Duration.zero);
    }
  }

  test('initialize loads categories and clears loading', () async {
    final categories = [buildCategory(id: '1', name: 'Math')];
    setMockPrefsForCategories(useCustom: true, categories: categories);

    final provider = CategoryProvider();
    await waitForProvider(provider);

    expect(provider.isLoading, isFalse);
    expect(provider.categories.length, 1);
    expect(provider.categories.first.name, 'Math');
    expect(provider.isUsingCustomCategories, isTrue);
    expect(provider.categoryManager, isNotNull);
  });

  test('addCategory updates categories', () async {
    final provider = CategoryProvider();
    await waitForProvider(provider);

    await provider.addCategory('Math', 'Math AR', Colors.blue);

    expect(provider.categories.length, 1);
    expect(provider.isUsingCustomCategories, isTrue);
  });

  test('editCategory updates matching category', () async {
    final provider = CategoryProvider();
    await waitForProvider(provider);

    await provider.addCategory('Math', 'Math AR', Colors.blue);
    final id = provider.categories.first.id;

    await provider.editCategory(id, 'Science', 'Science AR', Colors.green);

    expect(provider.categories.first.name, 'Science');
    expect(provider.categories.first.arabicName, 'Science AR');
    expect(provider.categories.first.color, Colors.green);
  });

  test('deleteCategory removes category', () async {
    final provider = CategoryProvider();
    await waitForProvider(provider);

    await provider.addCategory('Math', 'Math AR', Colors.blue);
    await Future<void>.delayed(const Duration(milliseconds: 1));
    await provider.addCategory('Science', 'Science AR', Colors.green);

    final id = provider.categories.first.id;
    await provider.deleteCategory(id);

    expect(provider.categories.length, 1);
    expect(provider.categories.first.name, 'Science');
  });
}
