import 'dart:convert';

import 'package:beehive_monitoring_system/Apiary/apiary_controller.dart';
import 'package:beehive_monitoring_system/QrCode/qr_model.dart';
import 'package:beehive_monitoring_system/QrCode/qr_service.dart';
import 'package:get/get.dart';

class QrController extends GetxController {
  // -----------------------------
  // APIARY CONTROLLER
  // -----------------------------

  final ApiaryController apiaryController = Get.find<ApiaryController>();

  // -----------------------------
  // QR DATA
  // -----------------------------

  QrGenerationResponse? qrResponse;

  List<QrItem> qrItems = [];

  // -----------------------------
  // API STATE
  // -----------------------------

  bool isGeneratingQrs = false;

  // -----------------------------
  // GENERATE APIARY QRS
  // -----------------------------

  Future<bool> generateApiaryQrs() async {
    try {
      isGeneratingQrs = true;
      update();

      // Get APIARY ID
      final apiaryId = apiaryController.apiaryId;

      if (apiaryId == null || apiaryId.isEmpty) {
        Get.snackbar('Error', 'Apiary ID is missing.');

        return false;
      }

      // Call QR generation API
      final response = await QrService.generateApiaryQrs(apiaryId: apiaryId);

      // -----------------------------
      // SUCCESS
      // -----------------------------

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        qrResponse = QrGenerationResponse.fromJson(data);

        qrItems = qrResponse!.items;

        print('QRs generated: ${qrResponse!.generated}');
        print('Total hives: ${qrResponse!.total}');
        print('QR items: ${qrItems.length}');

        return true;
      }

      // -----------------------------
      // API ERROR
      // -----------------------------

      Get.snackbar(
        'Error',
        'Failed to generate QR codes. '
            'Status: ${response.statusCode}',
      );

      return false;
    } catch (e) {
      Get.snackbar('Error', 'Something went wrong: $e');

      return false;
    } finally {
      isGeneratingQrs = false;
      update();
    }
  }
}
