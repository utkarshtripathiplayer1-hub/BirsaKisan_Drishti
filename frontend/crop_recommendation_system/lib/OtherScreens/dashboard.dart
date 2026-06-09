import 'package:crop_recommendation_system/DiseasePrediction/disease_detection_input.dart';
import 'package:crop_recommendation_system/CropRecommendation/crop_input_page.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:crop_recommendation_system/ApiServices/WeatherAPI/weather_api_controller.dart';
import 'package:crop_recommendation_system/OtherScreens/about_us.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    Widget weatherInfo(IconData icon, String title, String value) {
      return Column(
        children: [
          Icon(icon, color: Colors.green),

          const SizedBox(height: 5),

          Text(title, style: const TextStyle(color: Colors.grey, fontSize: 12)),

          Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      );
    }

    Widget farmCard(
      BuildContext context, {
      required String image,
      required String title,
      required Widget page,
    }) {
      return GestureDetector(
        onTap: () {
          Navigator.push(context, MaterialPageRoute(builder: (_) => page));
        },
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: const [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 8,
                offset: Offset(0, 3),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: 80,
                  child: Image.asset(image, fit: BoxFit.contain),
                ),

                const SizedBox(height: 12),

                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    WeatherApiController ctrl = Get.put(WeatherApiController());

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF6D9F3A),
        elevation: 0,
        automaticallyImplyLeading: false,
        toolbarHeight: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // HEADER SECTION
            Stack(
              children: [
                ClipRRect(
                  child: Container(
                    height: 260,
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage("assets/images/farm_bg.png"),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),

                Container(
                  height: 260,
                  width: double.infinity,
                  color: Colors.black.withValues(alpha: 0.20)

                ),

                SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 15,
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  _getGreeting(),
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 28,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),

                                const SizedBox(height: 5),

                                Text(
                                  _getFormattedDate(),
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),

                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (_) => AboutUs()),
                                );
                              },
                              child: const CircleAvatar(
                                radius: 28,
                                backgroundColor: Colors.white,
                                child: Icon(Icons.person, color: Colors.black),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 35),

                        Obx(() {
                          return Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(18),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(25),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black12,
                                  blurRadius: 8,
                                  offset: Offset(0, 3),
                                ),
                              ],
                            ),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          ctrl.weather['city'] ?? '',
                                          style: const TextStyle(
                                            fontSize: 22,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),

                                        const SizedBox(height: 4),

                                        Text(
                                          ctrl.weather['condition'] ?? '',
                                          style: const TextStyle(
                                            color: Colors.grey,
                                          ),
                                        ),
                                      ],
                                    ),

                                    Text(
                                      "${ctrl.weather['temperature'] ?? ''}°C",
                                      style: const TextStyle(
                                        fontSize: 34,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),

                                const SizedBox(height: 15),

                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    weatherInfo(
                                      Icons.water_drop,
                                      "Humidity",
                                      "${ctrl.weather['humidity'] ?? ''}",
                                    ),

                                    weatherInfo(
                                      Icons.device_thermostat,
                                      "Feels Like",
                                      "${ctrl.weather['feels_like'] ?? ''}",
                                    ),

                                    weatherInfo(
                                      Icons.air,
                                      "Wind",
                                      "${ctrl.weather['wind_speed'] ?? ''}",
                                    ),

                                    weatherInfo(
                                      Icons.compress,
                                      "Pressure",
                                      "${ctrl.weather['pressure'] ?? ''}",
                                    ),
                                  ],
                                ),

                                const SizedBox(height: 15),

                                Container(
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFF4F6E5),
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  child: Row(
                                    children: [
                                      const Icon(
                                        Icons.info_outline,
                                        color: Colors.green,
                                      ),

                                      const SizedBox(width: 10),

                                      Expanded(
                                        child: Text(
                                          ctrl.weather['description'] ?? '',
                                          style: const TextStyle(fontSize: 13),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        }),
                        const SizedBox(height: 30),

                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Row(
                            children: const [
                              Text(
                                "Manage Your Farm",
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 20),

                        Padding(
                          padding: EdgeInsets.zero,
                          child: GridView.count(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            crossAxisCount: 2,
                            crossAxisSpacing: 20,
                            mainAxisSpacing: 15,
                            mainAxisExtent: 180,
                            children: [
                              farmCard(
                                context,
                                image: "assets/images/my_farm.png",
                                title: "My Farm",
                                page: const AboutUs(),
                              ),

                              farmCard(
                                context,
                                image: "assets/images/crop.png",
                                title: "Crop",
                                page: const CropInputPage(),
                              ),

                              farmCard(
                                context,
                                image: "assets/images/market_price.png",
                                title: "Market Price",
                                page: const AboutUs(),
                              ),

                              farmCard(
                                context,
                                image: "assets/images/disease_detector.png",
                                title: "Disease Detector",
                                page: DiseaseDetectionInput(),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 30),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),

      bottomNavigationBar: Container(
        height: 75,
        decoration: const BoxDecoration(
          color: Colors.white,
          boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10)],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            // HOME
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const HomePage()),
                );
              },
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset("assets/images/home.png", height: 35),

                  const SizedBox(height: 4),
                ],
              ),
            ),

            // NOTIFICATION
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const AboutUs()),
                );
              },
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(Icons.notifications, size: 35, color: Colors.black87),

                  SizedBox(height: 4),
                ],
              ),
            ),

            // CHATBOT
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const AboutUs()),
                );
              },
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset("assets/images/chatbot.png", height: 33),

                  const SizedBox(height: 4),
                ],
              ),
            ),

            // AGRICULTURE WEBSITE
            GestureDetector(
              onTap: () async {
                final Uri url = Uri.parse(
                  "https://agriwelfare.gov.in/en/Major",
                );

                if (await canLaunchUrl(url)) {
                  await launchUrl(url, mode: LaunchMode.externalApplication);
                }
              },
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset("assets/images/agriculture.png", height: 33),

                  const SizedBox(height: 4),
                ],
              ),
            ),

            // COMMUNITY
            GestureDetector(
              onTap: () {
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(const SnackBar(content: Text("Coming Soon")));
              },
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset("assets/images/community.png", height: 33),

                  const SizedBox(height: 4),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getGreeting() {
    final hour = DateTime.now().hour;

    if (hour < 12) {
      return "Good Morning";
    } else if (hour < 17) {
      return "Good Afternoon";
    } else {
      return "Good Evening";
    }
  }

  String _getFormattedDate() {
    return DateFormat("EEEE, dd MMM yyyy").format(DateTime.now());
  }
}
