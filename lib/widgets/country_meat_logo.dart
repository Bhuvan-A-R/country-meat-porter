import 'package:flutter/material.dart';

class CountryMeatLogo extends StatelessWidget {
  final bool isRed;
  final double fontSize;
  final double? height;
  final double? width;

  const CountryMeatLogo({
    super.key,
    this.isRed = true,
    this.fontSize = 36.0,
    this.height,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    final assetPath = isRed
        ? 'assets/images/logo.png'
        : 'assets/images/logo_white.png';

    final calculatedHeight = height ?? (fontSize * 2.0);

    return Image.asset(
      assetPath,
      height: calculatedHeight,
      width: width,
      fit: BoxFit.contain,
      errorBuilder: (context, error, stackTrace) {
        return Icon(
          Icons.storefront_rounded,
          size: calculatedHeight * 0.8,
          color: isRed ? const Color(0xFFD32F2F) : Colors.white,
        );
      },
    );
  }
}

