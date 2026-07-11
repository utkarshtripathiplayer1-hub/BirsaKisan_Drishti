import 'dart:convert';
import 'package:crop_recommendation_system/Authentication/secure_storage_service.dart';
import 'package:crop_recommendation_system/Profile/profile_model.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiConfig {
  static String get baseUrl => dotenv.env['BASE_URL']!;
}

class CropProfileService {
  CropProfileService._();

  static Future<CropProfile> getProfile() async {
    final token = await SecureStorageService.getAccessToken();

    if (token == null) {
      throw Exception("JWT token not found");
    }

    final response = await http.get(
      Uri.parse("${ApiConfig.baseUrl}/profile/crop"),
      headers: {
        "Authorization": "Bearer $token",
        "Content-Type": "application/json",
      },
    );

    if (response.statusCode == 200) {
      print(response.body);
      return CropProfile.fromJson(jsonDecode(response.body));
    }
    print(response.statusCode);
    throw Exception("Failed to load profile. ${response.body}.");
  }

  static Future<void> updateProfile(CropProfile profile) async {
    final token = await SecureStorageService.getAccessToken();

    if (token == null) {
      throw Exception("JWT not found");
    }

    final response = await http.patch(
      Uri.parse("${ApiConfig.baseUrl}/profile/crop"),

      headers: {
        "Authorization": "Bearer $token",

        "Content-Type": "application/json",
      },

      body: jsonEncode(profile.toJson()),
    );

    if (response.statusCode != 200 && response.statusCode != 201) {
      print({ApiConfig.baseUrl});
      throw Exception("Failed to update profile: ${response.body}");
    }
  }
}
