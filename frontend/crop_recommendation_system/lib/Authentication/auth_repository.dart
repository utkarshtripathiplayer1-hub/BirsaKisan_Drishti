import 'package:crop_recommendation_system/Authentication/auth_api_service.dart';
import 'package:crop_recommendation_system/Authentication/auth_response.dart';
import 'package:crop_recommendation_system/Authentication/google_auth_service.dart';
import 'package:crop_recommendation_system/Authentication/secure_storage_service.dart';

class AuthRepository {
  AuthRepository._();

  static Future<AuthResponse> loginWithGoogle() async {
    // Step 1: Google Sign-In
    final googleUser = await GoogleAuthService.signIn();

    // Step 2: Send Google ID Token to backend
    final response = await AuthApiService.loginWithGoogle(googleUser.idToken);

    // Step 3: Parse response
    final auth = AuthResponse.fromJson(response);

    // Step 4: Store JWT securely
    await SecureStorageService.saveAccessToken(auth.accessToken);

    return auth;
  }

  static Future<void> logout() async {
    await GoogleAuthService.signOut();
    await SecureStorageService.clearAll();
  }
}
