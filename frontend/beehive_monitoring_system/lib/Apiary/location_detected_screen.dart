import 'package:beehive_monitoring_system/Apiary/apiary_completed_screen.dart';
import 'package:beehive_monitoring_system/Apiary/apiary_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LocationDetectedScreen extends StatelessWidget {
  const LocationDetectedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ApiaryController>();

    return Scaffold(
      appBar: AppBar(title: const Text('Location Detected')),

      body: Padding(
        padding: const EdgeInsets.all(20),

        child: Column(
          children: [
            const Icon(Icons.location_on, size: 80, color: Colors.green),

            const SizedBox(height: 20),

            const Text(
              'Location Detected',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 10),

            const Text(
              'Please review the details below.',
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 30),

            Card(
              child: Padding(
                padding: const EdgeInsets.all(20),

                child: Column(
                  children: [
                    _locationRow('Country', controller.country),

                    _locationRow('State', controller.state),

                    _locationRow('District', controller.district),

                    _locationRow('Village', controller.village),

                    const Divider(),

                    _locationRow('Latitude', controller.latitude.toString()),

                    _locationRow('Longitude', controller.longitude.toString()),
                  ],
                ),
              ),
            ),

            const Spacer(),

            GetBuilder<ApiaryController>(
              builder: (controller) {
                return SizedBox(
                  width: double.infinity,

                  height: 55,

                  child: ElevatedButton(
                    onPressed: controller.isCreatingApiary
                        ? null
                        : () async {
                            // API CALL
                            final success = await controller.createApiary();

                            // Navigate ONLY
                            // after success
                            if (success) {
                              Get.off(() => const ApiaryCompletedScreen());
                            }
                          },

                    child: controller.isCreatingApiary
                        ? const SizedBox(
                            height: 25,
                            width: 25,
                            child: CircularProgressIndicator(strokeWidth: 3),
                          )
                        : const Text('Continue'),
                  ),
                );
              },
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _locationRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),

      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,

        children: [
          Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),

          Text(value),
        ],
      ),
    );
  }
}
