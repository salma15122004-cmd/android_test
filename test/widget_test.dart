import 'package:android_test/screens/login_screen.dart';
import 'package:android_test/widgets/auth_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  group('validators', () {
    test('emailField', () {
      expect(emailField('user@example.com'), isNull);
      expect(emailField('  user@example.com  '), isNull);
      expect(emailField('a@.'), isNotNull);
      expect(emailField('no-at-sign.com'), isNotNull);
      expect(emailField(''), isNotNull);
      expect(emailField(null), isNotNull);
    });

    test('passwordField', () {
      expect(passwordField('123456'), isNull);
      expect(passwordField('12345'), isNotNull);
      expect(passwordField(null), isNotNull);
    });

    test('phoneField', () {
      expect(phoneField('01012345678'), isNull);
      expect(phoneField('+20 101 234 5678'), isNull);
      expect(phoneField('abc'), isNotNull);
      expect(phoneField('123'), isNotNull);
      expect(phoneField(''), isNotNull);
    });

    test('requiredField', () {
      expect(requiredField('Salma'), isNull);
      expect(requiredField('   '), isNotNull);
      expect(requiredField(null), isNotNull);
    });
  });

  group('LoginScreen', () {
    setUp(() {
      SharedPreferences.setMockInitialValues({});
    });

    testWidgets('shows validation errors when form is empty',
        (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: LoginScreen()));
      await tester.pumpAndSettle();

      final signIn = find.text('Sign In');
      await tester.ensureVisible(signIn);
      await tester.pumpAndSettle();
      await tester.tap(signIn);
      await tester.pumpAndSettle();

      expect(find.text('Enter a valid email'), findsOneWidget);
      expect(find.text('At least 6 characters'), findsOneWidget);
    });

    testWidgets('password visibility can be toggled',
        (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: LoginScreen()));
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.visibility_outlined), findsOneWidget);
      await tester.tap(find.byIcon(Icons.visibility_outlined));
      await tester.pump();
      expect(find.byIcon(Icons.visibility_off_outlined), findsOneWidget);
    });
  });
}
