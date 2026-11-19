import 'package:android_test/utils/validators.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Validators.email', () {
    test('accepts well-formed addresses', () {
      expect(Validators.email('user@example.com'), isNull);
      expect(Validators.email('  user@example.com  '), isNull);
    });

    test('rejects malformed addresses', () {
      expect(Validators.email('a@.'), isNotNull);
      expect(Validators.email('no-at-sign.com'), isNotNull);
      expect(Validators.email(''), isNotNull);
      expect(Validators.email(null), isNotNull);
    });
  });

  group('Validators.password', () {
    test('requires the minimum length', () {
      expect(Validators.password('123456'), isNull);
      expect(Validators.password('12345'), isNotNull);
      expect(Validators.password(null), isNotNull);
    });
  });

  group('Validators.phone', () {
    test('accepts digits with an optional plus and separators', () {
      expect(Validators.phone('01012345678'), isNull);
      expect(Validators.phone('+20 101 234 5678'), isNull);
    });

    test('rejects invalid numbers', () {
      expect(Validators.phone('abc'), isNotNull);
      expect(Validators.phone('123'), isNotNull);
      expect(Validators.phone(''), isNotNull);
      expect(Validators.phone(null), isNotNull);
    });
  });

  group('Validators.requiredField', () {
    test('rejects empty values', () {
      expect(Validators.requiredField('Salma'), isNull);
      expect(Validators.requiredField('   '), isNotNull);
      expect(Validators.requiredField(null), isNotNull);
    });
  });

  group('Validators.confirmPassword', () {
    test('compares against the original password', () {
      final validator = Validators.confirmPassword(() => 'secret1');
      expect(validator('secret1'), isNull);
      expect(validator('secret2'), isNotNull);
    });
  });
}
