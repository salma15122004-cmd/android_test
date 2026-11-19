import 'package:android_test/main.dart';
import 'package:android_test/screens/create_new_password_screen.dart';
import 'package:android_test/screens/forgot_password_screen.dart';
import 'package:android_test/screens/login_screen.dart';
import 'package:android_test/screens/onboarding_screen.dart';
import 'package:android_test/screens/password_reset_success_screen.dart';
import 'package:android_test/screens/signup_screen.dart';
import 'package:android_test/screens/splash_screen.dart';
import 'package:android_test/screens/verify_code_screen.dart';
import 'package:android_test/services/mock_auth_service.dart';
import 'package:android_test/services/service_locator.dart';
import 'package:android_test/widgets/code_input_boxes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

const String _email = 'user@example.com';

/// Makes the test surface phone-sized (390 x 844 logical pixels).
void _usePhoneSurface(WidgetTester tester) {
  tester.view.physicalSize = const Size(1170, 2532);
  tester.view.devicePixelRatio = 3;
  addTearDown(tester.view.reset);
}

/// Shows [screen] on a phone-sized surface and waits for it to settle.
Future<void> _pumpScreen(WidgetTester tester, Widget screen) async {
  _usePhoneSurface(tester);
  await tester.pumpWidget(MaterialApp(home: screen));
  await tester.pumpAndSettle();
}

Future<void> _tap(WidgetTester tester, Finder finder) async {
  await tester.ensureVisible(finder);
  await tester.pumpAndSettle();
  await tester.tap(finder);
  await tester.pumpAndSettle();
}

Future<void> _enterCode(WidgetTester tester, String code) async {
  for (final digit in code.split('')) {
    await _tap(tester, find.byKey(Key('keypad_$digit')));
  }
}

Finder _digitInBoxes(String digit) {
  return find.descendant(
    of: find.byType(CodeInputBoxes),
    matching: find.text(digit),
  );
}

