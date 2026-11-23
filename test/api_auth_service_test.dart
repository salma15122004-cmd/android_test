import 'dart:convert';

import 'package:android_test/services/api_auth_service.dart';
import 'package:android_test/services/auth_service.dart';
import 'package:android_test/services/mock_auth_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

const String _baseUrl = 'http://test.local/childtherapy';

http.Response _jsonResponse(Map<String, Object?> body, int status) {
  return http.Response.bytes(
    utf8.encode(jsonEncode(body)),
    status,
    headers: {'content-type': 'application/json; charset=utf-8'},
  );
}

ApiAuthService _serviceWith(MockClientHandler handler) {
  return ApiAuthService(
    baseUrl: _baseUrl,
    client: MockClient(handler),
    passwordResetFallback: MockAuthService(latency: Duration.zero),
  );
}

Matcher _authExceptionWith(String message) {
  return throwsA(
    isA<AuthException>().having((e) => e.message, 'message', message),
  );
}

void main() {
  group('signIn', () {
    test('posts the credentials to login.php', () async {
      late http.Request sent;
      final service = _serviceWith((request) async {
        sent = request;
        return _jsonResponse({
          'success': true,
          'message': 'Login successful',
        }, 200);
      });

      await service.signIn(email: 'user@example.com', password: 'secret1');

      expect(sent.method, 'POST');
      expect(sent.url.toString(), '$_baseUrl/register/login.php');
      expect(sent.headers['Content-Type'], 'application/json');
      expect(jsonDecode(sent.body), {
        'Email': 'user@example.com',
        'Password': 'secret1',
      });
    });

    test('shows the server message for an unknown account', () {
      final service = _serviceWith((request) async {
        return _jsonResponse({
          'success': false,
          'message': 'Invalid email or password',
        }, 401);
      });

      expect(
        service.signIn(email: 'nobody@example.com', password: 'secret1'),
        _authExceptionWith('Invalid email or password'),
      );
    });
  });

  group('signUp', () {
    test('posts the new account to register.php', () async {
      late http.Request sent;
      final service = _serviceWith((request) async {
        sent = request;
        return _jsonResponse({'success': true, 'Parent_ID': '7'}, 201);
      });

      await service.signUp(
        firstName: 'Salma',
        secondName: 'Hossam',
        email: 'salma@example.com',
        phone: '01012345678',
        password: 'secret1',
      );

      expect(sent.url.toString(), '$_baseUrl/register/register.php');
      expect(jsonDecode(sent.body), {
        'Full_Name': 'Salma Hossam',
        'Email': 'salma@example.com',
        'Password': 'secret1',
        'Phone': '01012345678',
        'Gov_ID': 1,
      });
    });

    test('shows the server message when the email is taken', () {
      final service = _serviceWith((request) async {
        return _jsonResponse({
          'success': false,
          'message': 'This email is already registered',
        }, 409);
      });

      expect(
        service.signUp(
          firstName: 'Salma',
          secondName: 'Hossam',
          email: 'salma@example.com',
          phone: '01012345678',
          password: 'secret1',
        ),
        _authExceptionWith('This email is already registered'),
      );
    });
  });

  group('errors', () {
    test('turns a network failure into an AuthException', () {
      final service = _serviceWith((request) async {
        throw http.ClientException('connection refused');
      });

      expect(
        service.signIn(email: 'user@example.com', password: 'secret1'),
        throwsA(isA<AuthException>()),
      );
    });

    test('turns a response that is not JSON into an AuthException', () {
      final service = _serviceWith((request) async {
        return http.Response('<b>Warning</b>: something broke', 200);
      });

      expect(
        service.signIn(email: 'user@example.com', password: 'secret1'),
        _authExceptionWith('The server sent an unexpected response.'),
      );
    });
  });

  group('password reset', () {
    test('uses the fallback because the backend has no endpoint', () async {
      final service = _serviceWith((request) async {
        fail('The password reset steps must not call the backend yet.');
      });

      await service.requestPasswordReset(email: 'user@example.com');
      await service.verifyResetCode(
        email: 'user@example.com',
        code: MockAuthService.demoVerificationCode,
      );
      await service.resetPassword(
        email: 'user@example.com',
        code: MockAuthService.demoVerificationCode,
        newPassword: 'secret2',
      );
    });
  });
}
