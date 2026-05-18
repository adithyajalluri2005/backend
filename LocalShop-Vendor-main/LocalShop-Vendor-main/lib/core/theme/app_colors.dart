import 'package:flutter/material.dart';

class AppColors {
  const AppColors._();

  static const Color primaryGreen = Color(0xFF16A34A);
  static const Color primaryGreenDark = Color(0xFF15803D);
  static const Color secondaryGreen = Color(0xFF22C55E);
  static const Color darkGreen = Color(0xFF064E3B);

  static const Color lightBackground = Color(0xFFF6FAF6);
  static const Color darkBackground = Color(0xFF0F172A);
  static const Color cardBackground = Color(0xFFFFFFFF);
  static const Color darkCardBackground = Color(0xFF111827);
  static const Color overlayBackground = Color(0xFFF0FDF4);

  static const Color textPrimary = Color(0xFF111827);
  static const Color textSecondary = Color(0xFF6B7280);
  static const Color darkTextPrimary = Color(0xFFF8FAFC);
  static const Color darkTextSecondary = Color(0xFFCBD5E1);

  static const Color borderColor = Color(0xFFE5E7EB);
  static const Color darkBorderColor = Color(0xFF334155);
  static const Color success = Color(0xFF10B981);
  static const Color warning = Color(0xFFF59E0B);
  static const Color danger = Color(0xFFEF4444);
  static const Color info = Color(0xFF2563EB);
  static const Color infoSoft = Color(0xFFDBEAFE);
  static const Color surfaceTint = Color(0xFFE8F5E9);

  static const LinearGradient splashGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: <Color>[primaryGreen, darkGreen],
  );

  static const LinearGradient infoGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: <Color>[Color(0xFFEFF6FF), infoSoft],
  );

  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: <Color>[primaryGreen, secondaryGreen],
  );
}
