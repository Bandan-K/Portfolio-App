import 'package:flutter/material.dart';

/// Color constants matching the portfolio website's design system.
class AppColors {
  AppColors._();

  // Primary palette (from portfolio: blue-400 / purple-500 / indigo-400)
  static const Color primary = Color(0xFF60A5FA); // blue-400
  static const Color secondary = Color(0xFFA855F7); // purple-500
  static const Color tertiary = Color(0xFF818CF8); // indigo-400

  // Gradient colors
  static const List<Color> primaryGradient = [primary, secondary];
  static const List<Color> accentGradient = [
    Color(0xFF3B82F6),
    Color(0xFF8B5CF6),
  ];

  // Dark theme
  static const Color darkBg = Color(0xFF0F172A);
  static const Color darkSurface = Color(0xFF1E293B);
  static const Color darkCard = Color(0xFF1E293B);
  static const Color darkCardAlt = Color(0xFF334155);
  static const Color darkBorder = Color(0xFF334155);
  static const Color darkTextPrimary = Color(0xFFF1F5F9);
  static const Color darkTextSecondary = Color(0xFF94A3B8);

  // Light theme
  static const Color lightBg = Color(0xFFF8FAFC);
  static const Color lightSurface = Color(0xFFFFFFFF);
  static const Color lightCard = Color(0xFFFFFFFF);
  static const Color lightCardAlt = Color(0xFFF1F5F9);
  static const Color lightBorder = Color(0xFFE2E8F0);
  static const Color lightTextPrimary = Color(0xFF0F172A);
  static const Color lightTextSecondary = Color(0xFF64748B);

  // Category colors (matching CATEGORY_STYLES in SkillsSection.tsx)
  static const Color coreBlue = Color(0xFF60A5FA);
  static const Color frameworksPurple = Color(0xFFA855F7);
  static const Color toolsIndigo = Color(0xFF818CF8);

  static Color categoryColor(String category) {
    switch (category) {
      case 'core':
        return coreBlue;
      case 'frameworks':
        return frameworksPurple;
      case 'tools':
        return toolsIndigo;
      default:
        return primary;
    }
  }
}
