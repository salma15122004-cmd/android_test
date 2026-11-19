import 'package:flutter/material.dart';

import '../constants/app_colors.dart';
import '../services/service_locator.dart';
import '../utils/guarded_action.dart';
import '../utils/validators.dart';
import '../widgets/app_buttons.dart';
import '../widgets/app_snack_bar.dart';
import '../widgets/auth_widgets.dart';
import '../widgets/custom_text_field.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> with GuardedActionMixin {
  final _formKey = GlobalKey<FormState>();
  final _firstName = TextEditingController();
  final _secondName = TextEditingController();
  final _email = TextEditingController();
  final _phone = TextEditingController();
  final _password = TextEditingController();
  final _confirmPassword = TextEditingController();

  @override
  void dispose() {
    _firstName.dispose();
    _secondName.dispose();
    _email.dispose();
    _phone.dispose();
    _password.dispose();
    _confirmPassword.dispose();
    super.dispose();
  }

  Future<void> _signUp() async {
    if (!_formKey.currentState!.validate()) return;

    final created = await runGuarded(
      () => authService.signUp(
        firstName: _firstName.text.trim(),
        secondName: _secondName.text.trim(),
        email: _email.text.trim(),
        phone: _phone.text.trim(),
        password: _password.text,
      ),
    );
    if (!created || !mounted) return;

    showAppSnackBar(context, 'Account created. Please sign in.');
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                IconButton(
                  padding: EdgeInsets.zero,
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () => Navigator.pop(context),
                ),
                const Center(child: AuthHeader()),
                const SizedBox(height: 16),
                const Text(
                  'Create Your Account',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: AppColors.navy,
                  ),
                ),
                const Text(
                  "Join Bright Steps and be part of your child's progress "
                  'journey.',
                  style: TextStyle(
                    color: AppColors.blue,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 16),
                CustomTextField(
                  hint: 'First Name',
                  icon: Icons.person_outline,
                  controller: _firstName,
                  validator: Validators.requiredField,
                ),
                const SizedBox(height: 12),
                CustomTextField(
                    hint: 'Last Name',
                    icon: Icons.person_outline,
                    controller: _secondName,
                    validator: Validators.requiredField),
                const SizedBox(height: 12),
                CustomTextField(
                  hint: 'Email Address',
                  icon: Icons.email_outlined,
                  controller: _email,
                  keyboardType: TextInputType.emailAddress,
                  validator: Validators.email,
                ),
                const SizedBox(height: 12),
                CustomTextField(
                  hint: 'Phone Number',
                  icon: Icons.phone_outlined,
                  controller: _phone,
                  keyboardType: TextInputType.phone,
                  validator: Validators.phone,
                ),
                const SizedBox(height: 12),
                CustomTextField(
                  hint: 'Password',
                  icon: Icons.lock_outline,
                  controller: _password,
                  isPassword: true,
                  validator: Validators.password,
                ),
                const SizedBox(height: 12),
                CustomTextField(
                  hint: 'Confirm Password',
                  icon: Icons.lock_outline,
                  controller: _confirmPassword,
                  isPassword: true,
                  validator: Validators.confirmPassword(() => _password.text),
                ),
                const SizedBox(height: 20),
                PrimaryButton(
                  label: 'Sign Up',
                  isLoading: isBusy,
                  onPressed: _signUp,
                ),
                const SizedBox(height: 12),
                const OrDivider(),
                const SizedBox(height: 8),
                BottomLink(
                  text: 'Already have an account?',
                  action: 'Sign In',
                  onTap: () => Navigator.pop(context),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
