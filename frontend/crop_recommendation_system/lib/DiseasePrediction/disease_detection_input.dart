import 'dart:io';
import 'package:crop_recommendation_system/DiseasePrediction/disease_detection_controller.dart';
import 'package:crop_recommendation_system/DiseasePrediction/disease_detection_output.dart';
import 'package:crop_recommendation_system/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class DiseaseDetectionInput extends StatelessWidget {
  DiseaseDetectionInput({super.key});

  final ImagePicker _picker = ImagePicker();

  final DiseaseDetectionController controller = Get.put(
    DiseaseDetectionController(),
  );

  Future<void> pickImage(ImageSource source) async {
    final XFile? image = await _picker.pickImage(source: source);

    if (image == null) {
      return;
    }

    final response = await controller.uploadImage(File(image.path));

    Get.to(
      () => DiseaseDetectionOutput(
        response: response,
        imageFile: File(image.path),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white,size: 30,weight: 40.0,),
        title: Text( AppLocalizations.of(context)!.diseaseDetection,
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.green.shade900,
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  // color: Colors.white,
                  borderRadius: BorderRadius.circular(25),
                ),
                child: Center(
                  child: Text(
                    AppLocalizations.of(context)!.uploadImage,
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                  ),
                ),
              ),
            ),
            
            SizedBox(height: 20),

            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                // color: Colors.white,
                borderRadius: BorderRadius.circular(25),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  GestureDetector(
                    onTap: () {
                      pickImage(ImageSource.gallery);
                    },
                    child: Icon(Icons.photo_library, size: 70, color: const Color.fromARGB(255, 23, 76, 26),),
                  ),

                  GestureDetector(
                    onTap: () {
                      pickImage(ImageSource.camera);
                    },
                    child: Icon(Icons.camera_alt, size: 70, color: const Color.fromARGB(255, 23, 76, 26),),
                  ),
                  Obx(
                    () => controller.isLoading.value
                        ? const CircularProgressIndicator()
                        : const SizedBox(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
