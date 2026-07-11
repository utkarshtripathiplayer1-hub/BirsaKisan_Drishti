import 'package:crop_recommendation_system/Authentication/auth_api_service.dart';
import 'package:crop_recommendation_system/Authentication/auth_repository.dart';
import 'package:crop_recommendation_system/Authentication/secure_storage_service.dart';
import 'package:crop_recommendation_system/Authentication/user_model.dart';
import 'package:flutter/material.dart';

class AuthProvider extends ChangeNotifier {
  bool _isLoading = false;
  bool _isAuthenticated = false;

  UserModel? _currentUser;

  bool get isLoading => _isLoading;
  bool get isAuthenticated => _isAuthenticated;
  UserModel? get currentUser => _currentUser;

  /// Login using Google
  Future<bool> login() async {
    try {
      _isLoading = true;
      notifyListeners();

      final auth = await AuthRepository.loginWithGoogle();

      _currentUser = auth.user;
      _isAuthenticated = true;

      return auth.isNewUser;
    } catch (e) {
      debugPrint("Login Error : $e");
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Restore login from stored JWT
  Future<void> restoreSession() async {
    try {
      _isLoading = true;
      notifyListeners();

      final token = await SecureStorageService.getAccessToken();
      debugPrint("========== RESTORE SESSION ==========");
      debugPrint("Stored Token: $token");

      if (token == null) {
        _isAuthenticated = false;
        return;
      }

      final response = await AuthApiService.getCurrentUser(jwt: token);

      _currentUser = UserModel.fromJson(response["user"]);

      _isAuthenticated = true;
    } catch (e) {
      print("Restore session error: $e");

      await SecureStorageService.clearAll();

      _currentUser = null;
      _isAuthenticated = false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Update language
  Future<void> updateLanguage(String language) async {
    final token = await SecureStorageService.getAccessToken();

    if (token == null) {
      throw Exception("JWT not found");
    }

    await AuthApiService.updateLanguage(jwt: token, language: language);

    if (_currentUser != null) {
      _currentUser = UserModel(
        id: _currentUser!.id,
        name: _currentUser!.name,
        email: _currentUser!.email,
        picture: _currentUser!.picture,
        preferredLanguage: language,
      );
    }

    notifyListeners();
  }

  /// Logout
  Future<void> logout() async {
    await AuthRepository.logout();

    _currentUser = null;
    _isAuthenticated = false;

    notifyListeners();
  }
}
