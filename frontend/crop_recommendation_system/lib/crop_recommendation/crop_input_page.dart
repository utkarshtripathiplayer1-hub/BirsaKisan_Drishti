import 'package:flutter/material.dart';

import 'crop_recommend_controller.dart';
import 'crop_output_page.dart';

class CropInputPage extends StatefulWidget {
  const CropInputPage({super.key});

  @override
  State<CropInputPage> createState() =>
      _CropInputPageState();
}

class _CropInputPageState
    extends State<CropInputPage> {

  final controller = CropRecommendController();

  final nController = TextEditingController();
  final pController = TextEditingController();
  final kController = TextEditingController();
  final phController = TextEditingController();

  final soilMoistureController =
      TextEditingController();

  final temperatureController =
      TextEditingController();

  final humidityController =
      TextEditingController();

  final rainfallController =
      TextEditingController();

  final solarRadiationController =
      TextEditingController();

  final elevationController =
      TextEditingController();

  final irrigationController =
      TextEditingController();

  final previousCropController =
      TextEditingController();

  bool isLoading = false;

  Future<void> submit() async {

    setState(() {
      isLoading = true;
    });

    try {

      final result =
          await controller.recommendCrop(
        n: double.parse(
            nController.text),
        p: double.parse(
            pController.text),
        k: double.parse(
            kController.text),
        ph: double.parse(
            phController.text),
        soilMoisture: double.parse(
            soilMoistureController.text),
        temperature: double.parse(
            temperatureController.text),
        humidity: double.parse(
            humidityController.text),
        rainfall: double.parse(
            rainfallController.text),
        solarRadiation: double.parse(
            solarRadiationController.text),
        elevation: double.parse(
            elevationController.text),
        irrigation:
            irrigationController.text,
        previousCrop:
            previousCropController.text,
      );

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) =>
              CropOutputPage(
            response: result,
          ),
        ),
      );

    } catch (e) {

      ScaffoldMessenger.of(context)
          .showSnackBar(
        SnackBar(
          content: Text(e.toString()),
        ),
      );

    } finally {

      setState(() {
        isLoading = false;
      });
    }
  }

  Widget buildField(
      String label,
      TextEditingController controller) {

    return Padding(
      padding:
          const EdgeInsets.symmetric(
              vertical: 5),
      child: TextField(
        controller: controller,
        decoration:
            InputDecoration(
          labelText: label,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title:
            const Text("Crop Input"),
      ),
      body: SingleChildScrollView(
        padding:
            const EdgeInsets.all(16),
        child: Column(
          children: [

            buildField("N",
                nController),

            buildField("P",
                pController),

            buildField("K",
                kController),

            buildField("pH",
                phController),

            buildField(
              "Soil Moisture",
              soilMoistureController,
            ),

            buildField(
              "Temperature",
              temperatureController,
            ),

            buildField(
              "Humidity",
              humidityController,
            ),

            buildField(
              "Rainfall",
              rainfallController,
            ),

            buildField(
              "Solar Radiation",
              solarRadiationController,
            ),

            buildField(
              "Elevation",
              elevationController,
            ),

            buildField(
              "Irrigation",
              irrigationController,
            ),

            buildField(
              "Previous Crop",
              previousCropController,
            ),

            const SizedBox(
                height: 20),

            ElevatedButton(
              onPressed:
                  isLoading
                      ? null
                      : submit,
              child: Text(
                isLoading
                    ? "Loading..."
                    : "Get Recommendation",
              ),
            ),
          ],
        ),
      ),
    );
  }
}