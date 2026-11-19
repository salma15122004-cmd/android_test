import '../models/child_profile.dart';

/// نقطة الاتصال الخاصة بملف الطفل مع قاعدة البيانات أو الـ API.
///
/// عند تجهيز الخادم، أنشئ تنفيذًا لهذه الواجهة واستبدله في
/// [service_locator.dart] بدل [LocalChildProfileService].
abstract interface class ChildProfileService {
  Future<void> saveProfile(ChildProfile profile);

  Future<ChildProfile?> getProfile();
}
