import 'package:flutter/material.dart';

class CropOutputPage extends StatelessWidget {
  final Map<String, dynamic> response;

  const CropOutputPage({
    super.key,
    required this.response,
  });

  Widget item(String title, dynamic value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        children: [
          Expanded(
            child: Text(title),
          ),
          Text(value.toString()),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final conditions =
        response["recommended_conditions"] ?? {};

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Crop Recommended", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 24),),
        iconTheme: const IconThemeData(
          color: Colors.white,
          size: 30,
          weight: 40.0,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,
          children: [

            item(
              "Recommended Crop",
              response["recommended_crop"],
            ),

            item(
              "Confidence",
              response["confidence"],
            ),

            item(
              "Recommended N",
              conditions["N"],
            ),

            item(
              "Recommended P",
              conditions["P"],
            ),

            item(
              "Recommended K",
              conditions["K"],
            ),

            item(
              "Recommended pH",
              conditions["pH"],
            ),

            item(
              "Recommended Temperature",
              conditions["temperature"],
            ),

            item(
              "Recommended Humidity",
              conditions["humidity"],
            ),

            item(
              "Recommended Soil Moisture",
              conditions["soil_moisture"],
            ),

            item(
              "Recommended Rainfall",
              conditions["rainfall"],
            ),

            item(
              "Recommended Solar Radiation",
              conditions["solar_radiation"],
            ),

            item(
              "Recommended Elevation",
              conditions["elevation"],
            ),
          ],
        ),
      ),
    );
  }
}
