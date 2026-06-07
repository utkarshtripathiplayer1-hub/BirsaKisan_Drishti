// import 'package:crop_recommendation_system/ApiServices/weather_api/home_page_screen_temp.dart';
// import 'package:crop_recommendation_system/crop_recommendation/crop_input_page.dart';
import 'package:crop_recommendation_system/ApiServices/weather_api/example1.dart';
// import 'package:crop_recommendation_system/example.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
// import 'package:get/get_core/src/get_main.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      home: const HomePage(),
    );
  }
}
