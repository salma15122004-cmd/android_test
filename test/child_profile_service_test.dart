import 'package:android_test/models/child_profile.dart';
import 'package:android_test/services/local_child_profile_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  test('stores and reads a child profile', () async {
    SharedPreferences.setMockInitialValues({});
    final service = LocalChildProfileService();
    final profile = ChildProfile(
      name: 'Mariam',
      birthDate: DateTime(2020, 4, 12),
      gender: 'Female',
      avatarAsset: 'assets_img/img.1.png',
    );

    await service.saveProfile(profile);

    expect(await service.getProfile(), isA<ChildProfile>());
    expect((await service.getProfile())!.name, 'Mariam');
    expect((await service.getProfile())!.birthDate, profile.birthDate);
  });
}
