import 'package:flutter/material.dart';

import '../../../core/theme/porter_ui_tokens.dart';

class DashboardQuickButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color? color;
  final VoidCallback onTap;

  const DashboardQuickButton({
    super.key,
    required this.icon,
    required this.label,
    this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final primary = color ?? Theme.of(context).colorScheme.primary;

    return InkWell(
      onTap: onTap,
      borderRadius: PorterUiTokens.brMd,
      child: Ink(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
        decoration: PorterUiTokens.surfaceCard(
          borderRadius: PorterUiTokens.brMd,
          side: const BorderSide(color: PorterUiTokens.border),
        ),
        child: Column(
          children: [
            Icon(icon, size: 22, color: primary),
            const SizedBox(height: 4),
            const _QuickButtonLabel(),
          ],
        ),
      ),
    );
  }
}

class _QuickButtonLabel extends StatelessWidget {
  const _QuickButtonLabel();

  @override
  Widget build(BuildContext context) {
    final parent = context
        .findAncestorWidgetOfExactType<DashboardQuickButton>();
    return Text(
      parent?.label ?? '',
      textAlign: TextAlign.center,
      style: const TextStyle(
        fontSize: 11,
        fontWeight: FontWeight.bold,
        color: PorterUiTokens.strongText,
      ),
    );
  }
}
