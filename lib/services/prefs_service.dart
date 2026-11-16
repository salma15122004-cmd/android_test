import 'package:shared_preferences/shared_preferences.dart';

/// كل التعامل مع shared_preferences في مكان واحد.
class PrefsService {
  static const _onboardingSeenKey = 'onboarding_seen';
  static const _rememberKey = 'remember_me';
  static const _savedEmailKey = 'saved_email';

  static Future<bool> isOnboardingSeen() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_onboardingSeenKey) ?? false;
  }

  static Future<void> setOnboardingSeen() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_onboardingSeenKey, true);
  }

  static Future<bool> getRemember() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_rememberKey) ?? false;
  }

  static Future<String> getSavedEmail() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_savedEmailKey) ?? '';
  }

  /// نحفظ الإيميل فقط لو Remember me مفعّل. الباسورد لا يتخزن هنا أبدًا.
  static Future<void> saveRemember({
    required bool remember,
    required String email,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_rememberKey, remember);
    if (remember) {
      await prefs.setString(_savedEmailKey, email);
    } else {
      await prefs.remove(_savedEmailKey);
    }
  }
}
