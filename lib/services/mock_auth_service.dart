import 'package:flutter/foundation.dart';

import 'auth_service.dart';

/// Offline stand-in for the real backend, used until the API is available.
///
/// Every call succeeds after a short delay, except [verifyResetCode], which
/// only accepts [demoVerificationCode].
class MockAuthService implements AuthService {
  MockAuthService({this.latency = const Duration(milliseconds: 800)});

  /// The only code accepted by [verifyResetCode].
  static const String demoVerificationCode = '1234';

  /// Simulated network delay.
  final Duration latency;

  Future<void> _simulateNetwork() => Future<void>.delayed(latency);

  @override
  Future<void> signIn({required String email, required String password}) {
    return _simulateNetwork();
  }

  @override
  Future<void> signUp({
    required String firstName,
    required String secondName,
    required String email,
    required String phone,
    required String password,
  }) {
    return _simulateNetwork();
  }

  @override
  Future<void> requestPasswordReset({required String email}) async {
    await _simulateNetwork();
    debugPrint('[MockAuthService] Code for $email: $demoVerificationCode');
  }

  @override
  Future<void> verifyResetCode({
    required String email,
    required String code,
  }) async {
    await _simulateNetwork();
    if (code != demoVerificationCode) {
      throw const AuthException('The code you entered is incorrect.');
    }
  }

  @override
  Future<void> resetPassword({
    required String email,
    required String code,
    required String newPassword,
  }) {
    return _simulateNetwork();
  }
}
