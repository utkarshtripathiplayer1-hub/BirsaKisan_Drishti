import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';

import 'weather_api_service.dart';

class WeatherApiController extends GetxController {
  final WeatherApiService weatherApiService = WeatherApiService();

  RxMap<String, dynamic> weather = <String, dynamic>{}.obs;

  @override
  void onInit() {
    super.onInit();
    print("weather controller initialized");
    fetchWeather();
  }

  Future<void> fetchWeather() async {
    Position position = await getCurrentLocation();

    print("Latitude: ${position.latitude}");
    print("Longitude: ${position.longitude}");

    final response = await weatherApiService.getWeather(
      lat: position.latitude,
      lon: position.longitude,
    );

    weather.value = response;
  }

  Future<Position> getCurrentLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();

    if (!serviceEnabled) {
      throw Exception('Location services are disabled');
    }

    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.deniedForever) {
      throw Exception('Location permissions are permanently denied');
    }

    return await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
  }
}
