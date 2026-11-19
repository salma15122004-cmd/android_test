import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../constants/app_assets.dart';
import '../constants/app_colors.dart';
import '../services/prefs_service.dart';
import 'login_screen.dart';
import 'onboarding_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  static const Duration _splashDuration = Duration(seconds: 3);

  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer(_splashDuration, _goNext);
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  Future<void> _goNext() async {
    // Debug builds always show the onboarding so it is easy to test. Release
    // builds show it only on the first launch.
    final skipOnboarding = !kDebugMode && await PrefsService.isOnboardingSeen();
    if (!mounted) return;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) =>
            skipOnboarding ? const LoginScreen() : const OnboardingScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SizedBox(
          width: double.infinity,
          child: Column(
            children: [
              const Spacer(flex: 3),
              Image.asset(AppAssets.logo, width: 280, fit: BoxFit.contain),
              const SizedBox(height: 25),
              const CupertinoActivityIndicator(
                radius: 29,
                color: AppColors.navy,
              ),
              const Spacer(flex: 4),
            ],
          ),
        ),
      ),
    );
  }
}
