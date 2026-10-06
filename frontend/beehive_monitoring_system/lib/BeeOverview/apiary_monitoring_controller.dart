import 'dart:math';
import 'apiary_model.dart';
import 'simulation_model.dart';
import 'package:get/get.dart';
import 'apiary_monitoring_service.dart';

class ApiaryMonitoringController extends GetxController {
  final ApiaryMonitoringService service = ApiaryMonitoringService();

  // ============================================================
  // APIARIES
  // ============================================================

  // Stores all apiaries returned by GET /apiaries
  final RxList<ApiaryModel> apiaries = <ApiaryModel>[].obs;

  // Currently selected apiary
  final Rxn<ApiaryModel> selectedApiary = Rxn<ApiaryModel>();

  // ============================================================
  // SIMULATION
  // ============================================================

  // Stores simulation data for the selected apiary
  final Rxn<ApiarySimulationModel> simulation = Rxn<ApiarySimulationModel>();

  // ============================================================
  // LOADING STATES
  // ============================================================

  // Loading state while GET /apiaries is running
  final RxBool isLoadingApiaries = false.obs;

  // Loading state while simulation API is running
  final RxBool isLoadingSimulation = false.obs;

  // ============================================================
  // ERROR STATES
  // ============================================================

  final RxString apiaryError = ''.obs;
  final RxString simulationError = ''.obs;

  // ============================================================
  // SIMULATION SCENARIOS
  // ============================================================

  final List<String> scenarios = [
    'normal',
    'heat_stress',
    'low_activity',
    'poor_ventilation',
    'inspection',
    'recovery',
  ];

  // ============================================================
  // CONTROLLER INITIALIZATION
  // ============================================================

  @override
  void onInit() {
    super.onInit();

    loadApiaries();
  }

  // ============================================================
  // GET ALL APIARIES
  // ============================================================

  Future<void> loadApiaries() async {
    try {
      isLoadingApiaries.value = true;
      apiaryError.value = '';

      final result = await service.getApiaries();

      apiaries.assignAll(result);
    } catch (e) {
      apiaryError.value = e.toString();
    } finally {
      isLoadingApiaries.value = false;
    }
  }

  // ============================================================
  // RANDOM SCENARIO
  // ============================================================

  String getRandomScenario() {
    final random = Random();

    return scenarios[random.nextInt(scenarios.length)];
  }

  // ============================================================
  // SELECT APIARY
  // ============================================================

  Future<void> selectApiary(ApiaryModel apiary) async {
    selectedApiary.value = apiary;

    await loadSimulation(apiary.id);
  }

  // ============================================================
  // GET APIARY SIMULATION
  // ============================================================

  Future<void> loadSimulation(String apiaryId) async {
    try {
      isLoadingSimulation.value = true;
      simulationError.value = '';

      final scenario = getRandomScenario();

      print('Selected simulation scenario: $scenario');

      final result = await service.getApiarySimulation(
        apiaryId: apiaryId,
        scenario: scenario,
      );

      simulation.value = result;
    } catch (e) {
      simulationError.value = e.toString();

      print('Simulation error: $e');
    } finally {
      isLoadingSimulation.value = false;
    }
  }
}
