import 'package:flutter/material.dart';

import '../constants/app_assets.dart';
import '../services/service_locator.dart';
import '../utils/guarded_action.dart';
import '../utils/validators.dart';
import '../widgets/app_buttons.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/screen_text.dart';
import 'password_reset_success_screen.dart';

/// Last step of the password reset flow: sets the new password for [email]
/// using the already verified [code].
class CreateNewPasswordScreen extends StatefulWidget {
  const CreateNewPasswordScreen({
    super.key,
    required this.email,
    required this.code,
  });

  final String email;
  final String code;

  @override
  State<CreateNewPasswordScreen> createState() =>
      _CreateNewPasswordScreenState();
}

class _CreateNewPasswordScreenState extends State<CreateNewPasswordScreen>
    with GuardedActionMixin {
  final _formKey = GlobalKey<FormState>();
  final _password = TextEditingController();
  final _confirmPassword = TextEditingController();

  @override
  void dispose() {
    _password.dispose();
    _confirmPassword.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    final newPassword = _password.text;

    final saved = await runGuarded(
      () => authService.resetPassword(
        email: widget.email,
        code: widget.code,
        newPassword: newPassword,
      ),
    );
    if (!saved || !mounted) return;

    // Replace this screen so the back button cannot return to the form.
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const PasswordResetSuccessScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(24, 40, 24, 24),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Image.asset(AppAssets.lockPassword, width: 170),
                const SizedBox(height: 28),
                const ScreenTitle('Create New Password'),
                const SizedBox(height: 10),
                const ScreenSubtitle(
                  'Choose a Strong Password to Keep\nYour account safe',
                ),
                const SizedBox(height: 32),
                CustomTextField(
                  hint: 'New Password',
                  icon: Icons.lock_outline,
                  controller: _password,
                  isPassword: true,
                  validator: Validators.password,
                ),
                const SizedBox(height: 16),
                CustomTextField(
                  hint: 'Confirm Password',
                  icon: Icons.lock_outline,
                  controller: _confirmPassword,
                  isPassword: true,
                  validator: Validators.confirmPassword(() => _password.text),
                ),
                const SizedBox(height: 32),
                ActionButton(
                  label: 'Save Password',
                  isLoading: isBusy,
                  onPressed: _save,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
