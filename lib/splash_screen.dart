import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';
import 'onboarding_screen.dart';
import 'package:flutter/cupertino.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer(const Duration(seconds: 15), () {
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const OnboardingScreen()),
      );
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SizedBox(
          width:  double.infinity,
          child: Column(
          crossAxisAlignment:CrossAxisAlignment.center,
          children: [
            const Spacer(flex: 3),
            Center(
              child:
            Image.asset('assets_img/logo.png', width: 280,fit: BoxFit.contain,),),
            const SizedBox(height: 25),
            const  CupertinoActivityIndicator (radius:29,color: Color(0xFF1E4FBF)),
            const Spacer(flex: 4),
          ],
        ),
      ),
    ),
    );
  }
}