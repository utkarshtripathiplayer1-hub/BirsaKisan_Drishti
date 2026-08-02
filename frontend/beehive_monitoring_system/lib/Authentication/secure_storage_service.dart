import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorageService {
  SecureStorageService._();

  static const FlutterSecureStorage _storage = FlutterSecureStorage();

  static const String _accessTokenKey = "access_token";

  /// Save JWT
  static Future<void> saveAccessToken(String token) async {
    await _storage.write(key: _accessTokenKey, value: token);
  }

  /// Read JWT
  static Future<String?> getAccessToken() async {
    return await _storage.read(key: _accessTokenKey);
  }

  /// Delete JWT
  static Future<void> clearAccessToken() async {
    await _storage.delete(key: _accessTokenKey);
  }

  /// Logout
  static Future<void> clearAll() async {
    await _storage.deleteAll();
  }

  /// Check Login
  static Future<bool> isLoggedIn() async {
    final token = await getAccessToken();
    return token != null && token.isNotEmpty;
  }
}
