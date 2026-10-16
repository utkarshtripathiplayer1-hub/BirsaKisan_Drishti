import 'dart:convert';

import 'package:beehive_monitoring_system/Authentication/secure_storage_service.dart';
import 'apiary_model.dart';
import 'simulation_model.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiConfig {
  static String get baseUrl => dotenv.env['BASE_BEEHIVE_URL']!;
}

class ApiaryMonitoringService {
  Future<List<ApiaryModel>> getApiaries() async {
    final accessToken = await SecureStorageService.getAccessToken();

    if (accessToken == null || accessToken.isEmpty) {
      throw Exception('Authentication token not found');
    }

    final response = await http.get(
      Uri.parse('${ApiConfig.baseUrl}/apiaries'),
      headers: {
        'Authorization': 'Bearer $accessToken',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);

      return data.map((json) => ApiaryModel.fromJson(json)).toList();
    }

    throw Exception('Failed to load apiaries: ${response.statusCode}');
  }

  Future<ApiarySimulationModel> getApiarySimulation({
    required String apiaryId,
    required String scenario,
  }) async {
    final accessToken = await SecureStorageService.getAccessToken();

    if (accessToken == null || accessToken.isEmpty) {
      throw Exception('Authentication token not found');
    }

    final uri = Uri.parse(
      '${ApiConfig.baseUrl}/simulation/apiaries/$apiaryId'
      '?scenario=$scenario',
    );

    final response = await http.get(
      uri,
      headers: {
        'Authorization': 'Bearer $accessToken',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);

      return ApiarySimulationModel.fromJson(data);
    }

    throw Exception('Failed to load apiary simulation: ${response.statusCode}');
  }
}
