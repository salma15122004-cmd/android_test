import 'package:flutter/material.dart';

import '../constants/app_colors.dart';
import '../services/prefs_service.dart';
import '../services/service_locator.dart';
import '../utils/guarded_action.dart';
import '../utils/validators.dart';
import '../widgets/app_buttons.dart';
import '../widgets/app_snack_bar.dart';
import '../widgets/auth_widgets.dart';
import '../widgets/custom_text_field.dart';
import 'forgot_password_screen.dart';
import 'signup_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> with GuardedActionMixin {
  final _formKey = GlobalKey<FormState>();
  final _email = TextEditingController();
  final _password = TextEditingController();
  bool _remember = false;

  @override
  void initState() {
    super.initState();
    _loadRememberedEmail();
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  /// Restores the email saved by "Remember me", if any.
  Future<void> _loadRememberedEmail() async {
    final remember = await PrefsService.getRemember();
    final email = await PrefsService.getSavedEmail();
    if (!mounted) return;
    setState(() {
      _remember = remember;
      _email.text = email;
    });
  }

  Future<void> _signIn() async {
    if (!_formKey.currentState!.validate()) return;
    final email = _email.text.trim();
    final password = _password.text;

    final signedIn = await runGuarded(
      () => authService.signIn(email: email, password: password),
    );
    if (!signedIn) return;

    await PrefsService.saveRemember(remember: _remember, email: email);
    if (!mounted) return;
    // Navigate to the home screen here once it exists.
    showAppSnackBar(context, 'Signed in');
  }

  void _openForgotPassword() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const ForgotPasswordScreen()),
    );
  }

  void _openSignUp() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const SignUpScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 16),
                const Center(child: AuthHeader()),
                const SizedBox(height: 24),
                const Text(
                  'Welcome Back',
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: AppColors.navy,
                  ),
                ),
                const Text(
                  "Log in to continue your child's journey",
                  style: TextStyle(
                    color: AppColors.blue,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 16),
                CustomTextField(
                  hint: 'Email Address',
                  icon: Icons.email_outlined,
                  controller: _email,
                  keyboardType: TextInputType.emailAddress,
                  validator: Validators.email,
                ),
                const SizedBox(height: 12),
                CustomTextField(
                  hint: 'Password',
                  icon: Icons.lock_outline,
                  controller: _password,
                  isPassword: true,
                  validator: Validators.password,
                ),
                Row(
                  children: [
                    Checkbox(
                      value: _remember,
                      activeColor: AppColors.blue,
                      onChanged: (value) =>
                          setState(() => _remember = value ?? false),
                    ),
                    const Text('Remember me', style: TextStyle(fontSize: 13)),
                    const Spacer(),
                    TextButton(
                      onPressed: _openForgotPassword,
                      child: const Text(
                        'Forgot Password?',
                        style: TextStyle(color: AppColors.blue, fontSize: 12),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                PrimaryButton(
                  label: 'Sign In',
                  isLoading: isBusy,
                  onPressed: _signIn,
                ),
                const SizedBox(height: 12),
                const OrDivider(),
                const SizedBox(height: 8),
                BottomLink(
                  text: "Don't have an account?",
                  action: 'Sign Up',
                  onTap: _openSignUp,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
