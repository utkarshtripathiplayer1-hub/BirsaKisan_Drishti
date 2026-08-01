import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiConfig {
  static String get baseUrl => dotenv.env['BASE_CROP_URL']!;
}

class CropRotationService {
  static String apiUrl = '${ApiConfig.baseUrl}/crop/rotation';

  Future<Map<String, dynamic>> getCropRotation(String recommendationId) async {
    final response = await http.get(
      Uri.parse('$apiUrl/$recommendationId'),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    }

    throw Exception(response.body);
  }
}
