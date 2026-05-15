import 'package:flutter/material.dart';
import '../models/category_manager.dart';

class CategoryProvider with ChangeNotifier {
  late CategoryManager _categoryManager;
  bool _isLoading = true;
  List<CustomCategory> _categories = [];
  int _weeksCount = 12;

  CategoryProvider() {
    _initializeCategoryManager();
  }

  bool get isLoading => _isLoading;
  List<CustomCategory> get categories => _categories;
  bool get isUsingCustomCategories => _categoryManager.isUsingCustomCategories();
  CategoryManager get categoryManager => _categoryManager;
  int get weeksCount => _weeksCount;

  Future<void> _initializeCategoryManager() async {
    _categoryManager = CategoryManager();
    await _categoryManager.loadCategories();
    _categories = _categoryManager.getEffectiveCategories();
    _weeksCount = _categoryManager.weeksCount;
    _isLoading = false;
    notifyListeners();
  }

  Future<void> initialize() async {
    await _initializeCategoryManager();
  }

  Future<void> addCategory(String name, String arabicName, Color color) async {
    _categoryManager.addCategory(name, arabicName, color);
    _categories = _categoryManager.getEffectiveCategories();
    notifyListeners();
  }

  Future<void> editCategory(String id, String name, String arabicName, Color color) async {
    _categoryManager.editCategory(id, name, arabicName, color);
    _categories = _categoryManager.getEffectiveCategories();
    notifyListeners();
  }

  Future<void> deleteCategory(String id) async {
    _categoryManager.deleteCategory(id);
    _categories = _categoryManager.getEffectiveCategories();
    notifyListeners();
  }

  Future<void> setWeeksCount(int count) async {
    _categoryManager.setWeeksCount(count);
    _weeksCount = _categoryManager.weeksCount;
    notifyListeners();
  }
}