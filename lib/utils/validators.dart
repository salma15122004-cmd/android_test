import 'package:flutter/widgets.dart';

/// Form field validators. Each returns an error message, or null when the
/// value is valid.
abstract final class Validators {
  static const int minPasswordLength = 6;

  static final RegExp _emailPattern = RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]{2,}$');
  static final RegExp _phonePattern = RegExp(r'^\+?[0-9]{8,15}$');

  static String? requiredField(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'This field is required';
    }
    return null;
  }

  static String? email(String? value) {
    if (value == null || !_emailPattern.hasMatch(value.trim())) {
      return 'Enter a valid email';
    }
    return null;
  }

  static String? password(String? value) {
    if (value == null || value.length < minPasswordLength) {
      return 'At least $minPasswordLength characters';
    }
    return null;
  }

  static String? phone(String? value) {
    final digits = value?.replaceAll(RegExp(r'[\s-]'), '') ?? '';
    if (digits.isEmpty) return 'This field is required';
    if (!_phonePattern.hasMatch(digits)) return 'Enter a valid phone number';
    return null;
  }

  /// Checks that the field matches the password returned by [original].
  static FormFieldValidator<String> confirmPassword(
    String Function() original,
  ) {
    return (value) => value == original() ? null : 'Passwords do not match';
  }
}
