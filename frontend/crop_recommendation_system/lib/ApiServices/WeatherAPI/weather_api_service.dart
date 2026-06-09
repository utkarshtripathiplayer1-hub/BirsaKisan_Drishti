import 'package:get/get.dart';

class WeatherApiService extends GetConnect {


  Future<Map<String, dynamic>> getWeather({
    required double lat,
    required double lon,
  }) async {
    final response = await get(
    'https://remedy-factsheet-empirical.ngrok-free.dev/weather/current?lat=$lat&lon=$lon',
    );

    if (response.statusCode == 200) {
      return response.body;
    }
    throw Exception(
    'Failed to fetch weather: ${response.statusCode}',
  );
  }
}
