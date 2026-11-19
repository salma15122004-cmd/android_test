/// An error reported by the authentication backend.
///
/// [message] is written for end users and can be shown as is.
class AuthException implements Exception {
  const AuthException(this.message);

  final String message;

  @override
  String toString() => 'AuthException: $message';
}

/// Everything the UI needs from the authentication backend.
///
/// Implementations should throw [AuthException] for expected failures such as
/// wrong credentials or an invalid code. Any other exception is treated as an
/// unexpected error and shown to the user as a generic message.
abstract interface class AuthService {
  /// Signs the user in. Storing the session token is up to the implementation.
  Future<void> signIn({required String email, required String password});

  /// Creates a new account.
  Future<void> signUp({
    required String firstName,
    required String secondName,
    required String email,
    required String phone,
    required String password,
  });

  /// Sends a verification code to [email]. Also used to resend the code.
  Future<void> requestPasswordReset({required String email});

  /// Checks the code that was sent to [email].
  Future<void> verifyResetCode({required String email, required String code});

  /// Sets a new password. [code] is the code that was already verified.
  Future<void> resetPassword({
    required String email,
    required String code,
    required String newPassword,
  });
}
