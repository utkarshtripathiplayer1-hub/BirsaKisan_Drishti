import 'dart:io';
import 'package:crop_recommendation_system/CropRecommendation/crop_rotation_controller.dart';
import 'package:crop_recommendation_system/CropRecommendation/start_crop_service.dart';
import 'package:crop_recommendation_system/PdfGeneration/pdf_service.dart';
import 'package:crop_recommendation_system/l10n/app_localizations.dart';
import 'package:crop_recommendation_system/myFarm/my_farm.dart';
import 'package:flutter/material.dart';
import 'package:open_filex/open_filex.dart';

class CropOutputPage extends StatelessWidget {
  final CropRotationController _rotationController = CropRotationController();
  final dynamic recommendationId;
  final Map<String, dynamic> response;

  CropOutputPage({
    super.key,
    required this.response,
    required this.recommendationId,
  });
  Widget item(String title, dynamic value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        children: [
          Expanded(child: Text(title)),
          Text(value.toString()),
        ],
      ),
    );
  }

  Future<void> showCropRotation(BuildContext context) async {
    try {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Loading crop rotation...")));

      final data = await _rotationController.getCropRotation(
        recommendationId.toString(),
      );
      if (!context.mounted) return;
      showDialog(
        context: context,
        builder: (context) {
          Widget section(String title, Widget child) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.green.shade900,
                    ),
                  ),
                  const SizedBox(height: 6),
                  child,
                ],
              ),
            );
          }

          Widget bulletList(List<dynamic>? items) {
            if (items == null || items.isEmpty) {
              return const Text("N/A");
            }

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: items.map((item) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("• "),
                      Expanded(child: Text(item.toString(), softWrap: true)),
                    ],
                  ),
                );
              }).toList(),
            );
          }

          return AlertDialog(
            title: const Text(
              "Crop Rotation",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            content: SizedBox(
              width: double.maxFinite,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    section(
                      "Current Crop",
                      Text(data["current_crop"] ?? "N/A", softWrap: true),
                    ),

                    section(
                      "Recommended Next Crop",
                      Text(data["next_crop"] ?? "N/A", softWrap: true),
                    ),

                    section(
                      "Reason",
                      Text(data["reason"] ?? "N/A", softWrap: true),
                    ),

                    section(
                      "Benefits",
                      bulletList((data["benefits"] as List?)?.cast<dynamic>()),
                    ),

                    section(
                      "Avoid",
                      bulletList((data["avoid"] as List?)?.cast<dynamic>()),
                    ),
                  ],
                ),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("Close"),
              ),
            ],
          );
        },
      );
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  Future<void> generateAndOpenPdf(BuildContext context) async {
    try {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppLocalizations.of(context)!.pleaseWait)),
      );

      print('Recommendation ID = $recommendationId');

      File pdfFile = await PdfService.downloadPdf(recommendationId.toString());

      if (!context.mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('PDF downloaded')));

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Opening PDF...')));

      await OpenFilex.open(pdfFile.path);
    } catch (e) {
      if (!context.mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppLocalizations.of(context)!.error)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final conditions = response["crop_details"] ?? {};
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.green.shade900,
        title: Text(
          AppLocalizations.of(context)!.cropRecommendation,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
            fontSize: 24,
          ),
        ),
        iconTheme: const IconThemeData(
          color: Colors.white,
          size: 30,
          weight: 40.0,
        ),
      ),

      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsetsGeometry.all(10),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(height: 10),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(25),
                ),
                child: Column(
                  children: [
                    Text(
                      "Crop recommended Sucessfully",
                      textAlign: TextAlign.center,
                      maxLines: 3,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 25,
                      ),
                    ),
                    item(
                      "Recommended Crop",
                      response["recommended_crop"] ?? "N/A",
                    ),
                    SizedBox(height: 10),
                    item("Confidence", response["confidence"] ?? "N/A"),
                    SizedBox(height: 10),
                    TextButton(
                      onPressed: () => showCropRotation(context),
                      child: Text("Crop Rotation"),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 20),

              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(25),
                ),
                child: Column(
                  children: [
                    Text(
                      "Planting Information",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 25,
                      ),
                    ),

                    item("Season", conditions["season"]),

                    item("Water Requirement", conditions["water_requirement"]),

                    item(
                      "Irrigation Frequency",
                      conditions["irrigation_frequency"],
                    ),

                    item(
                      "seasonal water need",
                      conditions["seasonal_water_need"],
                    ),

                    item("Duration", conditions["duration"]),
                  ],
                ),
              ),

              SizedBox(height: 20),

              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(25),
                ),
                child: Column(
                  children: [
                    Text(
                      "Soil Information",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 25,
                      ),
                    ),

                    SizedBox(height: 5),

                    item("Ideal pH", conditions["ideal_ph"]),

                    item("Ideal Temperature", conditions["ideal_temperature"]),

                    item("Ideal Humidity", conditions["ideal_humidity"]),

                    item(
                      "Ideal Soil Moisture",
                      conditions["ideal_soil_moisture"],
                    ),
                  ],
                ),
              ),

              SizedBox(height: 20),

              SizedBox(
                height: 55,
                width: width * 0.8,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green.shade900,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  onPressed: () => generateAndOpenPdf(context),
                  child: Text(
                    "Generate PDF",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),

              SizedBox(height: 20),

              SizedBox(
                height: 55,
                width: width * 0.8,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green.shade900,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  onPressed: () async {
                    try {
                      await StartCrop.startCrop(recommendationId);
                      if (!context.mounted) return;
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const MyFarmPage()),
                      );
                    } catch (e) {
                      ScaffoldMessenger.of(
                        context,
                      ).showSnackBar(SnackBar(content: Text(e.toString())));
                    }
                  },
                  child: Text(
                    "Start Farming",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),

              // ElevatedButton(
              //   onPressed: () async {
              //     try {
              //       await StartCrop.startCrop(recommendationId);
              //       if (!context.mounted) return;
              //       Navigator.push(
              //         context,
              //         MaterialPageRoute(builder: (_) => const MyFarmPage()),
              //       );
              //     } catch (e) {
              //       ScaffoldMessenger.of(
              //         context,
              //       ).showSnackBar(SnackBar(content: Text(e.toString())));
              //     }
              //   },
              //   child: const Text("Start Farming"),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
