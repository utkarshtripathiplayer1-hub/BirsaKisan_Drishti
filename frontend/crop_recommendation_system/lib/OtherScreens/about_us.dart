import 'package:flutter/material.dart';

class AboutUs extends StatelessWidget {
  const AboutUs({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white, size: 30, weight: 40.0),
        title: const Text(
          'About Us',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: Color.fromARGB(255, 6, 122, 52),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsetsGeometry.all(10),
          child: Column(
            children: [
              Text(
                "BirsaKisanDrishti",
                style: TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                  fontFamily: "Timmana",
                ),
              ),

              Text(
                "-Your Smart Farming Companion",
                style: TextStyle(
                  // fontSize: 25,
                  fontWeight: FontWeight.w600,
                  fontFamily: "Timmana",
                ),
              ),
              Container(
                height: 3,
                width: 200,
                color: Color.fromARGB(255, 3, 196, 99),
              ),
              SizedBox(height: 20),
              Text(
                "BirsaKisanDrishti is an innovative Al-powered farming assistant built to help farmers make smarter decisions. Our mission is to boost crop yield, maximize profit, and simplify farming through technology.",
              ),
              SizedBox(height: 10),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "What We Provide",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                ),
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Container(
                  height: 3,
                  width: 200,
                  color: Color.fromARGB(255, 3, 196, 99),
                ),
              ),

              SizedBox(height: 20),

              GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 2.1,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),

                children: [
                  featureCard(
                    "assets/images/crop_recommendation.png",
                    "Smart Crop\nRecommendation",
                  ),

                  featureCard(
                    "assets/images/satellite.png",
                    "Satellite\nBased Soil\nInsights",
                  ),

                  featureCard(
                    "assets/images/soil_parameters.png",
                    "Uses soil parameters\n(N,P,K,pH) & weather\nto suggest best crop",
                  ),

                  featureCard(
                    "assets/images/ai_assistant.png",
                    "AI Farming\nAssistance",
                  ),

                  featureCard(
                    "assets/images/fertilizer.png",
                    "Fertilizer\nRecommendation",
                  ),

                  featureCard(
                    "assets/images/water_requirement_green.png",
                    "Water\nRequirement\nGuide",
                  ),

                  featureCard("assets/images/yield.png", "Yield\nProduction"),

                  featureCard(
                    "assets/images/weather_forecast.png",
                    "Weather\nBased Soil\nInsights",
                  ),
                ],
              ),
              SizedBox(height: 30),

              // OUR MISSION SECTION
              Row(
                children: [
                  Text(
                    "Our Mission",
                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                  ),

                  SizedBox(width: 10),

                  Image.asset(
                    "assets/images/mission_heart.png",
                    height: 55,
                    width: 55,
                    fit: BoxFit.contain,
                  ),
                ],
              ),

              SizedBox(height: 5),

              Align(
                alignment: Alignment.centerLeft,
                child: Container(
                  height: 3,
                  width: 220,
                  color: Color.fromARGB(255, 3, 196, 99),
                ),
              ),

              SizedBox(height: 15),

              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image.asset(
                    "assets/images/mission_icon.png",
                    height: 40,
                    width: 40,
                    fit: BoxFit.contain,
                  ),

                  SizedBox(width: 12),

                  Expanded(
                    child: Text(
                      "Empowering every farmer with AI-driven knowledge to increase productivity and sustainability",
                      style: TextStyle(fontSize: 15, height: 1.4),
                    ),
                  ),
                ],
              ),

              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget featureCard(String imagePath, String title) {
    return Container(
      padding: const EdgeInsets.all(10),

      decoration: BoxDecoration(
        color: Colors.white,

        borderRadius: BorderRadius.circular(20),

        boxShadow: const [
          BoxShadow(color: Colors.black26, blurRadius: 6, offset: Offset(2, 4)),
        ],
      ),

      child: Row(
        children: [
          Image.asset(imagePath, height: 45, width: 45),

          const SizedBox(width: 8),

          Expanded(
            child: Text(
              title,
              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }
}
