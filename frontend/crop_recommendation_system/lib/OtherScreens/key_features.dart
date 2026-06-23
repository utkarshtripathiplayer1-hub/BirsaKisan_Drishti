import 'package:crop_recommendation_system/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';

class KeyFeatures extends StatelessWidget {
  const KeyFeatures({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 58, 108, 75),

      appBar: AppBar(
        title: AutoSizeText(
          AppLocalizations.of(context)!.keyFeatures,
          minFontSize: 15,
          style: TextStyle(
            fontSize: 35,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.green.shade900,
        iconTheme: const IconThemeData(
          color: Colors.white,
          size: 30,
          weight: 40.0,
        ),
        elevation: 0,
      ),

      body: SingleChildScrollView(
        child: Column(
          children: [
            // GREEN HEADER SECTION
            Container(
              width: double.infinity,
              color: const Color.fromARGB(255, 58, 108, 75),
              padding: const EdgeInsets.only(left: 15, right: 15, bottom: 30),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Column(
                          children: [
                            Text(
                              AppLocalizations.of(context)!.appName,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 30,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),

                            SizedBox(height: 5),

                            Text(
                              AppLocalizations.of(context)!.caption,
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 25),

                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Text(
                      AppLocalizations.of(context)!.caption2,
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 20, color: Colors.white),
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

                  Text(
                    AppLocalizations.of(context)!.features,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1E5C37),
                    ),
                  ),

                  const SizedBox(height: 25),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: GridView.count(
                      crossAxisCount: 2,
                      crossAxisSpacing: 15,
                      mainAxisSpacing: 15,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      childAspectRatio: 0.82,
                      children: [
                        FeatureCard(
                          imagePath: "assets/images/crop_recommendation.png",
                          title: AppLocalizations.of(
                            context,
                          )!.cropRecommendation,
                          description: AppLocalizations.of(context)!.cropDesc,
                        ),
                        FeatureCard(
                          imagePath: "assets/images/disease_detection.png",
                          title: AppLocalizations.of(context)!.diseaseDetection,
                          description: AppLocalizations.of(
                            context,
                          )!.diseaseDetectionDesc,
                        ),
                        FeatureCard(
                          imagePath: "assets/images/water_requirement.png",
                          title: AppLocalizations.of(context)!.waterReq,
                          description: AppLocalizations.of(
                            context,
                          )!.waterReqDesc,
                        ),
                        FeatureCard(
                          imagePath: "assets/images/weather_forecast.png",
                          title: AppLocalizations.of(context)!.weatherForecast,
                          description: AppLocalizations.of(
                            context,
                          )!.weatherForecastDesc,
                        ),
                        FeatureCard(
                          imagePath: "assets/images/market_price.png",
                          title: AppLocalizations.of(
                            context,
                          )!.marketPriceFeature,
                          description: AppLocalizations.of(
                            context,
                          )!.marketPriceDesc,
                        ),
                        FeatureCard(
                          imagePath: "assets/images/government_scheme.png",
                          title: AppLocalizations.of(context)!.govtSchemes,
                          description: AppLocalizations.of(
                            context,
                          )!.govtSchemesDesc,
                        ),
                        FeatureCard(
                          imagePath: "assets/images/crop_calendar.png",
                          title: AppLocalizations.of(context)!.cropCalendar,
                          description: AppLocalizations.of(
                            context,
                          )!.cropCalendarDesc,
                        ),
                        FeatureCard(
                          imagePath: "assets/images/task_reminder.png",
                          title: AppLocalizations.of(context)!.reminder,
                          description: AppLocalizations.of(
                            context,
                          )!.reminderDesc,
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
          BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(2, 4)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset(imagePath, height: 55, width: 55),

          const SizedBox(height: 12),

          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 8),

          Flexible(
            child: Text(
              textAlign: TextAlign.center,
              overflow: TextOverflow.fade,
              description,
              style: const TextStyle(fontSize: 13, height: 1.3),
            ),
          ),
        ],
      ),
    );
  }
}
