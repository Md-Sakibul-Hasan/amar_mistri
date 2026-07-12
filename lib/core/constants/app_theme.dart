import 'dart:math' as math;

import 'package:flutter/material.dart';

class AppTheme {
  AppTheme._();

  // ── Brand colours ──────────────────────────────────────────────
  static const Color blue = Color(0xFF1A73E8);
  static const Color cyan = Color(0xFF00A2D2);
  static const Color teal = Color(0xFF00BFA5);
  static const Color tealBright = Color(0xFF00E5C9);

  // ── Gradients ──────────────────────────────────────────────────
  /// Full three-stop brand gradient (blue → cyan → teal)
  static const LinearGradient brandGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    transform: GradientRotation(160 * math.pi / 180),
    colors: [blue, cyan, teal],
    stops: [0.0, 0.5, 1.0],
  );

  /// Two-stop gradient used in the login header and CTA button
  static const LinearGradient headerGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    transform: GradientRotation(160 * math.pi / 180),
    colors: [blue, cyan],
  );

  // ── Decorative circle helper ────────────────────────────────────
  static Widget circle(double size, double opacity) => Opacity(
    opacity: opacity,
    child: Container(
      width: size,
      height: size,
      decoration: const BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
      ),
    ),
  );

  // ── Brand-name RichText ─────────────────────────────────────────
  static Widget brandName({double fontSize = 36}) => RichText(
    textAlign: TextAlign.center,
    text: TextSpan(
      style: TextStyle(
        fontSize: fontSize,
        fontWeight: FontWeight.w900,
        color: Colors.white,
        letterSpacing: -0.5,
      ),
      children: const [
        TextSpan(text: 'Sebaghar'),
      ],
    ),
  );

  // ── Small logo badge ───────────────────────────────────────────
  static Widget logoBadge({double size = 48, double iconSize = 24}) =>
      Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(size * 0.29),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(size * 0.29),
          child: Image.asset(
            'assets/images/app_logo.png',
            width: size,
            height: size,
            fit: BoxFit.cover,
          ),
        ),
      );

  // ── Styled input decoration ─────────────────────────────────────
  static InputDecoration inputDecoration({
    required String hint,
    Widget? prefixIcon,
    Widget? suffixIcon,
  }) => InputDecoration(
    hintText: hint,
    hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 14),
    prefixIcon: prefixIcon,
    suffixIcon: suffixIcon,
    filled: true,
    fillColor: Colors.grey.shade100,
    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: Colors.grey.shade300),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: Colors.grey.shade300),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: blue, width: 1.5),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: Colors.red),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: Colors.red, width: 1.5),
    ),
  );
}
