import 'package:flutter/material.dart';

extension AppColorsX on BuildContext {
  AppColors get colors => AppColors(this);
}

/// Context-aware color palette — automatically returns light or dark variants.
class AppColors {
  final BuildContext _context;
  const AppColors(this._context);

  bool get isDark => Theme.of(_context).brightness == Brightness.dark;

  // ── Backgrounds ────────────────────────────────────────────────
  Color get scaffoldBg =>
      isDark ? const Color(0xFF0D0D1A) : const Color(0xFFF5F7FA);
  Color get cardBg => isDark ? const Color(0xFF1A1A2E) : Colors.white;
  Color get inputFill =>
      isDark ? const Color(0xFF1E1E2E) : const Color(0xFFF9FAFB);
  Color get inputFillDisabled =>
      isDark ? const Color(0xFF252535) : const Color(0xFFF3F4F6);
  Color get greyInputFill =>
      isDark ? const Color(0xFF252535) : Colors.grey.shade100;
  Color get sheetBg =>
      isDark ? const Color(0xFF1A1A2E) : const Color(0xFFF5F7FA);

  // ── Borders / dividers ─────────────────────────────────────────
  Color get inputBorder =>
      isDark ? const Color(0xFF3A3A5C) : const Color(0xFFE5E7EB);
  Color get greyBorder =>
      isDark ? const Color(0xFF3A3A5C) : Colors.grey.shade300;
  Color get divider =>
      isDark ? const Color(0xFF2A2A3E) : const Color(0xFFF0F0F0);
  Color get dragHandle =>
      isDark ? const Color(0xFF3A3A5C) : Colors.grey.shade300;

  // ── Text ───────────────────────────────────────────────────────
  Color get primaryText =>
      isDark ? const Color(0xFFE8E8F0) : const Color(0xFF1A1A2E);
  Color get secondaryText =>
      isDark ? const Color(0xFF9E9E9E) : const Color(0xFF6B7280);
  Color get tertiaryText =>
      isDark ? const Color(0xFFB0B8C8) : const Color(0xFF374151);
  Color get inputHint =>
      isDark ? const Color(0xFF6B7280) : const Color(0xFF9CA3AF);
  Color get greyText => isDark ? const Color(0xFF9E9E9E) : Colors.grey;

  // ── Shadows ────────────────────────────────────────────────────
  Color get shadow => Colors.black.withAlpha(isDark ? 40 : 13);
  Color get shadowMedium =>
      Colors.black.withValues(alpha: isDark ? 0.10 : 0.05);
  Color get shadowHeavy => Colors.black.withValues(alpha: isDark ? 0.16 : 0.08);

  // ── Tinted accent backgrounds ──────────────────────────────────
  Color get lightBlueBg =>
      isDark ? const Color(0xFF1A2744) : const Color(0xFFE8F0FE);
  Color get lightGreenBg =>
      isDark ? const Color(0xFF0F2A1A) : const Color(0xFFDCFCE7);
  Color get lightYellowBg =>
      isDark ? const Color(0xFF2A2408) : const Color(0xFFFEF9C3);
  Color get lightRedBg =>
      isDark ? const Color(0xFF2A0A0A) : const Color(0xFFFEE2E2);
  Color get lightOrangeBg =>
      isDark ? const Color(0xFF2A1908) : const Color(0xFFFEF3C7);

  // ── Icon helpers ───────────────────────────────────────────────
  Color get greyIcon =>
      isDark ? const Color(0xFF6B7280) : const Color(0xFF9CA3AF);
}
