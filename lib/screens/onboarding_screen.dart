import 'package:flutter/material.dart';

import '../constants/app_assets.dart';
import '../constants/app_colors.dart';
import '../services/prefs_service.dart';
import 'login_screen.dart';

class OnboardingPageData {
  const OnboardingPageData({
    required this.image,
    required this.title,
    required this.subtitle,
    required this.description,
  });

  final String image;
  final String title;
  final String subtitle;
  final String description;
}

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  static const List<OnboardingPageData> _pages = [
    OnboardingPageData(
      image: AppAssets.onboarding1,
      title: 'Support Every',
      subtitle: 'Step',
      description: 'Helping children grow,\nlearn and thrive.',
    ),
    OnboardingPageData(
      image: AppAssets.onboarding2,
      title: 'Speech Therapy',
      subtitle: 'Made Easier',
      description: "Supporting your child's\ncommunication skills.",
    ),
    OnboardingPageData(
      image: AppAssets.onboarding3,
      title: 'Unlock Their',
      subtitle: 'Full Potential',
      description:
          "Discover tailored exercises\nto unlock your child's\n"
          'communication potential',
    ),
  ];

  final PageController _controller = PageController();
  int _currentPage = 0;

  bool get _isLastPage => _currentPage == _pages.length - 1;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _next() {
    if (_isLastPage) {
      _finish();
      return;
    }
    _controller.nextPage(
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInOut,
    );
  }

  Future<void> _finish() async {
    // Remember that the onboarding was seen so it is not shown again.
    await PrefsService.setOnboardingSeen();
    if (!mounted) return;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const LoginScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: _finish,
                child: const Text(
                  'Skip',
                  style: TextStyle(
                    color: AppColors.teal,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            Expanded(
              child: PageView.builder(
                controller: _controller,
                itemCount: _pages.length,
                onPageChanged: (index) => setState(() => _currentPage = index),
                itemBuilder: (context, index) {
                  return _OnboardingPage(data: _pages[index]);
                },
              ),
            ),
            _buildBottomPanel(),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomPanel() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 32),
      decoration: BoxDecoration(
        color: AppColors.lightBlue,
        borderRadius: const BorderRadius.only(topRight: Radius.circular(90)),
        border: Border.all(
          color: AppColors.navy.withValues(alpha: 0.35),
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.3),
            blurRadius: 13,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              for (var i = 0; i < _pages.length; i++)
                AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  margin: const EdgeInsets.symmetric(horizontal: 5),
                  width: 10,
                  height: 10,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: i == _currentPage ? AppColors.navy : AppColors.teal,
                  ),
                ),
            ],
          ),
          const SizedBox(height: 28),
          SizedBox(
            width: 180,
            height: 46,
            child: ElevatedButton(
              onPressed: _next,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.navy,
                foregroundColor: Colors.white,
                shape: const StadiumBorder(),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    _isLastPage ? 'Get Started' : 'Next',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  if (_isLastPage) ...[
                    const SizedBox(width: 8),
                    const Icon(Icons.arrow_forward, size: 18),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _OnboardingPage extends StatelessWidget {
  const _OnboardingPage({required this.data});

  final OnboardingPageData data;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // The image shrinks on small screens instead of overflowing.
          Flexible(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxHeight: 280),
              child: Image.asset(data.image, fit: BoxFit.contain),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            data.title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: AppColors.navy,
            ),
          ),
          Text(
            data.subtitle,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w600,
              color: AppColors.teal,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            data.description,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 14, color: AppColors.teal),
          ),
        ],
      ),
    );
  }
}
