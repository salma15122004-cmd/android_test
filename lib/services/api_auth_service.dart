import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import 'auth_service.dart';
import 'mock_auth_service.dart';

/// [AuthService] that talks to the PHP backend.
///
/// Sign in and sign up use the real database. The password reset steps have no
/// backend endpoints yet, so they are delegated to [passwordResetFallback].
class ApiAuthService implements AuthService {
  ApiAuthService({
    required this.baseUrl,
    http.Client? client,
    AuthService? passwordResetFallback,
  }) : _client = client ?? http.Client(),
       passwordResetFallback = passwordResetFallback ?? MockAuthService();

  /// Address of the backend project, without a trailing slash.
  final String baseUrl;

  /// Handles the password reset steps until the backend supports them.
  final AuthService passwordResetFallback;

  final http.Client _client;

  /// The sign up form has no governorate field yet, so every account is
  /// created in governorate 1 (Cairo).
  static const int _defaultGovernorateId = 1;

  static const Duration _timeout = Duration(seconds: 15);

  @override
  Future<void> signIn({required String email, required String password}) async {
    await _post('register/login.php', {'Email': email, 'Password': password});
  }

  @override
  Future<void> signUp({
    required String firstName,
    required String secondName,
    required String email,
    required String phone,
    required String password,
  }) async {
    await _post('register/register.php', {
      'Full_Name': '$firstName $secondName'.trim(),
      'Email': email,
      'Password': password,
      'Phone': phone,
      'Gov_ID': _defaultGovernorateId,
    });
  }

  @override
  Future<void> requestPasswordReset({required String email}) {
    return passwordResetFallback.requestPasswordReset(email: email);
  }

  @override
  Future<void> verifyResetCode({required String email, required String code}) {
    return passwordResetFallback.verifyResetCode(email: email, code: code);
  }

  @override
  Future<void> resetPassword({
    required String email,
    required String code,
    required String newPassword,
  }) {
    return passwordResetFallback.resetPassword(
      email: email,
      code: code,
      newPassword: newPassword,
    );
  }

  /// Sends [body] as JSON to [path] and returns the decoded response.
  ///
  /// Throws an [AuthException] when the server cannot be reached, when its
  /// response is not valid JSON, or when it reports a failure.
  Future<Map<String, dynamic>> _post(
    String path,
    Map<String, Object> body,
  ) async {
    final response = await _send(Uri.parse('$baseUrl/$path'), body);
    final result = _decode(response);

    if (result['success'] == true) return result;

    final message = result['message'];
    throw AuthException(
      message is String && message.isNotEmpty
          ? message
          : 'The request failed (${response.statusCode}).',
    );
  }

  Future<http.Response> _send(Uri uri, Map<String, Object> body) async {
    try {
      return await _client
          .post(
            uri,
            headers: const {'Content-Type': 'application/json'},
            body: jsonEncode(body),
          )
          .timeout(_timeout);
    } on Exception catch (error) {
      debugPrint('[ApiAuthService] Request to $uri failed: $error');
      throw AuthException(_unreachableMessage);
    }
  }

  Map<String, dynamic> _decode(http.Response response) {
    try {
      final decoded = jsonDecode(utf8.decode(response.bodyBytes));
      if (decoded is Map<String, dynamic>) return decoded;
    } on FormatException {
      // Not JSON, handled below.
    }
    // Usually a PHP error or warning printed before the JSON.
    debugPrint(
      '[ApiAuthService] Unexpected response (${response.statusCode}): '
      '${response.body}',
    );
    throw const AuthException('The server sent an unexpected response.');
  }

  String get _unreachableMessage {
    if (kDebugMode) {
      return 'Cannot reach the server at $baseUrl. Check that XAMPP is '
          'running and that ApiConfig.host is correct.';
    }
    return 'Cannot reach the server. Please check your connection.';
  }
}
