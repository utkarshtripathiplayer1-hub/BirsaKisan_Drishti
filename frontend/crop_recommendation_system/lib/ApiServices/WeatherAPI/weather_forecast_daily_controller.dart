import 'dart:convert';

import 'package:crop_recommendation_system/ApiServices/WeatherAPI/weather_forecast_daily_model.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiConfig {
  static String get baseUrl => dotenv.env['BASE_CROP_URL']!;
}

class WeatherForecastDailyController extends GetxController {

  var isLoading = false.obs;
  var errorMessage = ''.obs;

  var forecast = <DailyForecast>[].obs;

  var location = Rxn<DailyLocation>();

  @override
  Future<void> onInit() async {
    super.onInit();

    print("🔥 Daily Weather Controller initialized");

    try {
      Position position = await getCurrentLocation();

      await fetchDailyForecast(
        latitude: position.latitude,
        longitude: position.longitude,
      );
    } catch (e) {
      errorMessage.value = "Unable to get location: $e";

      print("❌ DAILY WEATHER LOCATION ERROR: $e");
    }
  }

  Future<Position> getCurrentLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();

    if (!serviceEnabled) {
      Get.snackbar(
        "Location service disabled",
        "Try again after enabling location service",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green.shade900,
        colorText: Colors.white,
      );

      throw Exception("Location service disabled");
    }

    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.denied) {
      throw Exception("Location permission denied");
    }

    if (permission == LocationPermission.deniedForever) {
      throw Exception("Location permissions are permanently denied");
    }

    return await Geolocator.getCurrentPosition(
      locationSettings: const LocationSettings(accuracy: LocationAccuracy.high),
    );
  }

  Future<void> fetchDailyForecast({
    required double latitude,
    required double longitude,
  }) async {
    print("🔥 fetchDailyForecast() CALLED");

    try {
      isLoading.value = true;
      errorMessage.value = '';

      final url = Uri.parse(
        '${ApiConfig.baseUrl}/api/v1/weather/forecast'
        '?latitude=$latitude'
        '&longitude=$longitude'
        '&days=7',
      );

      print("=================================");
      print("🌐 DAILY REQUEST URL: $url");

      final response = await http.get(url);

      print("📡 DAILY STATUS CODE: ${response.statusCode}");
      print("📦 DAILY RESPONSE BODY:");
      print(response.body);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        final weatherResponse = DailyWeatherResponse.fromJson(data);

        location.value = weatherResponse.location;

        forecast.value = weatherResponse.forecast;

        print("📊 DAILY FORECAST COUNT: ${forecast.length}");

        for (final weather in forecast) {
          print(
            "🌤️ ${weather.date} | "
            "${weather.temperatureMin}°C - "
            "${weather.temperatureMax}°C | "
            "${weather.condition}",
          );
        }
      } else {
        errorMessage.value = "Server Error: ${response.statusCode}";

        print("❌ Daily Server Error: ${response.statusCode}");
      }
    } catch (e) {
      errorMessage.value = "Connection Error: $e";

      print("❌ DAILY FORECAST ERROR: $e");
    } finally {
      isLoading.value = false;
    }
  }
}
