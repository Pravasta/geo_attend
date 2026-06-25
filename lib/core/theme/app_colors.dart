import 'package:flutter/material.dart';

/// Palet warna brand GeoAttend.
class AppColors {
  AppColors._();

  static const Color primary = Color(0xFF3D5AFE);
  static const Color primaryDark = Color(0xFF2A3EB1);
  static const Color primaryLight = Color(0xFF8187FF);
  static const Color accent = Color(0xFF00BFA5);

  static const Color success = Color(0xFF2E7D32);
  static const Color successBg = Color(0xFFE6F4EA);
  static const Color danger = Color(0xFFC62828);
  static const Color dangerBg = Color(0xFFFDECEA);

  static const Color background = Color(0xFFF5F6FB);
  static const Color surface = Colors.white;
  static const Color textPrimary = Color(0xFF1A1C2E);
  static const Color textSecondary = Color(0xFF6B6F82);

  /// Gradien brand untuk header & splash.
  static const LinearGradient brandGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [primary, primaryDark],
  );
}
