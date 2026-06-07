// import 'package:crop_recommendation_system/about_us.dart';
// import 'package:crop_recommendation_system/ApiServices/weather_api/example1.dart';
import 'package:crop_recommendation_system/ApiServices/weather_api/example1.dart';
import 'package:crop_recommendation_system/crop_recommendation/crop_input_page.dart';
import 'package:crop_recommendation_system/other_screens/settings.dart';
// import 'package:crop_recommendation_system/key_features.dart';
// import 'package:crop_recommendation_system/faqs.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Home Page"), backgroundColor: Colors.green),
      body: Column(
        children: [
          ElevatedButton(
            onPressed: () {
              Get.to(HomePage());
            },
            child: Text("Weather API"),
          ),
          ElevatedButton(
            onPressed: () {
              Get.to(CropInputPage());
            },
            child: Text("Crop Recommendation"),
          ),
          ElevatedButton(
            onPressed: () {
              Get.to(Setting());
            },
            child: Text("Settings"),
          ),
        ],
      ),
    );
  }
}
