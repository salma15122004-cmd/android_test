import 'package:flutter/material.dart';

import '../constants/app_colors.dart';
import '../widgets/app_buttons.dart';
import '../widgets/screen_text.dart';
import 'login_screen.dart';

/// Confirmation shown after the password was changed.
class PasswordResetSuccessScreen extends StatelessWidget {
  const PasswordResetSuc
  void _goToSignIn(BuildContext context) {
    // Clear the whole reset flow so the back button cannot return to it.
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const LoginScreen()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(24, 60, 24, 24),
          child: SizedBox(
            width: double.infinity,
            child: Column(
              children: [
                const _SuccessBadge(),
                const SizedBox(height: 32),
                const ScreenTitle('Password Reset\nSuccessful'),
                const SizedBox(height: 10),
                const ScreenSubtitle(
                  'Your Password has been successfully\nchanged.',
                ),
                const SizedBox(height: 32),
                ActionButton(
                  label: 'Continue to Sign In',
                  onPressed: () => _goToSignIn(context),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Green check badge drawn in code, so it needs no image asset.
class _SuccessBadge extends StatelessWidget {
  const _SuccessBadge();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 140,
      height: 140,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.successLight, AppColors.successDark],
        ),
        border: Border.all(color: AppColors.successRing, width: 6),
        boxShadow: [
          BoxShadow(
            color: AppColors.success.withValues(alpha: 0.35),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: const Icon(Icons.check_rounded, size: 96, color: Colors.white),
    );
  }
}
