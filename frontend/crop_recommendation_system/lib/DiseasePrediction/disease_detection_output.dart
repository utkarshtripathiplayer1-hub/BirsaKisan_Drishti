import 'package:flutter/material.dart';

class DiseaseDetectionOutput
    extends StatelessWidget {

  final Map<String, dynamic>
      response;

  const DiseaseDetectionOutput({
    super.key,
    required this.response,
  });

  @override
  Widget build(
      BuildContext context) {

    return Scaffold(

      appBar: AppBar(
        title: const Text(
            "Prediction Result"),
      ),

      body: SingleChildScrollView(
        padding:
            const EdgeInsets.all(
                16),

        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment
                  .start,
          children: [

            Text(
                "Crop Type : ${response["crop_type"]}"),

            Text(
                "Disease Name : ${response["disease_name"]}"),

            Text(
                "Mortality Rate : ${response["mortality_rate"]}"),

            const SizedBox(
                height: 10),

            Text(
                "Overview : ${response["overview"]}"),

            const SizedBox(
                height: 20),

            const Text(
                "Weather Conditions"),

            Text(
                "Temperature : ${response["weather_conditions"]["temperature"]}"),

            Text(
                "Humidity : ${response["weather_conditions"]["humidity"]}"),

            Text(
                "PH : ${response["weather_conditions"]["ph"]}"),

            const SizedBox(
                height: 20),

            const Text(
                "Precautions"),

            ...(response["precautions"]
                    as List)
                .map(
                  (e) => Text(
                      "• $e"),
                ),

            const SizedBox(
                height: 20),

            const Text(
                "Organic Cure"),

            ...(response["organic_cure"]
                    as List)
                .map(
                  (e) => Text(
                      "• $e"),
                ),

            const SizedBox(
                height: 20),

            const Text(
                "Chemical Cure"),

            ...(response["chemical_cure"]
                    as List)
                .map(
                  (e) => Text(
                      "• $e"),
                ),
          ],
        ),
      ),
    );
  }
}