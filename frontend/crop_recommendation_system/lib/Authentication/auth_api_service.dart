import 'dart:convert';

import 'package:crop_recommendation_system/Authentication/secure_storage_service.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiConfig {
  static String get baseUrl => dotenv.env['BASE_CORE_URL']!;
}

class AuthApiService {
  AuthApiService._();

  /// Login using Google ID Token
  static Future<Map<String, dynamic>> loginWithGoogle(String idToken) async {
    final response = await http.post(
      Uri.parse("${ApiConfig.baseUrl}/auth/google"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"id_token": idToken}),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    }

    throw Exception(
      "Authentication Failed\n"
      "Status Code: ${response.statusCode}\n"
      "${response.body}",
    );
  }

  /// Get current logged-in user
  static Future<Map<String, dynamic>> getCurrentUser({
    required String jwt,
  }) async {
    debugPrint("URL: ${ApiConfig.baseUrl}/auth/me");
    debugPrint("JWT: $jwt");

    final response = await http.get(
      Uri.parse("${ApiConfig.baseUrl}/auth/me"),
      headers: {
        "Authorization": "Bearer $jwt",
        "Content-Type": "application/json",
      },
    );

    debugPrint("Status: ${response.statusCode}");
    debugPrint("Body: ${response.body}");

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    }

    throw Exception(
      "Failed to fetch user.\n"
      "Status: ${response.statusCode}\n"
      "${response.body}",
    );
  }

  /// Update preferred language
  static Future<void> updateLanguage({
    required String jwt,
    required String language,
  }) async {
    debugPrint("URL: ${ApiConfig.baseUrl}/auth/language");
    debugPrint("JWT: $jwt");

    final response = await http.patch(
      Uri.parse("${ApiConfig.baseUrl}/auth/language"),
      headers: {
        "Authorization": "Bearer $jwt",
        "Content-Type": "application/json",
      },
      body: jsonEncode({"preferred_language": language}),
    );

    final token = await SecureStorageService.getAccessToken();
    debugPrint("JWT: $token");
    debugPrint("Status Code: ${response.statusCode}");
    debugPrint("Response Body: ${response.body}");

    if (response.statusCode != 200) {
      throw Exception(
        "Language Update Failed\n"
        "Status Code: ${response.statusCode}\n"
        "${response.body}",
      );
    }
  }

  static Future<bool> deleteAccount() async {
    final token = await SecureStorageService.getAccessToken();

    print("Token: $token");

    if (token == null) {
      throw Exception("User is not logged in");
    }
    print(Uri.parse('${ApiConfig.baseUrl}/account'));
    final response = await http.delete(
      Uri.parse('${ApiConfig.baseUrl}/account'),
      headers: {
        "Authorization": "Bearer $token",
        "Content-Type": "application/json",
      },
    );
    print("Status: ${response.statusCode}");
    print("Headers: ${response.headers}");
    print("Body: ${response.body}");
    if (response.statusCode == 200 || response.statusCode == 204) {
      return true;
    } else {
      throw Exception(
        "Failed to delete account. Status Code: ${response.statusCode}\n"
        "Response: ${response.body}",
      );
    }
  }
}
