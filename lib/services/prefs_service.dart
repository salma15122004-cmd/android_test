import 'package:shared_preferences/shared_preferences.dart';

/// Small wrapper around `shared_preferences` for the values the app stores.
abstract final class PrefsService {
  static const String _onboardingSeenKey = 'onboarding_seen';
  static const String _rememberKey = 'remember_me';
  static const String _savedEmailKey = 'saved_email';

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

  /// Stores the email only when [remember] is true. The password is never
  /// stored here.
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
