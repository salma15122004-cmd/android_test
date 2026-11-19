import 'package:flutter/material.dart';

import '../constants/app_assets.dart';
import '../constants/app_colors.dart';

/// Logo and tagline shown at the top of the sign in and sign up screens.
class AuthHeader extends StatelessWidget {
  const AuthHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Image.asset(AppAssets.logo, width: 200),
        const Text(
          'Every child deserves\na brighter future',
          textAlign: TextAlign.center,
          style: TextStyle(color: AppColors.teal, fontWeight: FontWeight.w600),
        ),
      ],
    );
  }
}

/// Horizontal divider with the word "or" in the middle.
class OrDivider extends StatelessWidget {
  const OrDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return const Row(
      children: [
        Expanded(child: Divider(color: Colors.black87)),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 12),
          child: Text('or'),
        ),
        Expanded(child: Divider(color: Colors.black87)),
      ],
    );
  }
}

/// A line of text followed by a tappable action, e.g. "Already have an
/// account? Sign In".
class BottomLink extends StatelessWidget {
  const BottomLink({
    super.key,
    required this.text,
    required this.action,
    required this.onTap,
  });

  final String text;
  final String action;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(text, style: const TextStyle(color: Colors.grey, fontSize: 13)),
        const SizedBox(width: 6),
        InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(4),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 2),
            child: Text(
              action,
              style: const TextStyle(
                color: AppColors.blue,
                fontWeight: FontWeight.bold,
                fontSize: 13,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
