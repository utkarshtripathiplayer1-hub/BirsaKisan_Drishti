import 'package:beehive_monitoring_system/Hives/hive_setup_completed_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:beehive_monitoring_system/Hives/hive_controller.dart';

class HiveSetupScreen extends StatefulWidget {
  const HiveSetupScreen({super.key});

  @override
  State<HiveSetupScreen> createState() => _HiveSetupScreenState();
}

class _HiveSetupScreenState extends State<HiveSetupScreen> {
  final HiveController controller = Get.put(HiveController());

  late List<TextEditingController> nameControllers;
  late List<TextEditingController> descriptionControllers;

  @override
  void initState() {
    super.initState();

    // Create hive data according to hive count
    controller.initializeHives();

    nameControllers = List.generate(
      controller.apiaryController.hiveCount,
      (index) => TextEditingController(),
    );

    descriptionControllers = List.generate(
      controller.apiaryController.hiveCount,
      (index) => TextEditingController(),
    );
  }

  @override
  void dispose() {
    for (final controller in nameControllers) {
      controller.dispose();
    }

    for (final controller in descriptionControllers) {
      controller.dispose();
    }

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final hiveCount = controller.apiaryController.hiveCount;

    return Scaffold(
      appBar: AppBar(title: const Text('Setup Hives')),

      body: GetBuilder<HiveController>(
        builder: (controller) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Text(
                  'Setup $hiveCount Hives',
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 20),

                // --------------------------------
                // HIVE CARDS
                // --------------------------------
                ListView.builder(
                  itemCount: hiveCount,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),

                  itemBuilder: (context, index) {
                    return _buildHiveCard(index, controller);
                  },
                ),

                const SizedBox(height: 20),

                if (controller.isCreatingHives)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Text(
                      '${controller.createdHiveCount} of ${controller.hives.length} hives created',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),

                // --------------------------------
                // SAVE ALL HIVES
                // --------------------------------
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: controller.isCreatingHives
                        ? null
                        : _saveAllHives,
                    child: controller.isCreatingHives
                        ? Text(
                            'Creating Hive ${controller.currentHiveIndex + 1} '
                            'of ${controller.hives.length}...',
                          )
                        : const Text('Save All Hives'),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  // --------------------------------
  // HIVE CARD
  // --------------------------------

  Widget _buildHiveCard(int index, HiveController controller) {
    return Card(
      margin: const EdgeInsets.only(bottom: 20),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Hive ${index + 1}',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 16),

            // -----------------------------
            // HIVE NAME
            // -----------------------------
            TextField(
              controller: nameControllers[index],
              decoration: const InputDecoration(
                labelText: 'Hive Name',
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 16),

            // -----------------------------
            // DESCRIPTION
            // -----------------------------
            TextField(
              controller: descriptionControllers[index],
              maxLines: 3,
              decoration: const InputDecoration(
                labelText: 'Hive Description',
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  // --------------------------------
  // SAVE ALL HIVES
  // --------------------------------

  Future<void> _saveAllHives() async {
    // --------------------------------
    // VALIDATE ALL HIVES
    // --------------------------------

    for (int i = 0; i < controller.hives.length; i++) {
      final name = nameControllers[i].text.trim();
      final description = descriptionControllers[i].text.trim();

      // Check hive name
      if (name.isEmpty) {
        Get.snackbar(
          'Missing Information',
          'Please enter a name for Hive ${i + 1}.',
        );
        return;
      }

      // Check description
      if (description.isEmpty) {
        Get.snackbar(
          'Missing Information',
          'Please enter a description for Hive ${i + 1}.',
        );
        return;
      }
    }

    // --------------------------------
    // SAVE DATA TO CONTROLLER
    // --------------------------------

    for (int i = 0; i < controller.hives.length; i++) {
      controller.updateHive(
        index: i,
        name: nameControllers[i].text.trim(),
        description: descriptionControllers[i].text.trim(),
      );
    }

    // --------------------------------
    // CREATE ALL HIVES
    // --------------------------------

    final success = await controller.createAllHives();

    if (success) {
      if (success) {
        Get.to(() => const HiveSetupCompletedScreen());
      }
    }
  }
}
