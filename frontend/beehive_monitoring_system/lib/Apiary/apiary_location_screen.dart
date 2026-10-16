import 'package:beehive_monitoring_system/Apiary/apiary_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'location_detected_screen.dart';

class ApiaryLocationScreen extends StatefulWidget {
  const ApiaryLocationScreen({super.key});

  @override
  State<ApiaryLocationScreen> createState() => _ApiaryLocationScreenState();
}

class _ApiaryLocationScreenState extends State<ApiaryLocationScreen> {
  // Get the existing ApiaryController
  final ApiaryController controller = Get.find<ApiaryController>();

  // Village input controller
  final villageController = TextEditingController();

  // Latitude input controller
  final latitudeController = TextEditingController();

  // Longitude input controller
  final longitudeController = TextEditingController();

  // Default values
  String country = 'India';

  String state = 'Haryana';

  String district = 'Faridabad';

  // ==========================================
  // CONTINUE BUTTON
  // ==========================================

  void continueToReview() {
    // ------------------------------------------
    // GET LATITUDE FROM USER INPUT
    // ------------------------------------------

    final latitude = double.tryParse(latitudeController.text.trim());

    // ------------------------------------------
    // GET LONGITUDE FROM USER INPUT
    // ------------------------------------------

    final longitude = double.tryParse(longitudeController.text.trim());

    // ------------------------------------------
    // CHECK LATITUDE
    // ------------------------------------------

    if (latitude == null) {
      Get.snackbar(
        'Invalid Latitude',
        'Please enter a valid latitude.',
        snackPosition: SnackPosition.BOTTOM,
      );

      return;
    }

    // ------------------------------------------
    // CHECK LONGITUDE
    // ------------------------------------------

    if (longitude == null) {
      Get.snackbar(
        'Invalid Longitude',
        'Please enter a valid longitude.',
        snackPosition: SnackPosition.BOTTOM,
      );

      return;
    }

    // ------------------------------------------
    // CHECK LATITUDE RANGE
    // Latitude must be between -90 and 90
    // ------------------------------------------

    if (latitude < -90 || latitude > 90) {
      Get.snackbar(
        'Invalid Latitude',
        'Latitude must be between -90 and 90.',
        snackPosition: SnackPosition.BOTTOM,
      );

      return;
    }

    // ------------------------------------------
    // CHECK LONGITUDE RANGE
    // Longitude must be between -180 and 180
    // ------------------------------------------

    if (longitude < -180 || longitude > 180) {
      Get.snackbar(
        'Invalid Longitude',
        'Longitude must be between -180 and 180.',
        snackPosition: SnackPosition.BOTTOM,
      );

      return;
    }

    // ------------------------------------------
    // SAVE COUNTRY, STATE, DISTRICT & VILLAGE
    // ------------------------------------------

    controller.saveLocation(
      country: country,
      state: state,
      district: district,
      village: villageController.text.trim().isEmpty
          ? 'No village'
          : villageController.text.trim(),
    );

    // ------------------------------------------
    // SAVE LATITUDE & LONGITUDE
    // ------------------------------------------

    controller.latitude = latitude;

    controller.longitude = longitude;

    // ------------------------------------------
    // PRINT DATA FOR DEBUGGING
    // ------------------------------------------

    print('==============================');
    print('LOCATION DATA');
    print('Country: $country');
    print('State: $state');
    print('District: $district');
    print('Village: ${villageController.text.trim()}');
    print('Latitude: $latitude');
    print('Longitude: $longitude');
    print('==============================');

    // ------------------------------------------
    // GO TO SCREEN 3
    // ------------------------------------------

    Get.to(() => const LocationDetectedScreen());
  }

  // ==========================================
  // DISPOSE CONTROLLERS
  // ==========================================

  @override
  void dispose() {
    villageController.dispose();
    latitudeController.dispose();
    longitudeController.dispose();

    super.dispose();
  }

  // ==========================================
  // UI
  // ==========================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // ========================================
      // APP BAR
      // ========================================
      appBar: AppBar(title: const Text('Location')),

      // ========================================
      // BODY
      // ========================================
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            // ==================================
            // TITLE
            // ==================================
            const Text(
              'Apiary Location',

              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 30),

            // ==================================
            // COUNTRY
            // ==================================
            const Text(
              'Country',

              style: TextStyle(fontWeight: FontWeight.w500),
            ),

            const SizedBox(height: 8),

            DropdownButtonFormField<String>(
              initialValue: country,

              decoration: const InputDecoration(border: OutlineInputBorder()),

              items: const [
                DropdownMenuItem(value: 'India', child: Text('India')),
              ],

              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    country = value;
                  });
                }
              },
            ),

            const SizedBox(height: 20),

            // ==================================
            // STATE
            // ==================================
            const Text('State', style: TextStyle(fontWeight: FontWeight.w500)),

            const SizedBox(height: 8),

            DropdownButtonFormField<String>(
              initialValue: state,

              decoration: const InputDecoration(border: OutlineInputBorder()),

              items: const [
                DropdownMenuItem(value: 'Haryana', child: Text('Haryana')),

                DropdownMenuItem(value: 'Delhi', child: Text('Delhi')),

                DropdownMenuItem(
                  value: 'Uttar Pradesh',

                  child: Text('Uttar Pradesh'),
                ),
              ],

              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    state = value;
                  });
                }
              },
            ),

            const SizedBox(height: 20),

            // ==================================
            // DISTRICT
            // ==================================
            const Text(
              'District',

              style: TextStyle(fontWeight: FontWeight.w500),
            ),

            const SizedBox(height: 8),

            DropdownButtonFormField<String>(
              initialValue: district,

              decoration: const InputDecoration(border: OutlineInputBorder()),

              items: const [
                DropdownMenuItem(value: 'Faridabad', child: Text('Faridabad')),

                DropdownMenuItem(value: 'Gurugram', child: Text('Gurugram')),

                DropdownMenuItem(value: 'New Delhi', child: Text('New Delhi')),
              ],

              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    district = value;
                  });
                }
              },
            ),

            const SizedBox(height: 20),

            // ==================================
            // VILLAGE / CITY
            // ==================================
            TextField(
              controller: villageController,

              decoration: const InputDecoration(
                labelText: 'Village / City',

                hintText: 'Enter village or city',

                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 20),

            // ==================================
            // LATITUDE
            // ==================================
            TextField(
              controller: latitudeController,

              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
                signed: true,
              ),

              decoration: const InputDecoration(
                labelText: 'Latitude',

                hintText: 'Example: 28.4089',

                helperText: 'Value must be between -90 and 90',

                border: OutlineInputBorder(),

                prefixIcon: Icon(Icons.north),
              ),
            ),

            const SizedBox(height: 20),

            // ==================================
            // LONGITUDE
            // ==================================
            TextField(
              controller: longitudeController,

              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
                signed: true,
              ),

              decoration: const InputDecoration(
                labelText: 'Longitude',

                hintText: 'Example: 77.3178',

                helperText: 'Value must be between -180 and 180',

                border: OutlineInputBorder(),

                prefixIcon: Icon(Icons.east),
              ),
            ),

            const SizedBox(height: 40),

            // ==================================
            // CONTINUE BUTTON
            // ==================================
            SizedBox(
              width: double.infinity,

              height: 55,

              child: ElevatedButton(
                onPressed: continueToReview,

                child: const Text('Continue', style: TextStyle(fontSize: 16)),
              ),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
