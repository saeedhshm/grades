import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CategoryManager {
  static const String _categoriesKey = 'custom_categories';
  static const String _useCustomCategoriesKey = 'use_custom_categories';
  static const String _weeksCountKey = 'weeks_count';
  
  List<CustomCategory> _customCategories = [];
  bool _useCustomCategories = false;
  int _weeksCount = 12;
  
  List<CustomCategory> get customCategories => List.unmodifiable(_customCategories);
  bool get useCustomCategories => _useCustomCategories;
  int get weeksCount => _weeksCount;
  
  Future<void> loadCategories() async {
    final prefs = await SharedPreferences.getInstance();
    
    _useCustomCategories = prefs.getBool(_useCustomCategoriesKey) ?? false;
    _weeksCount = prefs.getInt(_weeksCountKey) ?? 12;
    
    final categoriesJson = prefs.getString(_categoriesKey);
    if (categoriesJson != null) {
      try {
        final List<dynamic> decoded = jsonDecode(categoriesJson);
        _customCategories = decoded.map((json) => CustomCategory.fromJson(json)).toList();
      } catch (e) {
        _customCategories = [];
      }
    } else {
      _customCategories = [];
    }
  }
  
  Future<void> saveCategories() async {
    final prefs = await SharedPreferences.getInstance();
    
    await prefs.setBool(_useCustomCategoriesKey, _useCustomCategories);
    await prefs.setInt(_weeksCountKey, _weeksCount);
    
    final categoriesJson = jsonEncode(_customCategories.map((cat) => cat.toJson()).toList());
    await prefs.setString(_categoriesKey, categoriesJson);
  }
  
  void addCategory(String name, String arabicName, Color color) {
    final category = CustomCategory(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: name,
      arabicName: arabicName,
      color: color,
    );
    _customCategories.add(category);
    _useCustomCategories = true; // Enable custom categories when adding the first one
    saveCategories();
  }
  
  void updateCategory(String id, String name, String arabicName, Color color) {
    final index = _customCategories.indexWhere((cat) => cat.id == id);
    if (index != -1) {
      _customCategories[index] = CustomCategory(
        id: id,
        name: name,
        arabicName: arabicName,
        color: color,
      );
      saveCategories();
    }
  }

  void editCategory(String id, String name, String arabicName, Color color) {
    updateCategory(id, name, arabicName, color);
  }

  bool isUsingCustomCategories() {
    return _useCustomCategories;
  }
  
  void deleteCategory(String id) {
    _customCategories.removeWhere((cat) => cat.id == id);
    saveCategories();
  }
  
  void setUseCustomCategories(bool useCustom) {
    _useCustomCategories = useCustom;
    saveCategories();
  }
  
  void setWeeksCount(int count) {
    _weeksCount = count;
    saveCategories();
  }
  
  List<CustomCategory> getEffectiveCategories() {
    if (_useCustomCategories && _customCategories.isNotEmpty) {
      return _customCategories;
    }
    return [];
  }

}

class CustomCategory {
  final String id;
  final String name;
  final String arabicName;
  final Color color;
  
  CustomCategory({
    required this.id,
    required this.name,
    required this.arabicName,
    required this.color,
  });
  
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'arabicName': arabicName,
      'color': color.value,
    };
  }
  
  factory CustomCategory.fromJson(Map<String, dynamic> json) {
    return CustomCategory(
      id: json['id'],
      name: json['name'],
      arabicName: json['arabicName'],
      color: Color(json['color']),
    );
  }
  
  String getLocalizedName(BuildContext context) {
    final locale = Localizations.localeOf(context);
    return locale.languageCode == 'ar' ? arabicName : name;
  }
}