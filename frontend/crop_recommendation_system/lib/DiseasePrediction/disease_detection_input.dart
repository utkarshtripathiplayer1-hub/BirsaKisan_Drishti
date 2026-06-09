import 'dart:io';
import 'package:crop_recommendation_system/DiseasePrediction/disease_detection_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'disease_detection_output.dart';

class DiseaseDetectionInput
    extends StatelessWidget {

  DiseaseDetectionInput(
      {super.key});

  final ImagePicker
      _picker =
      ImagePicker();

  final DiseaseDetectionController
      controller = Get.put(
          DiseaseDetectionController());

  Future<void>
      pickImage(
      ImageSource source) async {

    final XFile? image =
        await _picker.pickImage(
      source: source,
    );

    if (image == null) {
      return;
    }

    final response =
        await controller
            .uploadImage(
      File(image.path),
    );

    Get.to(
      () =>
          DiseaseDetectionOutput(
        response:
            response,
      ),
    );
  }

  @override
  Widget build(
      BuildContext context) {

    return Scaffold(

      appBar: AppBar(
        title: const Text(
            "Disease Detection"),
      ),

      body: Center(
        child: Column(
          mainAxisAlignment:
              MainAxisAlignment
                  .center,
          children: [

            ElevatedButton(
              onPressed: () {
                pickImage(
                    ImageSource
                        .gallery);
              },
              child: const Text(
                  "Pick From Gallery"),
            ),

            const SizedBox(
                height: 20),

            ElevatedButton(
              onPressed: () {
                pickImage(
                    ImageSource
                        .camera);
              },
              child: const Text(
                  "Open Camera"),
            ),

            const SizedBox(
                height: 20),

            Obx(
              () => controller
                      .isLoading
                      .value
                  ? const CircularProgressIndicator()
                  : const SizedBox(),
            ),
          ],
        ),
      ),
    );
  }
}