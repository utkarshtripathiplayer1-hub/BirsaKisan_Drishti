import 'dart:io';
import 'package:crop_recommendation_system/l10n/app_localizations.dart';
import 'package:flutter/material.dart';

class DiseaseDetectionOutput extends StatelessWidget {
  final Map<String, dynamic> response;
  final File imageFile;

  const DiseaseDetectionOutput({
    super.key,
    required this.response,
    required this.imageFile,
  });

  String formatDiseaseName(String? diseaseName) {
    if (diseaseName == null || diseaseName.trim().isEmpty) {
      return "Unknown Disease";
    }

    return diseaseName
        .split('_')
        .map(
          (word) => word.isEmpty
              ? word
              : word[0].toUpperCase() + word.substring(1).toLowerCase(),
        )
        .join(' ');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 170, 199, 164),
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context)!.diseaseDetection,
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Color(0xFF067A34),
        iconTheme: const IconThemeData(
          color: Colors.white,
          size: 30,
          weight: 40.0,
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        child: Column(
          children: [
            SizedBox(height: 15),
            Container(
              margin: const EdgeInsets.all(20),
              padding: const EdgeInsets.all(8), // White border thickness
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(22),
                child: Image.file(
                  imageFile,
                  width: double.infinity,
                  height: 250,
                  fit: BoxFit.cover,
                ),
              ),
            ),

            SizedBox(height: 20),

            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(25),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    formatDiseaseName(response['disease_name']?.toString()),
                    textAlign: TextAlign.start,
                    style: const TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF067A34),
                    ),
                  ),
                  Row(
                    children: [
                      Icon(Icons.favorite_border, color: Colors.red),
                      SizedBox(width: 5),
                      Text(
                        "${AppLocalizations.of(context)!.mortalityRate}: ${response["mortality_rate"] ?? "N/A"}",
                        style: const TextStyle(fontSize: 18),
                        textAlign: TextAlign.start,
                      ),
                    ],
                  ),
                  Text(
                    "${AppLocalizations.of(context)!.cropType}: ${response["crop_type"] ?? "N/A"}",
                    textAlign: TextAlign.start,
                    style: const TextStyle(fontSize: 18),
                  ),
                  Text(
                    "${AppLocalizations.of(context)!.diseaseStage}: ${response["disease_stage"] ?? "N/A"}",
                    textAlign: TextAlign.start,
                    style: const TextStyle(fontSize: 18),
                  ),
                  Text(
                    "${AppLocalizations.of(context)!.delete} : ${response["severity"] ?? "N/A"}",
                    textAlign: TextAlign.start,
                    style: const TextStyle(fontSize: 18),
                  ),
                ],
              ),
            ),

            SizedBox(height: 20),

            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(25),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppLocalizations.of(context)!.overview,
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),

                  const SizedBox(height: 10),

                  Text(response["overview"]),
                ],
              ),
            ),

            SizedBox(height: 20),

            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(25),
              ),

              child: Column(
                children: [
                  Row(
                    children: [
                      Image.asset(
                        "assets/images/weather_forecast.png",
                        height: 40,
                      ),

                      const SizedBox(width: 10),

                      Text(
                        AppLocalizations.of(context)!.weatherCondition,
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Column(
                        children: [
                          Icon(
                            Icons.thermostat,
                            size: 40,
                            color: Colors.green.shade700,
                          ),

                          // Text(response["weather_conditions"]["temperature"]),
                          Text(
                            response["weather_conditions"]?["temperature"]
                                    ?.toString() ??
                                "N/A",
                          ),
                        ],
                      ),

                      Column(
                        children: [
                          Icon(
                            Icons.water_drop,
                            size: 40,
                            color: Colors.green.shade700,
                          ),

                          // Text(response["weather_conditions"]["humidity"]),
                          Text(
                            response["weather_conditions"]?["humidity"]
                                    ?.toString() ??
                                "N/A",
                          ),
                        ],
                      ),

                      Column(
                        children: [
                          Icon(
                            Icons.science,
                            size: 40,
                            color: Colors.green.shade700,
                          ),

                          // Text(response["weather_conditions"]["pH"]),
                          Text(
                            response["weather_conditions"]?["ph"]?.toString() ??
                                "N/A",
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),

            SizedBox(height: 20),

            buildListContainer(
              title: AppLocalizations.of(context)!.precaution,
              icon: Icons.warning,
              iconColor: Colors.red,
              data: response["precautions"],
            ),

            const SizedBox(height: 20),

            buildListContainer(
              title: AppLocalizations.of(context)!.organicCure,
              icon: Icons.eco,
              iconColor: Colors.green,
              data: response["organic_cure"],
            ),

            const SizedBox(height: 20),

            buildListContainer(
              title: AppLocalizations.of(context)!.inOrganicCure,
              icon: Icons.medication,
              iconColor: Colors.blue,
              data: response["chemical_cure"],
            ),

            const SizedBox(height: 50),
          ],
        ),
      ),
    );
  }

  Widget buildListContainer({
    required String title,
    required IconData icon,
    required Color iconColor,
    required List data,
  }) {
    return Container(
      width: double.infinity,

      padding: const EdgeInsets.all(20),

      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 35, color: iconColor),

              const SizedBox(width: 10),

              Text(
                title,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),

          const SizedBox(height: 15),

          ...data.map(
            (e) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Text("• $e"),
            ),
          ),
        ],
      ),
    );
  }
}
