import 'dart:convert';
import 'package:crop_recommendation_system/Authentication/secure_storage_service.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiConfig {
  static String get baseUrl => dotenv.env['BASE_CROP_URL']!;
}

class StartCrop{

  static Future<void> startCrop(String recommendationId) async {

    final token = await SecureStorageService.getAccessToken();

    if (token == null) {
      throw Exception("User not logged in");
    }

    final response = await http.post(
      Uri.parse("${ApiConfig.baseUrl}/my-farm/start-crop"),
      headers: {
        "Authorization": "Bearer $token",
        "Content-Type": "application/json",
      },
      body: jsonEncode({
        "recommendation_id": recommendationId,
      }),
    );

    print(response.statusCode);
    print(response.body);

    if (response.statusCode != 200) {
      throw Exception("Failed to start crop");
    }
  }
}