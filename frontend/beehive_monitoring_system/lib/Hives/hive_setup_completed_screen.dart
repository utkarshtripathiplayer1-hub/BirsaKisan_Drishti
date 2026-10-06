import 'package:beehive_monitoring_system/QrCode/qr_generation_screen.dart';
import 'package:beehive_monitoring_system/QrCode/qr_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:beehive_monitoring_system/Apiary/apiary_controller.dart';

class HiveSetupCompletedScreen extends StatelessWidget {
  const HiveSetupCompletedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ApiaryController apiaryController = Get.find<ApiaryController>();

    final QrController qrController = Get.put(QrController());

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.check_circle, size: 100, color: Colors.green),

                const SizedBox(height: 24),

                const Text(
                  'Hive Setup Completed!',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                ),

                const SizedBox(height: 12),

                const Text(
                  'All hives have been successfully added to your apiary.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16),
                ),

                const SizedBox(height: 40),

                SizedBox(
                  width: double.infinity,
                  child: GetBuilder<QrController>(
                    builder: (qrController) {
                      return ElevatedButton(
                        onPressed: qrController.isGeneratingQrs
                            ? null
                            : () async {
                                final success = await qrController
                                    .generateApiaryQrs();

                                if (success) {
                                  Get.to(() => const QrGenerationScreen());
                                }
                              },
                        child: qrController.isGeneratingQrs
                            ? const CircularProgressIndicator()
                            : const Text('Generate QR Codes'),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
