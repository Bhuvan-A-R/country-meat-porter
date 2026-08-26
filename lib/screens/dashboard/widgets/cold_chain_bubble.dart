import 'package:flutter/material.dart';

import '../../../core/theme/porter_ui_tokens.dart';

class ColdChainBubble extends StatelessWidget {
  final Animation<double> animation;
  final VoidCallback onTap;

  const ColdChainBubble({
    super.key,
    required this.animation,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(animation.value / 3, -animation.value / 4),
          child: child,
        );
      },
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          width: 76,
          padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 10),
          decoration: BoxDecoration(
            color: PorterUiTokens.surface,
            borderRadius: PorterUiTokens.brLg,
            border: Border.all(color: const Color(0xFFBFDBFE), width: 1.5),
            boxShadow: [
              BoxShadow(
                color: PorterUiTokens.info.withValues(alpha: 0.18),
                blurRadius: 14,
                spreadRadius: 1,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: const Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _ColdChainIcon(),
              SizedBox(height: 5),
              Text(
                'Cold Chain',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 9,
                  fontWeight: FontWeight.w900,
                  color: Color(0xFF1E3A8A),
                ),
              ),
              SizedBox(height: 2),
              Text(
                'Tap',
                style: TextStyle(
                  fontSize: 8,
                  fontWeight: FontWeight.w600,
                  color: PorterUiTokens.mutedText,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ColdChainIcon extends StatelessWidget {
  const _ColdChainIcon();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 32,
      width: 32,
      decoration: const BoxDecoration(
        color: Color(0xFFEFF6FF),
        shape: BoxShape.circle,
      ),
      child: const Icon(
        Icons.ac_unit_rounded,
        color: PorterUiTokens.info,
        size: 18,
      ),
    );
  }
}
