import 'dart:io';
import 'package:crop_recommendation_system/DiseasePrediction/disease_detection_service.dart';
import 'package:get/get.dart';


class DiseaseDetectionController
    extends GetxController {

  final DiseaseDetectionService
      _service =
      DiseaseDetectionService();

  RxBool isLoading =
      false.obs;

  Future<Map<String, dynamic>>
      uploadImage(
      File imageFile) async {

    try {

      isLoading.value =
          true;

      final response =
          await _service
              .predictDisease(
                  imageFile);

      return response;

    } finally {

      isLoading.value =
          false;
    }
  }
}