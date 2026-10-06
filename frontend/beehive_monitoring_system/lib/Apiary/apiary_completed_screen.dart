import 'package:beehive_monitoring_system/Apiary/apiary_controller.dart';
import 'package:beehive_monitoring_system/Hives/hive_setup_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/route_manager.dart';

class ApiaryCompletedScreen extends StatelessWidget {
  const ApiaryCompletedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),

          child: Column(
            children: [
              const Spacer(),

              const Icon(Icons.check_circle, size: 120, color: Colors.green),

              const SizedBox(height: 30),

              const Text(
                'Apiary Set Up Completed',
                textAlign: TextAlign.center,

                style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 15),

              const Text(
                'Your apiary has been successfully created.',
                textAlign: TextAlign.center,
              ),

              const Spacer(),

              SizedBox(
                width: double.infinity,

                height: 55,

                child: ElevatedButton(
                  onPressed: () {
                    final controller = Get.find<ApiaryController>();

                    print("Apiary ID: ${controller.apiaryId}");
                    print("Hive Count: ${controller.hiveCount}");
                    Get.to(() => HiveSetupScreen());
                  },

                  child: const Text('Setup Hives Now'),
                ),
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
