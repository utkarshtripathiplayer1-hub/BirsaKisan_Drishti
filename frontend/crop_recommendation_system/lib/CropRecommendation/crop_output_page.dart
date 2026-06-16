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
        response["crop_details"] ?? {};

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
              response["crop_details"]["recommended_npk"]["N"],
            ),

            item(
              "Recommended P",
              response["crop_details"]["recommended_npk"]["P"],
            ),

            item(
              "Recommended K",
              response["crop_details"]["recommended_npk"]["K"],
            ),

            item(
              "Ideal pH",
              conditions["ideal_ph"],
            ),

            item(
              "Ideal Temperature",
              conditions["ideal_temperature"],
            ),

            item(
              "Ideal Humidity",
              conditions["ideal_humidity"],
            ),

            item(
              "Ideal Soil Moisture",
              conditions["ideal_soil_moisture"],
            ),

            item(
              "Water Requirement",
              conditions["water_requirement"],
            ),

            item(
              "Irrigation Frequency",
              conditions["irrigation_frequency"],
            ),

            item(
              "seasonal water need",
              conditions["seasonal_water_need"],
            ),

            item(
              "Season",
              conditions["season"],
            ),

            item(
              "Duration",
              conditions["duration"],
            ),
          ],
        ),
      ),
    );
  }
}
