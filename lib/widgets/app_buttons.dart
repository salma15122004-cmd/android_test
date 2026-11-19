import 'package:flutter/material.dart';

import '../constants/app_colors.dart';

const List<Shadow> _labelShadow = [
  Shadow(color: Colors.black26, blurRadius: 4, offset: Offset(0, 2)),
];

/// Full-width pill button with a trailing arrow.
///
/// While [isLoading] is true the button is disabled and shows a spinner.
class PrimaryButton extends StatelessWidget {
  const PrimaryButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.isLoading = false,
    this.color = AppColors.blue,
  });

  final String label;
  final VoidCallback onPressed;
  final bool isLoading;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: ShapeDecoration(
        shape: const StadiumBorder(),
        shadows: [
          BoxShadow(
            color: color.withValues(alpha: 0.35),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: SizedBox(
        width: double.infinity,
        height: 52,
        child: ElevatedButton(
          onPressed: isLoading ? null : onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: color,
            foregroundColor: Colors.white,
            disabledBackgroundColor: color.withValues(alpha: 0.7),
            disabledForegroundColor: Colors.white,
            elevation: 0,
            shape: const StadiumBorder(),
          ),
          child: isLoading
              ? const _ButtonSpinner()
              : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      label,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        shadows: _labelShadow,
                      ),
                    ),
                    const SizedBox(width: 10),
                    const Icon(Icons.arrow_forward, size: 20),
                  ],
                ),
        ),
      ),
    );
  }
}

/// Rounded-rectangle button used for the main action of a screen.
///
/// While [isLoading] is true the button is disabled and shows a spinner.
class ActionButton extends StatelessWidget {
  const ActionButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.isLoading = false,
  });

  final String label;
  final VoidCallback onPressed;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: AppColors.actionBlue.withValues(alpha: 0.35),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.actionBlue,
          foregroundColor: Colors.white,
          disabledBackgroundColor: AppColors.actionBlue.withValues(alpha: 0.7),
          disabledForegroundColor: Colors.white,
          elevation: 0,
          minimumSize: const Size(220, 54),
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
        child: isLoading
            ? const _ButtonSpinner()
            : Text(
                label,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  shadows: _labelShadow,
                ),
              ),
      ),
    );
  }
}

class _ButtonSpinner extends StatelessWidget {
  const _ButtonSpinner();

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      width: 22,
      height: 22,
      child: CircularProgressIndicator(strokeWidth: 2.5, color: Colors.white),
    );
  }
}
