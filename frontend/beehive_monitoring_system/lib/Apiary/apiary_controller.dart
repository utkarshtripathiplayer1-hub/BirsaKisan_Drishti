import 'package:beehive_monitoring_system/Apiary/apiary_model.dart';
import 'package:beehive_monitoring_system/Apiary/apiary_service.dart';
import 'package:get/get.dart';

class ApiaryController extends GetxController {
  // -----------------------------
  // SCREEN 1: BASIC INFORMATION
  // -----------------------------

  String apiaryName = '';
  String description = '';
  int targetHiveCount = 1;
  String hiveType = '';

  // -----------------------------
  // SCREEN 2: LOCATION
  // -----------------------------

  String country = '';
  String state = '';
  String district = '';
  String village = '';

  // -----------------------------
  // LOCATION COORDINATES
  // -----------------------------

  double? latitude;
  double? longitude;

  // -----------------------------
  // API STATE
  // -----------------------------

  bool isCreatingApiary = false;

  // -----------------------------
  // SCREEN 1 DATA
  // -----------------------------

  void saveBasicInformation({
    required String name,
    required String description,
    required int hiveCount,
    required String hiveType,
  }) {
    apiaryName = name;
    this.description = description;
    targetHiveCount = hiveCount;
    this.hiveType = hiveType;
  }

  // -----------------------------
  // SCREEN 2 DATA
  // -----------------------------

  void saveLocation({
    required String country,
    required String state,
    required String district,
    required String village,
  }) {
    this.country = country;
    this.state = state;
    this.district = district;
    this.village = village;
  }

  // -----------------------------
  // GPS LOCATION
  // -----------------------------

  void saveCoordinates({required double latitude, required double longitude}) {
    this.latitude = latitude;
    this.longitude = longitude;
  }

  // -----------------------------
  // CREATE APIARY
  // CALLED FROM SCREEN 3
  // -----------------------------

  Future<bool> createApiary() async {
    try {
      isCreatingApiary = true;
      update();

      // Check if coordinates exist
      if (latitude == null || longitude == null) {
        Get.snackbar('Location Error', 'Location coordinates are missing.');

        return false;
      }

      // Create model
      final apiary = ApiaryModel(
        name: apiaryName,
        description: description,
        targetHiveCount: targetHiveCount,
        hiveType: hiveType,
        latitude: latitude!,
        longitude: longitude!,
        country: country,
        state: state,
        district: district,
        village: village,
      );

      // Call backend
      final response = await ApiaryService.createApiary(apiary: apiary);

      // Backend returns 201
      if (response.statusCode == 201) {
        return true;
      }

      // Other response
      Get.snackbar(
        'Error',
        'Failed to create apiary. Status: ${response.statusCode}',
      );

      return false;
    } catch (e) {
      Get.snackbar('Error', 'Something went wrong: $e');

      return false;
    } finally {
      isCreatingApiary = false;
      update();
    }
  }
}
