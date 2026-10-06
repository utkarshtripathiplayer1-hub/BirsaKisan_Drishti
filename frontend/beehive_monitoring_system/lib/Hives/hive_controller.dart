import 'package:beehive_monitoring_system/Apiary/apiary_controller.dart';
import 'package:beehive_monitoring_system/Hives/hive_model.dart';
import 'package:beehive_monitoring_system/Hives/hive_service.dart';
import 'package:get/get.dart';

class HiveController extends GetxController {
  // -----------------------------
  // APIARY
  // -----------------------------

  final ApiaryController apiaryController = Get.find<ApiaryController>();

  // -----------------------------
  // HIVE FORM DATA
  // -----------------------------

  List<HiveModel> hives = [];

  // -----------------------------
  // API STATE
  // -----------------------------

  bool isCreatingHives = false;
  int currentHiveIndex = 0;
  int createdHiveCount = 0;

  // -----------------------------
  // INITIALIZE HIVE FORMS
  // -----------------------------

  void initializeHives() {
    hives = List.generate(
      apiaryController.hiveCount,
      (index) => HiveModel(
        name: '',
        description: '',
        hiveType: apiaryController.hiveType,
      ),
    );

    update();
  }

  // -----------------------------
  // UPDATE HIVE
  // -----------------------------

  void updateHive({
    required int index,
    required String name,
    required String description,
  }) {
    hives[index] = HiveModel(
      name: name,
      description: description,
      hiveType: apiaryController.hiveType,
    );

    update();
  }

  // -----------------------------
  // CREATE ALL HIVES
  // -----------------------------

  Future<bool> createAllHives() async {
    try {
      isCreatingHives = true;
      currentHiveIndex = 0;
      createdHiveCount = 0;
      update();

      final apiaryId = apiaryController.apiaryId;

      if (apiaryId == null) {
        Get.snackbar('Error', 'Apiary ID is missing.');

        return false;
      }

      for (int i = 0; i < hives.length; i++) {
        // Current hive being created
        currentHiveIndex = i;
        update();

        final response = await HiveService.createHive(
          apiaryId: apiaryId,
          hive: hives[i],
        );

        // Hive created successfully
        if (response.statusCode == 201) {
          createdHiveCount++;
          update();
        } else {
          Get.snackbar(
            'Hive ${i + 1} Failed',
            'Failed to create Hive ${i + 1}.',
          );

          return false;
        }
      }

      return true;
    } catch (e) {
      Get.snackbar('Error', 'Something went wrong: $e');

      return false;
    } finally {
      isCreatingHives = false;
      update();
    }
  }
}
