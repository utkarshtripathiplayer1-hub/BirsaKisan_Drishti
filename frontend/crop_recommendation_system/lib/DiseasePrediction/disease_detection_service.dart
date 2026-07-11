import 'dart:convert';
import 'dart:io';
import 'package:crop_recommendation_system/Authentication/secure_storage_service.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiConfig {
  static String get baseUrl => dotenv.env['BASE_URL']!;
}

class DiseaseDetectionService {
  Future<Map<String, dynamic>> predictDisease(File imageFile) async {
    final token = await SecureStorageService.getAccessToken();

    print("Token: $token");

    if (token == null) {
      throw Exception("User is not logged in");
    }

    var request = http.MultipartRequest(
      'POST',
      Uri.parse("${ApiConfig.baseUrl}/disease/predict"),
    );

    request.headers.addAll({"Authorization": "Bearer $token"});

    request.files.add(
      await http.MultipartFile.fromPath('image', imageFile.path),
    );

    var response = await request.send();
    print(response);

    if (response.statusCode == 200) {
      var responseBody = await response.stream.bytesToString();

      return jsonDecode(responseBody);
    } else {
      throw Exception("Failed to predict disease");
    }
  }
}
