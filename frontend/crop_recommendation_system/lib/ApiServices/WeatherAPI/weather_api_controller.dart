import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'weather_api_service.dart';

class WeatherApiController extends GetxController {
  final WeatherApiService weatherApiService = WeatherApiService();
  var isRefreshing = false.obs;

  RxMap<String, dynamic> weather = <String, dynamic>{}.obs;

  @override
  void onInit() {
    super.onInit();
    // print("weather controller initialized");
    fetchWeather();
  }

  Future<void> fetchWeather() async {
    try {
      isRefreshing.value = true;

      Position position = await getCurrentLocation();

      final response = await weatherApiService.getWeather(
        lat: position.latitude,
        lon: position.longitude,
      );

      weather.value = response;
    } catch (e) {
      print("Weather Error: $e");
    } finally {
      isRefreshing.value = false;
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
    }

    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.deniedForever) {
      throw Exception('Location permissions are permanently denied');
    }

    // return await Geolocator.getCurrentPosition(
    //   desiredAccuracy: LocationAccuracy.high,
    // );

    return await Geolocator.getCurrentPosition(
      locationSettings: const LocationSettings(accuracy: LocationAccuracy.high),
    );
  }
}