void main() {
  setUp(() {
    authService = MockAuthService(latency: Duration.zero);
    SharedPreferences.setMockInitialValues({});
  });

  group('App', () {
    testWidgets('shows the splash screen and then the onboarding', (
      WidgetTester tester,
    ) async {
      _usePhoneSurface(tester);
      await tester.pumpWidget(const BrightStepsApp());
      expect(find.byType(SplashScreen), findsOneWidget);

      await tester.pump(const Duration(seconds: 3));
      await tester.pumpAndSettle();

      expect(find.byType(OnboardingScreen), findsOneWidget);
    });
  });

  group('LoginScreen', () {
    testWidgets('shows validation errors when the form is empty', (
      WidgetTester tester,
    ) async {
      await _pumpScreen(tester, const LoginScreen());

      await _tap(tester, find.text('Sign In'));

      expect(find.text('Enter a valid email'), findsOneWidget);
      expect(find.text('At least 6 characters'), findsOneWidget);
    });

    testWidgets('toggles password visibility', (WidgetTester tester) async {
      await _pumpScreen(tester, const LoginScreen());

      expect(find.byIcon(Icons.visibility_outlined), findsOneWidget);
      await _tap(tester, find.byIcon(Icons.visibility_outlined));

      expect(find.byIcon(Icons.visibility_off_outlined), findsOneWidget);
    });

    testWidgets('opens the forgot password screen', (
      WidgetTester tester,
    ) async {
      await _pumpScreen(tester, const LoginScreen());

      await _tap(tester, find.text('Forgot Password?'));

      expect(find.byType(ForgotPasswordScreen), findsOneWidget);
    });

    testWidgets('opens the sign up screen', (WidgetTester tester) async {
      await _pumpScreen(tester, const LoginScreen());

      await _tap(tester, find.text('Sign Up'));

      expect(find.byType(SignUpScreen), findsOneWidget);
    });
  });

  group('ForgotPasswordScreen', () {
    testWidgets('rejects an invalid email', (WidgetTester tester) async {
      await _pumpScreen(tester, const ForgotPasswordScreen());

      await tester.enterText(find.byType(TextFormField), 'not-an-email');
      await _tap(tester, find.text('Send Code'));

      expect(find.text('Enter a valid email'), findsOneWidget);
      expect(find.byType(VerifyCodeScreen), findsNothing);
    });

    testWidgets('opens the verification screen for a valid email', (
      WidgetTester tester,
    ) async {
      await _pumpScreen(tester, const ForgotPasswordScreen());

      await tester.enterText(find.byType(TextFormField), _email);
      await _tap(tester, find.text('Send Code'));

      expect(find.byType(VerifyCodeScreen), findsOneWidget);
    });
  });

  group('VerifyCodeScreen', () {
    testWidgets('shows typed digits and deletes the last one', (
      WidgetTester tester,
    ) async {
      await _pumpScreen(tester, const VerifyCodeScreen(email: _email));

      await _enterCode(tester, '12');
      expect(_digitInBoxes('1'), findsOneWidget);
      expect(_digitInBoxes('2'), findsOneWidget);

      await _tap(tester, find.byKey(const Key('keypad_delete')));
      expect(_digitInBoxes('1'), findsOneWidget);
      expect(_digitInBoxes('2'), findsNothing);
    });

    testWidgets('asks for every digit before verifying', (
      WidgetTester tester,
    ) async {
      await _pumpScreen(tester, const VerifyCodeScreen(email: _email));

      await _enterCode(tester, '12');
      await _tap(tester, find.text('Verify Code'));

      expect(find.text('Enter the 4-digit code.'), findsOneWidget);
    });

    testWidgets('reports a wrong code and clears the boxes', (
      WidgetTester tester,
    ) async {
      await _pumpScreen(tester, const VerifyCodeScreen(email: _email));

      await _enterCode(tester, '1111');
      await _tap(tester, find.text('Verify Code'));

      expect(find.text('The code you entered is incorrect.'), findsOneWidget);
      expect(_digitInBoxes('1'), findsNothing);
      expect(find.byType(CreateNewPasswordScreen), findsNothing);
    });

    testWidgets('opens the new password screen when the code is right', (
      WidgetTester tester,
    ) async {
      await _pumpScreen(tester, const VerifyCodeScreen(email: _email));

      await _enterCode(tester, MockAuthService.demoVerificationCode);
      await _tap(tester, find.text('Verify Code'));

      expect(find.byType(CreateNewPasswordScreen), findsOneWidget);
    });
  });

  group('CreateNewPasswordScreen', () {
    Future<void> submit(
      WidgetTester tester, {
      required String password,
      required String confirmation,
    }) async {
      await _pumpScreen(
        tester,
        const CreateNewPasswordScreen(email: _email, code: '1234'),
      );
      await tester.enterText(find.byType(TextFormField).at(0), password);
      await tester.enterText(find.byType(TextFormField).at(1), confirmation);
      await _tap(tester, find.text('Save Password'));
    }

    testWidgets('shows an error when the passwords do not match', (
      WidgetTester tester,
    ) async {
      await submit(tester, password: 'abcdef', confirmation: 'abcdeg');

      expect(find.text('Passwords do not match'), findsOneWidget);
      expect(find.byType(PasswordResetSuccessScreen), findsNothing);
    });

    testWidgets('opens the success screen when the passwords match', (
      WidgetTester tester,
    ) async {
      await submit(tester, password: 'abcdef', confirmation: 'abcdef');

      expect(find.byType(PasswordResetSuccessScreen), findsOneWidget);
    });
  });

  group('PasswordResetSuccessScreen', () {
    testWidgets('returns to the sign in screen', (WidgetTester tester) async {
      await _pumpScreen(tester, const PasswordResetSuccessScreen());

      await _tap(tester, find.text('Continue to Sign In'));

      expect(find.byType(LoginScreen), findsOneWidget);
      expect(find.byType(PasswordResetSuccessScreen), findsNothing);
    });
  });
}
