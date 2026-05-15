import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:student_grades/models/category_manager.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  test('loadCategories defaults to empty and custom disabled', () async {
    final manager = CategoryManager();

    await manager.loadCategories();

    expect(manager.customCategories, isEmpty);
    expect(manager.useCustomCategories, isFalse);
    expect(manager.isUsingCustomCategories(), isFalse);
    expect(manager.getEffectiveCategories(), isEmpty);
  });

  test('addCategory sets useCustom and persists', () async {
    final manager = CategoryManager();

    await manager.loadCategories();
    manager.addCategory('Math', 'Math AR', Colors.blue);

    expect(manager.useCustomCategories, isTrue);
    expect(manager.customCategories.length, 1);
    expect(manager.getEffectiveCategories().length, 1);

    await Future<void>.delayed(Duration.zero);

    final reloaded = CategoryManager();
    await reloaded.loadCategories();

    expect(reloaded.customCategories.length, 1);
    expect(reloaded.useCustomCategories, isTrue);
    expect(reloaded.customCategories.first.name, 'Math');
  });

  test('updateCategory edits fields', () async {
    final manager = CategoryManager();

    await manager.loadCategories();
    manager.addCategory('Math', 'Math AR', Colors.blue);
    final id = manager.customCategories.first.id;

    manager.updateCategory(id, 'Science', 'Science AR', Colors.green);

    expect(manager.customCategories.first.name, 'Science');
    expect(manager.customCategories.first.arabicName, 'Science AR');
    expect(manager.customCategories.first.color.value, Colors.green.value);

    await Future<void>.delayed(Duration.zero);

    final reloaded = CategoryManager();
    await reloaded.loadCategories();

    expect(reloaded.customCategories.first.name, 'Science');
    expect(reloaded.customCategories.first.arabicName, 'Science AR');
    expect(reloaded.customCategories.first.color.value, Colors.green.value);
  });

  test('editCategory updates existing category', () async {
    final manager = CategoryManager();

    await manager.loadCategories();
    manager.addCategory('Math', 'Math AR', Colors.blue);
    final id = manager.customCategories.first.id;

    manager.editCategory(id, 'Science', 'Science AR', Colors.green);

    expect(manager.customCategories.first.name, 'Science');
    expect(manager.customCategories.first.arabicName, 'Science AR');
    expect(manager.customCategories.first.color.value, Colors.green.value);
  });

  test('deleteCategory removes and persists', () async {
    final manager = CategoryManager();

    await manager.loadCategories();
    manager.addCategory('Math', 'Math AR', Colors.blue);
    await Future<void>.delayed(const Duration(milliseconds: 1));
    manager.addCategory('Science', 'Science AR', Colors.green);

    final id = manager.customCategories.first.id;
    manager.deleteCategory(id);

    expect(manager.customCategories.length, 1);
    expect(manager.customCategories.first.name, 'Science');

    await Future<void>.delayed(Duration.zero);

    final reloaded = CategoryManager();
    await reloaded.loadCategories();

    expect(reloaded.customCategories.length, 1);
    expect(reloaded.customCategories.first.name, 'Science');
  });

  test('setUseCustomCategories toggles and persists', () async {
    final manager = CategoryManager();

    await manager.loadCategories();
    manager.setUseCustomCategories(true);

    expect(manager.useCustomCategories, isTrue);

    await Future<void>.delayed(Duration.zero);

    final reloaded = CategoryManager();
    await reloaded.loadCategories();

    expect(reloaded.useCustomCategories, isTrue);
  });

  test('getEffectiveCategories respects useCustom flag', () async {
    final manager = CategoryManager();

    await manager.loadCategories();
    manager.addCategory('Math', 'Math AR', Colors.blue);
    manager.setUseCustomCategories(false);

    expect(manager.customCategories, isNotEmpty);
    expect(manager.getEffectiveCategories(), isEmpty);
  });
}
