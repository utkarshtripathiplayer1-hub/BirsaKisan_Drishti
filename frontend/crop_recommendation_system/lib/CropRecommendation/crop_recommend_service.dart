import 'dart:convert';
import 'package:crop_recommendation_system/Authentication/secure_storage_service.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiConfig {
  static String get baseUrl => dotenv.env['BASE_CROP_URL']!;
}

class CropRecommendService {
  static String apiUrl = '${ApiConfig.baseUrl}/crop/recommend';

  Future<Map<String, dynamic>> getRecommendation({
    required double n,
    required double p,
    required double k,
    required double ph,
    required double soilMoisture,
    required double temperature,
    required double humidity,
    required double rainfall,
    required String soilType,
  }) async {
    final token = await SecureStorageService.getAccessToken();

    print("Token: $token");

    if (token == null) {
      throw Exception("User is not logged in");
    }

    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
      body: jsonEncode({
        "N": n,
        "P": p,
        "K": k,
        "pH": ph,
        "Soil_Moisture": soilMoisture,
        "Temperature": temperature,
        "Humidity": humidity,
        "Rainfall": rainfall,
        "Soil_Type": soilType,
      }),
    );

    print("Status Code: ${response.statusCode}");
    print("Response Body:");
    print(response.body);

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    }

    throw Exception(response.body);
  }
}
