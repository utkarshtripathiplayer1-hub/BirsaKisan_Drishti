import 'package:crop_recommendation_system/l10n/app_localizations.dart';
import 'package:flutter/material.dart';

class AboutUs extends StatelessWidget {
  const AboutUs({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Colors.white,
          size: 30,
          weight: 40.0,
        ),
        title: Text(
          AppLocalizations.of(context)!.aboutUs,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.green.shade900,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsetsGeometry.all(10),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(10),
                child: Image.asset(
                  "assets/images/Birsa_Kisan_Drishti_Logo.png",
                  fit: BoxFit.contain,
                ),
              ),

              Text(
                AppLocalizations.of(context)!.aboutusDesc1,
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
              Text(AppLocalizations.of(context)!.aboutusDesc2),
              SizedBox(height: 10),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  AppLocalizations.of(context)!.provided,
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                ),
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Container(
                  height: 3,
                  width: 150,
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
                    AppLocalizations.of(context)!.smartCrop,
                  ),

                  featureCard(
                    "assets/images/satellite.png",
                    AppLocalizations.of(context)!.soilInsight,
                  ),

                  featureCard(
                    "assets/images/soil_parameters.png",
                    AppLocalizations.of(context)!.soilParameters,
                  ),

                  featureCard(
                    "assets/images/ai_assistant.png",
                    AppLocalizations.of(context)!.aiFarming,
                  ),

                  featureCard(
                    "assets/images/fertilizer.png",
                    AppLocalizations.of(context)!.fertilizerRecommendation,
                  ),

                  featureCard(
                    "assets/images/water_requirement_green.png",
                    AppLocalizations.of(context)!.waterReq,
                  ),

                  featureCard("assets/images/yield.png",
                  AppLocalizations.of(context)!.yeildProduction
                  ),

                  featureCard(
                    "assets/images/weather_forecast.png",
                    AppLocalizations.of(context)!.weatherPrediction,
                  ),
                ],
              ),
              SizedBox(height: 30),

              // OUR MISSION SECTION
              Row(
                children: [
                  Text(
                    AppLocalizations.of(context)!.mission,
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
                      AppLocalizations.of(context)!.missionDesc,
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
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              softWrap: true,
              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }
}
