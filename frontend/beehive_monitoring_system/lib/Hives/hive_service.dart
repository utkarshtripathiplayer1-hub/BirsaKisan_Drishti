import 'dart:convert';
import 'package:beehive_monitoring_system/Authentication/secure_storage_service.dart';
import 'package:beehive_monitoring_system/Hives/hive_model.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class HiveService {
  static String get baseUrl => dotenv.env['BASE_BEEHIVE_URL']!;

  static Future<http.Response> createHive({
    required String apiaryId,
    required HiveModel hive,
  }) async {
    final token = await SecureStorageService.getAccessToken();

    print("Token: $token");

    if (token == null) {
      throw Exception("User is not logged in");
    }

    final url = Uri.parse('$baseUrl/apiaries/$apiaryId/hives');

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(hive.toJson()),
    );

    print("Hive API Status Code: ${response.statusCode}");
    print("Hive API Response Body:");
    print(response.body);

    return response;
  }
}
