import 'package:get/get.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiConfig {
  static String get baseUrl => dotenv.env['BASE_URL']!;
}

class WeatherApiService extends GetConnect {
  Future<Map<String, dynamic>> getWeather({
    required double lat,
    required double lon,
  }) async {
    final response = await get('${ApiConfig.baseUrl}/weather/current?lat=$lat&lon=$lon',);
    if (response.statusCode == 200) {
      return response.body;
    }
    throw Exception(
    'Failed to fetch weather: ${response.statusCode}',
  );
  }
}
