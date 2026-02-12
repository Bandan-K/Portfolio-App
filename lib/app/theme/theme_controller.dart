import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'app_theme.dart';

class ThemeController extends GetxController {
  final _themeMode = ThemeMode.system.obs;

  ThemeMode get themeMode => _themeMode.value;

  bool get isDarkMode {
    if (_themeMode.value == ThemeMode.system) {
      return Get.isPlatformDarkMode;
    }
    return _themeMode.value == ThemeMode.dark;
  }

  void toggleTheme() {
    if (isDarkMode) {
      _themeMode.value = ThemeMode.light;
      Get.changeThemeMode(ThemeMode.light);
      Get.changeTheme(AppTheme.light);
    } else {
      _themeMode.value = ThemeMode.dark;
      Get.changeThemeMode(ThemeMode.dark);
      Get.changeTheme(AppTheme.dark);
    }
  }
}
