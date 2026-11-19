import 'package:flutter/material.dart';

import 'constants/app_colors.dart';
import 'screens/splash_screen.dart';

void main() {
  runApp(const BrightStepsApp());
}

class BrightStepsApp extends StatelessWidget {
  const BrightStepsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bright Steps',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: AppColors.blue),
      ),
      home: const SplashScreen(),
    );
  }
}
