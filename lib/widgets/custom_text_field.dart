import 'package:flutter/material.dart';

import '../constants/app_colors.dart';

/// Rounded text field with a leading icon. Password fields get a toggle that
/// shows or hides the text.
class CustomTextField extends StatefulWidget {
  const CustomTextField({
    super.key,
    required this.hint,
    required this.icon,
    required this.controller,
    this.isPassword = false,
    this.keyboardType = TextInputType.text,
    this.validator,
  });

  final String hint;
  final IconData icon;
  final TextEditingController controller;
  final bool isPassword;
  final TextInputType keyboardType;
  final FormFieldValidator<String>? validator;

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool _hidden = true;

  OutlineInputBorder _border(Color color) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(30),
      borderSide: BorderSide(color: color),
    );
  }

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
        suffixIcon: widget.isPassword ? _buildVisibilityToggle() : null,
        contentPadding: const EdgeInsets.symmetric(vertical: 14),
        enabledBorder: _border(AppColors.lightBorder),
        focusedBorder: _border(AppColors.blue),
        errorBorder: _border(Colors.red),
        focusedErrorBorder: _border(Colors.red),
      ),
    );
  }

  Widget _buildVisibilityToggle() {
    return IconButton(
      icon: Icon(
        _hidden ? Icons.visibility_outlined : Icons.visibility_off_outlined,
        size: 20,
      ),
      onPressed: () => setState(() => _hidden = !_hidden),
    );
  }
}
