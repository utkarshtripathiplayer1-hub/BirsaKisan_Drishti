// import 'package:crop_recommendation_system/about_us.dart';
// import 'package:crop_recommendation_system/faqs.dart';
// import 'package:crop_recommendation_system/key_features.dart';
import 'package:crop_recommendation_system/ApiServices/weather_api/weather_api_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    WeatherApiController ctrl = Get.put(WeatherApiController());

    return Scaffold(
      appBar: AppBar(
        title: Text("Api service page for testing"),
        backgroundColor: Colors.green,
      ),
      body: Column(
        children: [
          ElevatedButton(
            onPressed: () {
              ctrl.fetchWeather();
            },
            child: Text("Fetch Weather"),
          ),
          Expanded(
            child: Obx(() {
              return Column(
                children: [
                  Text("City: ${ctrl.weather['city'] ?? ''}"),
                  Text("Temperature: ${ctrl.weather['temperature'] ?? ''}"),
                  Text("Humidity: ${ctrl.weather['humidity'] ?? ''}"),
                  Text("Condition: ${ctrl.weather['condition'] ?? ''}"),
                  Text("Description: ${ctrl.weather['description'] ?? ''}"),
                  Text("Wind Speed: ${ctrl.weather['wind_speed'] ?? ''}"),
                  Text("Pressure: ${ctrl.weather['pressure'] ?? ''}"),
                  Text("Feels Like: ${ctrl.weather['feels_like'] ?? ''}"),
                ],
              );
            }),
          ),
        ],
      ),
    );
  }
}
