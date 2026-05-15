import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:student_grades/models/category_manager.dart';

CustomCategory buildCategory({
  String id = '1',
  String name = 'Math',
  String arabicName = 'Math AR',
  Color color = Colors.blue,
}) {
  return CustomCategory(
    id: id,
    name: name,
    arabicName: arabicName,
    color: color,
  );
}

String encodeCategories(List<CustomCategory> categories) {
  return jsonEncode(categories.map((cat) => cat.toJson()).toList());
}

void setMockPrefsForCategories({
  required bool useCustom,
  required List<CustomCategory> categories,
}) {
  SharedPreferences.setMockInitialValues({
    'use_custom_categories': useCustom,
    'custom_categories': encodeCategories(categories),
  });
}
