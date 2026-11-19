import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../widgets/auth_widgets.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final _firstName = TextEditingController();
  final _secondName = TextEditingController();
  final _email = TextEditingController();
  final _phone = TextEditingController();
  final _password = TextEditingController();
  final _confirm = TextEditingController();

  void _submit() {
    if (_formKey.currentState!.validate()) {
       //الربط هنا مع الباك إند
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Account created')));
    }
  }

  @override
  void dispose() {
    for (final c in [_firstName, _secondName, _email, _phone, _password, _confirm]) {
      c.dispose();
    }
    super.dispose();
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
                const Text('Create Your Account',
                    style: TextStyle(
                        fontSize: 24, fontWeight: FontWeight.bold, color: navy)),
                const Text(
                    "Join Bright Step and be part of your child's progress journey.",
                    style: TextStyle(color: blue, fontWeight: FontWeight.w600)),
                const SizedBox(height: 16),
                CustomTextField(
                    hint: 'First Name',
                    icon: Icons.person_outline,
                    controller: _firstName,
                    validator: requiredField),
                const SizedBox(height: 12),
                CustomTextField(
                    hint: 'Last Name',
                    icon: Icons.person_outline,
                    controller: _secondName,
                    validator: requiredField),
                const SizedBox(height: 12),
                CustomTextField(
                    hint: 'Email Address',
                    icon: Icons.email_outlined,
                    controller: _email,
                    keyboardType: TextInputType.emailAddress,
                    validator: emailField),
                const SizedBox(height: 12),
                CustomTextField(
                    hint: 'Phone Number',
                    icon: Icons.phone_outlined,
                    controller: _phone,
                    keyboardType: TextInputType.phone,
                    validator: phoneField),
                const SizedBox(height: 12),
                CustomTextField(
                    hint: 'Password',
                    icon: Icons.lock_outline,
                    controller: _password,
                    isPassword: true,
                    validator: passwordField),
                const SizedBox(height: 12),
                CustomTextField(
                  hint: 'Confirm Password',
                  icon: Icons.lock_outline,
                  controller: _confirm,
                  isPassword: true,
                  validator: (v) =>
                      v != _password.text ? 'Passwords do not match' : null,
                ),
                const SizedBox(height: 20),
                PrimaryButton(label: 'Sign Up', onPressed: _submit),
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