import 'package:beehive_monitoring_system/Authentication/secure_storage_service.dart';
import 'package:beehive_monitoring_system/OtherScreens/dashboard.dart';
import 'package:beehive_monitoring_system/QrCode/qr_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class QrGenerationScreen extends StatefulWidget {
  const QrGenerationScreen({super.key});

  @override
  State<QrGenerationScreen> createState() => _QrGenerationScreenState();
}

class _QrGenerationScreenState extends State<QrGenerationScreen> {
  String? accessToken;

  @override
  void initState() {
    super.initState();
    loadAccessToken();
  }

  Future<void> loadAccessToken() async {
    final token = await SecureStorageService.getAccessToken();

    if (!mounted) return;

    setState(() {
      accessToken = token;
    });
  }

  @override
  Widget build(BuildContext context) {
    final QrController qrController = Get.find<QrController>();

    return Scaffold(
      appBar: AppBar(title: const Text('QR Codes')),

      body: GetBuilder<QrController>(
        builder: (controller) {
          // --------------------------------
          // NO QR DATA
          // --------------------------------

          if (controller.qrItems.isEmpty) {
            return const Center(child: Text('No QR codes found.'));
          }

          // --------------------------------
          // TOKEN STILL LOADING
          // --------------------------------

          if (accessToken == null) {
            return const Center(child: CircularProgressIndicator());
          }

          // --------------------------------
          // QR LIST
          // --------------------------------

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: controller.qrItems.length + 1,

            itemBuilder: (context, index) {
              if (index == controller.qrItems.length) {
                return Padding(
                  padding: const EdgeInsets.only(top: 8, bottom: 20),
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        Get.to(() => const HomePage());
                      },
                      child: const Text('Continue'),
                    ),
                  ),
                );
              }
              final qr = controller.qrItems[index];

              return Card(
                margin: const EdgeInsets.only(bottom: 20),
                child: Padding(
                  padding: const EdgeInsets.all(16),

                  child: Column(
                    children: [
                      // -------------------------
                      // HIVE NAME
                      // -------------------------

                      Text(
                        qr.hiveName,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 16),

                      // -------------------------
                      // QR IMAGE
                      // -------------------------
                      Image.network(
                        qr.fullImageUrl,

                        width: 220,
                        height: 220,

                        headers: {'Authorization': 'Bearer $accessToken'},

                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) {
                            return child;
                          }

                          return const SizedBox(
                            width: 220,
                            height: 220,
                            child: Center(child: CircularProgressIndicator()),
                          );
                        },

                        errorBuilder: (context, error, stackTrace) {
                          debugPrint('QR Image URL: ${qr.fullImageUrl}');

                          debugPrint('QR Image Error: $error');

                          debugPrint('QR Image StackTrace: $stackTrace');

                          return const SizedBox(
                            width: 220,
                            height: 220,
                            child: Center(
                              child: Text(
                                'Unable to load QR code',
                                textAlign: TextAlign.center,
                              ),
                            ),
                          );
                        },
                      ),

                      const SizedBox(height: 16),

                      // -------------------------
                      // HIVE ID
                      // -------------------------
                      Text(
                        'Hive ID: ${qr.hiveId}',
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
