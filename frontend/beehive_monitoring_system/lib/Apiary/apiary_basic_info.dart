import 'package:beehive_monitoring_system/Apiary/apiary_controller.dart';
import 'package:beehive_monitoring_system/Apiary/apiary_location_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ApiaryInfoScreen extends StatefulWidget {
  const ApiaryInfoScreen({super.key});

  @override
  State<ApiaryInfoScreen> createState() => _ApiaryInfoScreenState();
}

class _ApiaryInfoScreenState extends State<ApiaryInfoScreen> {
  final ApiaryController controller = Get.put(ApiaryController());

  final nameController = TextEditingController();

  final descriptionController = TextEditingController();

  int hiveCount = 1;

  String selectedHiveType = 'langstroth';

  @override
  void dispose() {
    nameController.dispose();
    descriptionController.dispose();

    super.dispose();
  }

  void continueToLocation() {
    if (nameController.text.trim().isEmpty) {
      Get.snackbar('Missing Information', 'Please enter apiary name.');

      return;
    }

    controller.saveBasicInformation(
      name: nameController.text.trim(),
      description: descriptionController.text.trim(),
      hiveCount: hiveCount,
      hiveType: selectedHiveType,
    );

    Get.to(() => const ApiaryLocationScreen());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Set Up Apiary')),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            const Text(
              'Basic Information',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 30),

            TextField(
              controller: nameController,

              decoration: const InputDecoration(
                labelText: 'Apiary Name',
                hintText: 'Enter apiary name',
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 20),

            TextField(
              controller: descriptionController,

              maxLines: 3,

              decoration: const InputDecoration(
                labelText: 'Description',
                hintText: 'Enter description',
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 25),

            const Text(
              'Number of Hives',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),

            Row(
              children: [
                IconButton(
                  onPressed: () {
                    if (hiveCount > 1) {
                      setState(() {
                        hiveCount--;
                      });
                    }
                  },

                  icon: const Icon(Icons.remove_circle),
                ),

                Text('$hiveCount', style: const TextStyle(fontSize: 20)),

                IconButton(
                  onPressed: () {
                    setState(() {
                      hiveCount++;
                    });
                  },

                  icon: const Icon(Icons.add_circle),
                ),
              ],
            ),

            const SizedBox(height: 20),

            const Text(
              'Hive Type',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 10),

            DropdownButtonFormField<String>(
              value: selectedHiveType,

              decoration: const InputDecoration(border: OutlineInputBorder()),

              items: const [
                DropdownMenuItem(
                  value: 'langstroth',
                  child: Text('Langstroth'),
                ),

                DropdownMenuItem(value: 'top-bar', child: Text('Top-Bar')),

                DropdownMenuItem(value: 'warre', child: Text('Warre')),
              ],

              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    selectedHiveType = value;
                  });
                }
              },
            ),

            const SizedBox(height: 40),

            SizedBox(
              width: double.infinity,

              child: ElevatedButton(
                onPressed: continueToLocation,

                child: const Text('Continue'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
