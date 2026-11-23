import '../constants/api_config.dart';
import 'api_auth_service.dart';
import 'auth_service.dart';
import 'child_profile_service.dart';
import 'local_child_profile_service.dart';

/// The [AuthService] used by every screen.
///
/// Sign in and sign up use the real backend at [ApiConfig.baseUrl]. For an
/// offline demo, assign `MockAuthService()` instead. Tests may reassign it.
AuthService authService = ApiAuthService(baseUrl: ApiConfig.baseUrl);

/// نقطة تبديل تخزين ملف الطفل: استبدلها بتنفيذ REST/Firestore/قاعدة بياناتك.
ChildProfileService childProfileService = LocalChildProfileService();
