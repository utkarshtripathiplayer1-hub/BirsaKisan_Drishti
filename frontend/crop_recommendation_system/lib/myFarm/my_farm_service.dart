import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:crop_recommendation_system/myFarm/my_farm_model.dart';
import '../Authentication/secure_storage_service.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiConfig {
  static String get baseUrl => dotenv.env['BASE_CROP_URL']!;
}

class MyFarmApiService {

  static Future<MyFarmModel> fetchDashboard() async {

    final token = await SecureStorageService.getAccessToken();

    if (token == null) {
      throw Exception("User not logged in");
    }

    final response = await http.get(
      Uri.parse("${ApiConfig.baseUrl}/my-farm/dashboard"),
      headers: {
        "Authorization": "Bearer $token",
        "Content-Type": "application/json",
      },
    );

    print(response.statusCode);
    print(response.body);

    if (response.statusCode == 200) {
      return MyFarmModel.fromJson(jsonDecode(response.body));
    }

    throw Exception("Failed to load dashboard");
  }
}