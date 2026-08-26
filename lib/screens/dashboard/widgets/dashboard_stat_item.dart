import 'package:flutter/material.dart';

import '../../../core/theme/porter_ui_tokens.dart';

class DashboardStatItem extends StatelessWidget {
  final String title;
  final String value;
  final Color color;
  final double? animatedValue;
  final String valuePrefix;
  final int decimalDigits;

  const DashboardStatItem({
    super.key,
    required this.title,
    required this.value,
    required this.color,
    this.animatedValue,
    this.valuePrefix = '',
    this.decimalDigits = 0,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        animatedValue == null
            ? Text(
                value,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w900,
                  color: color,
                ),
              )
            : TweenAnimationBuilder<double>(
                tween: Tween(end: animatedValue!),
                duration: const Duration(milliseconds: 900),
                curve: Curves.easeOutCubic,
                builder: (context, amount, child) => Text(
                  '$valuePrefix${amount.toStringAsFixed(decimalDigits)}',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                    color: color,
                  ),
                ),
              ),
        const SizedBox(height: 3),
        Text(
          title,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 10,
            color: PorterUiTokens.mutedText,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
