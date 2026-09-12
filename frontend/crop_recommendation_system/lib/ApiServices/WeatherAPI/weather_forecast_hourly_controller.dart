import 'dart:convert';

import 'package:crop_recommendation_system/ApiServices/WeatherAPI/weather_forecast_hourly_model.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiConfig {
  static String get baseUrl => dotenv.env['BASE_WEATHER_URL']!;
}

class WeatherForecastController extends GetxController {
  var isLoading = false.obs;
  var errorMessage = ''.obs;

  var forecast = <ForecastData>[].obs;

  var location = Rxn<LocationData>();

  @override
  Future<void> onInit() async {
    super.onInit();

    Position position = await getCurrentLocation();

    fetchForecast(latitude: position.latitude, longitude: position.longitude);
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
    }

    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.deniedForever) {
      throw Exception('Location permissions are permanently denied');
    }

    return await Geolocator.getCurrentPosition(
      locationSettings: const LocationSettings(accuracy: LocationAccuracy.high),
    );
  }

  Future<void> fetchForecast({
    required double latitude,
    required double longitude,
  }) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final url = Uri.parse(
        '${ApiConfig.baseUrl}/api/v1/weather/hourly'
        '?latitude=$latitude'
        '&longitude=$longitude'
        '&days=7',
      );

      final response = await http.get(url);

      print("STATUS CODE: ${response.statusCode}");
      print("RESPONSE BODY:");
      print(response.body);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        final weatherResponse = WeatherForecastResponse.fromJson(data);

        location.value = weatherResponse.location;

        // Get required 5 hours
        final requiredHours = getRequiredHours(weatherResponse.forecast);

        forecast.value = requiredHours;
      } else {
        errorMessage.value = "Server Error: ${response.statusCode}";
      }
    } catch (e) {
      errorMessage.value = "Connection Error: $e";
    } finally {
      isLoading.value = false;
    }
  }

  List<ForecastData> getRequiredHours(List<ForecastData> allForecast) {
    if (allForecast.isEmpty) {
      return [];
    }

    final now = DateTime.now();

    // Current hour
    final currentHour = DateTime(now.year, now.month, now.day, now.hour);

    // 1 hour before
    final startTime = currentHour.subtract(const Duration(hours: 1));

    // 3 hours after
    final endTime = currentHour.add(const Duration(hours: 3));

    final result = allForecast.where((item) {
      try {
        final itemTime = DateTime.parse(item.time);

        return !itemTime.isBefore(startTime) && !itemTime.isAfter(endTime);
      } catch (e) {
        return false;
      }
    }).toList();

    // Make sure they are in chronological order
    result.sort(
      (a, b) => DateTime.parse(a.time).compareTo(DateTime.parse(b.time)),
    );

    return result;
  }
}
