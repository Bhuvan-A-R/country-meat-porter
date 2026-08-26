import 'package:flutter/material.dart';

class PorterUiTokens {
  static const Color bg = Color(0xFFF8FAFC);
  static const Color surface = Colors.white;
  static const Color border = Color(0xFFF1F5F9);
  static const Color mutedText = Color(0xFF64748B);
  static const Color strongText = Color(0xFF0F172A);

  static const Color success = Color(0xFF059669);
  static const Color warning = Color(0xFFD97706);
  static const Color info = Color(0xFF2563EB);
  static const Color danger = Color(0xFFDC2626);
  static const Color pickup = Color(0xFFEA580C);

  static const double radiusXs = 8;
  static const double radiusSm = 12;
  static const double radiusMd = 16;
  static const double radiusLg = 20;
  static const double radiusXl = 24;

  static BorderRadius get brXs => BorderRadius.circular(radiusXs);
  static BorderRadius get brSm => BorderRadius.circular(radiusSm);
  static BorderRadius get brMd => BorderRadius.circular(radiusMd);
  static BorderRadius get brLg => BorderRadius.circular(radiusLg);
  static BorderRadius get brXl => BorderRadius.circular(radiusXl);

  static List<BoxShadow> get surfaceShadow => [
    BoxShadow(
      color: Colors.black.withValues(alpha: 0.03),
      blurRadius: 16,
      offset: const Offset(0, 4),
    ),
  ];

  static BoxDecoration surfaceCard({
    BorderSide? side,
    BorderRadius? borderRadius,
    List<BoxShadow>? boxShadow,
    Color? color,
  }) {
    return BoxDecoration(
      color: color ?? surface,
      borderRadius: borderRadius ?? brLg,
      border: Border.fromBorderSide(
        side ?? const BorderSide(color: border, width: 1.2),
      ),
      boxShadow: boxShadow,
    );
  }
}
