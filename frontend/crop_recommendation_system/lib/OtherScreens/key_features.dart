import 'package:flutter/material.dart';

class KeyFeatures extends StatelessWidget {
  const KeyFeatures({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 58, 108, 75),

      appBar: AppBar(
        title: const Text(
          "Key Features",
          style: TextStyle(
            fontSize: 35,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.green.shade900,
        iconTheme: const IconThemeData(color: Colors.white, size: 30, weight: 40.0),
        elevation: 0,
      ),

      body: SingleChildScrollView(
        child: Column(
          children: [
            // GREEN HEADER SECTION
            Container(
              width: double.infinity,
              color: const Color.fromARGB(255, 58, 108, 75),
              padding: const EdgeInsets.only(
                left: 15,
                right: 15,
                bottom: 30,
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment:
                        MainAxisAlignment.spaceBetween,
                    children: [
                      Image.asset(
                        "assets/images/tractor_left.png",
                        height: 80,
                      ),

                      Expanded(
                        child: Column(
                          children: const [
                            Text(
                              "BirsaKisanDrishti",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),

                            SizedBox(height: 5),

                            Text(
                              "Smart Farming Toolkit",
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),

                      Image.asset(
                        "assets/images/tractor_right.png",
                        height: 80,
                      ),
                    ],
                  ),

                  const SizedBox(height: 25),

                  const Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 20,
                    ),
                    child: Text(
                      "AI powered assistant to improve your crop yield.",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // GREY ROUNDED SECTION
            Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                color: Color(0xFFF8FAF2),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(35),
                  topRight: Radius.circular(35),
                ),
              ),
              child: Column(
                children: [
                  const SizedBox(height: 25),

                  const Text(
                    "Smart Farming Features",
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1E5C37),
                    ),
                  ),

                  const SizedBox(height: 25),

                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 15,
                    ),
                    child: GridView.count(
                      crossAxisCount: 2,
                      crossAxisSpacing: 15,
                      mainAxisSpacing: 15,
                      shrinkWrap: true,
                      physics:
                          const NeverScrollableScrollPhysics(),
                      childAspectRatio: 0.82,
                      children: const [
                        FeatureCard(
                          imagePath:
                              "assets/images/crop_recommendation.png",
                          title: "Crop Recommendation",
                          description:
                              "AI-based crop suggestion using N, P, K, pH and weather.",
                        ),
                        FeatureCard(
                          imagePath:
                              "assets/images/disease_detection.png",
                          title: "Disease Detection",
                          description:
                              "Scan plant leaves for real-time disease diagnosis.",
                        ),
                        FeatureCard(
                          imagePath:
                              "assets/images/water_requirement.png",
                          title: "Water Requirement",
                          description:
                              "Shows irrigation requirement for selected crops.",
                        ),
                        FeatureCard(
                          imagePath:
                              "assets/images/weather_forecast.png",
                          title: "Weather Forecast",
                          description:
                              "Smart weather insights for better planning.",
                        ),
                        FeatureCard(
                          imagePath:
                              "assets/images/market_price.png",
                          title: "Market Price Insight",
                          description:
                              "Real-time mandi prices with market trends.",
                        ),
                        FeatureCard(
                          imagePath:
                              "assets/images/government_scheme.png",
                          title: "Government Schemes",
                          description:
                              "Eligibility details and application guidance.",
                        ),
                        FeatureCard(
                          imagePath:
                              "assets/images/crop_calendar.png",
                          title: "Seasonal Crop Calendar",
                          description:
                              "Month-wise sowing and harvesting schedule.",
                        ),
                        FeatureCard(
                          imagePath:
                              "assets/images/task_reminder.png",
                          title: "Farming Task Reminder",
                          description:
                              "Reminders for irrigation, sowing and harvesting.",
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 30),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class FeatureCard extends StatelessWidget {
  final String imagePath;
  final String title;
  final String description;

  const FeatureCard({
    super.key,
    required this.imagePath,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 6,
            offset: Offset(2, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          Image.asset(
            imagePath,
            height: 55,
            width: 55,
          ),

          const SizedBox(height: 12),

          Text(
            title,
            style: const TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 8),

          Expanded(
            child: Text(
              description,
              style: const TextStyle(
                fontSize: 13,
                height: 1.3,
              ),
            ),
          ),
        ],
      ),
    );
  }
}