import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // ================= DARK MODE COLORS (Deep Space) =================
  static const Color background = Color(0xFF0A0E27);
  static const Color surface = Color(0xFF1A1F3A);
  // Ini adalah varian terang untuk Dark Mode (Navy agak terang)
  static const Color surfaceLight = Color(0xFF2A3354); 
  static const Color surfaceVariant = Color(0xFF3A4466);

  static const Color primary = Color(0xFF6366F1);
  static const Color primaryLight = Color(0xFF818CF8);
  static const Color primaryDark = Color(0xFF4F46E5);

  static const Color secondary = Color(0xFFEC4899);
  static const Color secondaryLight = Color(0xFFF472B6);
  static const Color tertiary = Color(0xFF8B5CF6);

  // ================= LIGHT MODE COLORS (New!) =================
  // Tambahan warna khusus untuk Tema Terang
  static const Color backgroundLight = Color(0xFFF3F4F6); // Abu-abu sangat muda (cool tone)
  static const Color surfaceWhite = Color(0xFFFFFFFF);    // Putih bersih (untuk Card/Surface di Light Mode)
  static const Color textPrimaryLight = Color(0xFF1F2937); // Hampir hitam (untuk teks utama)
  static const Color textSecondaryLight = Color(0xFF6B7280); // Abu-abu gelap (untuk teks sekunder)
  static const Color borderLight = Color(0xFFE5E7EB);     // Garis tipis

  // ================= VISUALIZATION COLORS =================
  static const Color barDefault = Color(0xFF3B82F6);
  static const Color barComparing = Color(0xFFEF4444);
  static const Color barSwapping = Color(0xFFF59E0B);
  static const Color barSorted = Color(0xFF10B981);
  static const Color barPivot = Color(0xFFEC4899);

  // ================= TEXT COLORS (Dark Mode Default) =================
  static const Color textPrimary = Color(0xFFF8FAFC);
  static const Color textSecondary = Color(0xFFCBD5E1);
  static const Color textDisabled = Color(0xFF64748B);
  static const Color textAccent = Color(0xFF818CF8);

  // ================= SEMANTIC COLORS =================
  static const Color success = Color(0xFF10B981);
  static const Color warning = Color(0xFFF59E0B);
  static const Color error = Color(0xFFEF4444);
  static const Color info = Color(0xFF3B82F6);

  // ================= GRADIENTS =================
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [primary, primaryDark],
  );

  static const LinearGradient surfaceGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [surface, background],
  );

  static const LinearGradient backgroundGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF0A0E27), Color(0xFF1A1F3A), Color(0xFF0A0E27)],
    stops: [0.0, 0.5, 1.0],
  );

  // ================= HELPER METHODS =================
  
  // Helper untuk opacity (menggunakan withValues untuk Dart terbaru)
  static Color withOpacity(Color color, double opacity) {
    return color.withValues(alpha: opacity);
  }

  static Color getBarColor(String state) {
    switch (state.toLowerCase()) {
      case 'comparing':
        return barComparing;
      case 'swapping':
        return barSwapping;
      case 'sorted':
        return barSorted;
      case 'pivot':
        return barPivot;
      default:
        return barDefault;
    }
  }
}