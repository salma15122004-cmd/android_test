import 'package:flutter/widgets.dart';

import '../services/auth_service.dart';
import '../widgets/app_snack_bar.dart';

/// Gives a screen a busy flag and consistent error handling for backend calls.
mixin GuardedActionMixin<T extends StatefulWidget> on State<T> {
  static const String _genericError = 'Something went wrong. Please try again.';

  /// True while an action started with [runGuarded] is running.
  bool isBusy = false;

  /// Runs [action] while [isBusy] is true.
  ///
  /// Returns true when the action finished without an error. Otherwise the
  /// error is shown in a snack bar and false is returned.
  Future<bool> runGuarded(Future<void> Function() action) async {
    if (isBusy) return false;
    setState(() => isBusy = true);
    try {
      await action();
      return true;
    } on AuthException catch (error) {
      _report(error.message);
    } on Exception {
      _report(_genericError);
    } finally {
      if (mounted) setState(() => isBusy = false);
    }
    return false;
  }

  void _report(String message) {
    if (mounted) showAppSnackBar(context, message);
  }
}
