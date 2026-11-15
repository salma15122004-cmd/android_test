import 'package:flutter/material.dart';

// الألوان
const navy = Color(0xFF163A7A);
const teal = Color(0xFF2E9CCA);
const blue = Color(0xFF1E90FF);
const lightBorder = Color(0xFFBFDDF2);

// التحققات (validators)
String? requiredField(String? v) =>
    (v == null || v.trim().isEmpty) ? 'This field is required' : null;

String? emailField(String? v) =>
    (v == null || !v.contains('@') || !v.contains('.'))
        ? 'Enter a valid email'
        : null;

String? passwordField(String? v) =>
    (v == null || v.length < 6) ? 'At least 6 characters' : null;

// اللوجو + الجملة
class AuthHeader extends StatelessWidget {
  const AuthHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Image.asset('assets_img/logo.png', width: 200),
        const Text(
          'Every child deserves\na brighter future',
          textAlign: TextAlign.center,
          style: TextStyle(color: teal, fontWeight: FontWeight.w600),
        ),
      ],
    );
  }
}

// الحقل
class CustomTextField extends StatefulWidget {
  final String hint;
  final IconData icon;
  final TextEditingController controller;
  final bool isPassword;
  final TextInputType keyboardType;
  final String? Function(String?)? validator;

  const CustomTextField({
    super.key,
    required this.hint,
    required this.icon,
    required this.controller,
    this.isPassword = false,
    this.keyboardType = TextInputType.text,
    this.validator,
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool _hidden = true;

  OutlineInputBorder _border(Color c) => OutlineInputBorder(
    borderRadius: BorderRadius.circular(30),
    borderSide: BorderSide(color: c),
  );

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      obscureText: widget.isPassword && _hidden,
      keyboardType: widget.keyboardType,
      validator: widget.validator,
      decoration: InputDecoration(
        hintText: widget.hint,
        hintStyle: const TextStyle(color: Colors.grey, fontSize: 13),
        prefixIcon: Icon(widget.icon, size: 20),
        suffixIcon: widget.isPassword
            ? IconButton(
          icon: Icon(
            _hidden ? Icons.visibility_outlined : Icons.visibility_off_outlined,
            size: 20,
          ),
          onPressed: () => setState(() => _hidden = !_hidden),
        )
            : null,
        contentPadding: const EdgeInsets.symmetric(vertical: 14),
        enabledBorder: _border(lightBorder),
        focusedBorder: _border(blue),
        errorBorder: _border(Colors.red),
        focusedErrorBorder: _border(Colors.red),
      ),
    );
  }
}

// الزرار الأزرق
class PrimaryButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;

  const PrimaryButton({super.key, required this.label, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 48,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: blue,
          foregroundColor: Colors.white,
          shape: const StadiumBorder(),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(label,
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(width: 8),
            const Icon(Icons.arrow_forward, size: 18),
          ],
        ),
      ),
    );
  }
}

// خط "or"
class OrDivider extends StatelessWidget {
  const OrDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return const Row(
      children: [
        Expanded(child: Divider(color: Colors.black87)),
        Padding(padding: EdgeInsets.symmetric(horizontal: 12), child: Text('or')),
        Expanded(child: Divider(color: Colors.black87)),
      ],
    );
  }
}

// "Already have an account? Sign In"
class BottomLink extends StatelessWidget {
  final String text;
  final String action;
  final VoidCallback onTap;

  const BottomLink({
    super.key,
    required this.text,
    required this.action,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(text, style: const TextStyle(color: Colors.grey, fontSize: 13)),
        const SizedBox(width: 6),
        GestureDetector(
          onTap: onTap,
          child: Text(
            action,
            style: const TextStyle(
                color: blue, fontWeight: FontWeight.bold, fontSize: 13),
          ),
        ),
      ],
    );
  }
}