import 'package:flutter/material.dart';

import '../constants/app_colors.dart';

/// Bold, centered screen heading with a soft shadow.
class ScreenTitle extends StatelessWidget {
  const ScreenTitle(this.text, {super.key});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: TextAlign.center,
      style: TextStyle(
        fontSize: 28,
        fontWeight: FontWeight.w800,
        height: 1.2,
        color: AppColors.navy,
        shadows: [
          Shadow(
            color: AppColors.navy.withValues(alpha: 0.3),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
    );
  }
}

/// Centered supporting text shown under a [ScreenTitle].
class ScreenSubtitle extends StatelessWidget {
  const ScreenSubtitle(this.text, {super.key, this.color = AppColors.softBlue});

  final String text;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: TextAlign.center,
      style: TextStyle(
        fontSize: 17,
        fontWeight: FontWeight.w700,
        height: 1.35,
        color: color,
      ),
    );
  }
}

/// Bold text button with a soft shadow. Pass a null [onPressed] to disable it.
class TextLinkButton extends StatelessWidget {
  const TextLinkButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.color = AppColors.blue,
    this.fontSize = 18,
  });

  final String label;
  final VoidCallback? onPressed;
  final Color color;
  final double fontSize;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      child: Text(
        label,
        style: TextStyle(
          fontSize: fontSize,
          fontWeight: FontWeight.w800,
          color: color,
          shadows: [
            Shadow(
              color: color.withValues(alpha: 0.35),
              blurRadius: 6,
              offset: const Offset(0, 3),
            ),
          ],
        ),
      ),
    );
  }
}
