import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/child_profile.dart';
import 'child_profile_service.dart';

/// حفظ محلي يعمل كقاعدة بيانات مؤقتة حتى يتم ربط الـ API الحقيقي.
class LocalChildProfileService implements ChildProfileService {
  static const _profileKey = 'child_profile';

  @override
  Future<void> saveProfile(ChildProfile profile) async {
    final preferences = await SharedPreferences.getInstance();
    final saved = await preferences.setString(
      _profileKey,
      jsonEncode(profile.toJson()),
    );
    if (!saved) {
      throw const FormatException('Unable to persist the child profile.');
    }
  }

  @override
  Future<ChildProfile?> getProfile() async {
    final preferences = await SharedPreferences.getInstance();
    final value = preferences.getString(_profileKey);
    if (value == null) return null;

    try {
      return ChildProfile.fromJson(
        Map<String, dynamic>.from(jsonDecode(value) as Map),
      );
    } on FormatException {
      rethrow;
    } on Object {
      throw const FormatException('Stored child profile is invalid.');
    }
  }
}
