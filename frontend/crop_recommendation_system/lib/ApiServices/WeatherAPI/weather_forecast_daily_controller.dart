import 'dart:convert';

import 'package:crop_recommendation_system/ApiServices/WeatherAPI/weather_forecast_daily_model.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiConfig {
  static String get baseUrl => dotenv.env['BASE_WEATHER_URL']!;
}

class WeatherForecastDailyController extends GetxController {
  var isLoading = false.obs;
  var errorMessage = ''.obs;

  var forecast = <DailyForecast>[].obs;

  var location = Rxn<DailyLocation>();

  @override
  Future<void> onInit() async {
    super.onInit();

    try {
      Position position = await getCurrentLocation();

      await fetchDailyForecast(
        latitude: position.latitude,
        longitude: position.longitude,
      );
    } catch (e) {
      errorMessage.value = "Unable to get location: $e";
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
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final url = Uri.parse(
        '${ApiConfig.baseUrl}/api/v1/weather/forecast'
        '?latitude=$latitude'
        '&longitude=$longitude'
        '&days=7',
      );

      final response = await http.get(url);

      print("DAILY WEATHER STATUS CODE: ${response.statusCode}");
      print("DAILY WEATHER RESPONSE BODY:");
      print(response.body);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        final weatherResponse = DailyWeatherResponse.fromJson(data);

        location.value = weatherResponse.location;

        forecast.value = weatherResponse.forecast;
      } else {
        errorMessage.value = "Server Error: ${response.statusCode}";
      }
    } catch (e) {
      errorMessage.value = "Connection Error: $e";
      print("DAILY WEATHER FORECAST ERROR: $e");
    } finally {
      isLoading.value = false;
    }
  }
}
