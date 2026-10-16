import 'dart:convert';
import 'package:beehive_monitoring_system/Apiary/apiary_model.dart';
import 'package:beehive_monitoring_system/Authentication/secure_storage_service.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiConfig {
  static String get baseUrl => dotenv.env['BASE_BEEHIVE_URL']!;
}

class ApiaryService {
  static Future<http.Response> createApiary({
    required ApiaryModel apiary,
  }) async {
    final token = await SecureStorageService.getAccessToken();

    print("Token: $token");

    if (token == null) {
      throw Exception("User is not logged in");
    }
    final url = Uri.parse('${ApiConfig.baseUrl}/apiaries');

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        "Authorization": "Bearer $token",
      },
      body: jsonEncode(apiary.toJson()),
    );
    print("Status Code: ${response.statusCode}");
    print("Response Body:");
    print(response.body);
    
    return response;

  }
}
