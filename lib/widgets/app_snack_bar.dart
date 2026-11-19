import 'package:flutter/material.dart';

/// Shows [message] in a snack bar, replacing any snack bar already visible.
void showAppSnackBar(BuildContext context, String message) {
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(SnackBar(content: Text(message)));
}
