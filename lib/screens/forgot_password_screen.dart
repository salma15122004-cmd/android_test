import 'package:flutter/material.dart';

import '../constants/app_assets.dart';
import '../constants/app_colors.dart';
import '../services/service_locator.dart';
import '../utils/guarded_action.dart';
import '../utils/validators.dart';
import '../widgets/app_buttons.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/screen_text.dart';
import 'verify_code_screen.dart';

/// First step of the password reset flow: asks for the account email and
/// requests a verification code.
class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen>
    with GuardedActionMixin {
  final _formKey = GlobalKey<FormState>();
  final _email = TextEditingController();

  @override
  void dispose() {
    _email.dispose();
    super.dispose();
  }

  Future<void> _sendCode() async {
    if (!_formKey.currentState!.validate()) return;
    final email = _email.text.trim();

    final sent = await runGuarded(
      () => authService.requestPasswordReset(email: email),
    );
    if (!sent || !mounted) return;

    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => VerifyCodeScreen(email: email)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.asset(AppAssets.logo, width: 90),
                IconButton(
                  alignment: Alignment.centerLeft,
                  padding: EdgeInsets.zero,
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () => Navigator.pop(context),
                ),
                const SizedBox(height: 8),
                const Center(child: ScreenTitle('Forgot Password?')),
                const SizedBox(height: 16),
                Center(
                  child: Image.asset(AppAssets.forgotPasswordKey, height: 220),
                ),
                const SizedBox(height: 16),
                const Center(
                  child: ScreenSubtitle(
                    'Enter Your email address to reset Your Password.',
                    color: AppColors.teal,
                  ),
                ),
                const SizedBox(height: 28),
                CustomTextField(
                  hint: 'Email Address',
                  icon: Icons.mail_outline,
                  controller: _email,
                  keyboardType: TextInputType.emailAddress,
                  validator: Validators.email,
                ),
                const SizedBox(height: 24),
                PrimaryButton(
                  label: 'Send Code',
                  isLoading: isBusy,
                  onPressed: _sendCode,
                ),
                const SizedBox(height: 12),
                Center(
                  child: TextLinkButton(
                    label: 'Back to Sign In',
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
