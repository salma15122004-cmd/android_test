import 'package:flutter/material.dart';
import '../widgets/auth_widgets.dart';
import 'signup_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _email = TextEditingController();
  final _password = TextEditingController();
  bool _remember = true;

  void _submit() {
    if (_formKey.currentState!.validate()) {
      // TODO: اربطي هنا مع الباك إند
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Signed in')));
    }
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
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
                const Text('Welcome Back',
                    style: TextStyle(
                        fontSize: 26, fontWeight: FontWeight.bold, color: navy)),
                const Text("Log in to continue your child's journey",
                    style: TextStyle(color: blue, fontWeight: FontWeight.w600)),
                const SizedBox(height: 16),
                CustomTextField(
                  hint: 'Email Address',
                  icon: Icons.email_outlined,
                  controller: _email,
                  keyboardType: TextInputType.emailAddress,
                  validator: emailField,
                ),
                const SizedBox(height: 12),
                CustomTextField(
                  hint: 'Password',
                  icon: Icons.lock_outline,
                  controller: _password,
                  isPassword: true,
                  validator: passwordField,
                ),
                Row(
                  children: [
                    Checkbox(
                      value: _remember,
                      activeColor: blue,
                      onChanged: (v) => setState(() => _remember = v!),
                    ),
                    const Text('Remember me', style: TextStyle(fontSize: 13)),
                    const Spacer(),
                    TextButton(
                      onPressed: () {}, // TODO: نسيت كلمة المرور
                      child: const Text('Forgot Password?',
                          style: TextStyle(color: blue, fontSize: 12)),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                PrimaryButton(label: 'Sign In', onPressed: _submit),
                const SizedBox(height: 12),
                const OrDivider(),
                const SizedBox(height: 8),
                BottomLink(
                  text: "Don't have an account?",
                  action: 'Sign Up',
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const SignUpScreen()),
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