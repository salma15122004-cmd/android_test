import 'auth_service.dart';
import 'child_profile_service.dart';
import 'local_child_profile_service.dart';
import 'mock_auth_service.dart';

/// The [AuthService] used by every screen.
///
/// To connect the real backend, implement [AuthService] and assign the
/// implementation here. No screen needs to change. Tests may reassign it.
AuthService authService = MockAuthService();

/// نقطة تبديل تخزين ملف الطفل: استبدلها بتنفيذ REST/Firestore/قاعدة بياناتك.
ChildProfileService childProfileService = LocalChildProfileService();
