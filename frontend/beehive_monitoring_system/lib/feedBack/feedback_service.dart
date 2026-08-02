import 'dart:convert';
import 'package:beehive_monitoring_system/Authentication/secure_storage_service.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiConfig {
  static String get baseUrl => dotenv.env['BASE_CORE_URL']!;
}

class FeedbackService {
  static Future<String> submitFeedback({
    required int rating,
    required String comment,
  }) async {
    final token = await SecureStorageService.getAccessToken();

    print("Token: $token");

    if (token == null) {
      throw Exception("User is not logged in");
    }

    final response = await http.post(
      Uri.parse("${ApiConfig.baseUrl}/feedback"),
      headers: {
        "Authorization": "Bearer $token",
        "Content-Type": "application/json",
      },
      body: jsonEncode({
        "rating": rating,
        "comment": comment,
      }),
    );

    print(response.statusCode);
    print(response.body);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data["message"];
    } else {
      throw Exception("Failed to submit feedback");
    }
  }
}