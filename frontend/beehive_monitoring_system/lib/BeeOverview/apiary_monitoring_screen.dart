import 'package:beehive_monitoring_system/BeeOverview/hive_details_screen.dart';
import 'package:beehive_monitoring_system/BeeOverview/hive_monitoring_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'apiary_monitoring_controller.dart';

class ApiaryMonitoringScreen extends StatelessWidget {
  const ApiaryMonitoringScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ApiaryMonitoringController>();

    return Scaffold(
      appBar: AppBar(title: const Text('Apiary Monitoring')),
      body: Obx(() {
        // Loading
        if (controller.isLoadingSimulation.value) {
          return const Center(child: CircularProgressIndicator());
        }

        // Error
        if (controller.simulationError.value.isNotEmpty) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.error_outline, size: 50),
                  const SizedBox(height: 16),

                  const Text(
                    'Unable to load monitoring data',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),

                  const SizedBox(height: 8),

                  Text(
                    controller.simulationError.value,
                    textAlign: TextAlign.center,
                  ),

                  const SizedBox(height: 20),

                  ElevatedButton(
                    onPressed: () {
                      final apiary = controller.selectedApiary.value;

                      if (apiary != null) {
                        controller.loadSimulation(apiary.id);
                      }
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            ),
          );
        }

        // No simulation data
        if (controller.simulation.value == null) {
          return const Center(child: Text('No monitoring data available'));
        }

        final simulation = controller.simulation.value!;

        return _buildDashboard(context, controller, simulation);
      }),
    );
  }

  Widget _buildDashboard(
    BuildContext context,
    ApiaryMonitoringController controller,
    dynamic simulation,
  ) {
    return RefreshIndicator(
      onRefresh: () async {
        final apiary = controller.selectedApiary.value;

        if (apiary != null) {
          await controller.loadSimulation(apiary.id);
        }
      },
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(16),
        children: [
          // Apiary header
          _buildApiaryHeader(simulation),

          const SizedBox(height: 16),

          // Overall health
          _buildOverallHealth(simulation),

          const SizedBox(height: 16),

          // Hive summary
          _buildHiveSummary(simulation),

          const SizedBox(height: 20),

          const Text(
            'Hive Monitoring',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 12),

          ...simulation.hives.map<Widget>(
            (hive) => HiveMonitoringCard(
              hive: hive,
              onViewDetails: () {
                Get.to(
                  () => HiveDetailsScreen(
                    hive: hive,
                    scenario: simulation.scenario,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildApiaryHeader(dynamic simulation) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: Colors.amber.withOpacity(0.15),
              ),
              child: const Icon(
                Icons.hive_outlined,
                size: 32,
                color: Colors.amber,
              ),
            ),

            const SizedBox(width: 12),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    simulation.apiaryName,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 4),

                  Text(
                    'Monitoring ${simulation.hiveCount} hives',
                    style: TextStyle(color: Colors.grey.shade600),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOverallHealth(dynamic simulation) {
    final hives = simulation.hives;

    int healthy = 0;
    int attention = 0;

    for (final hive in hives) {
      final health = hive.prediction.overallHealth.toLowerCase();

      if (health == 'good' || health == 'healthy') {
        healthy++;
      } else {
        attention++;
      }
    }

    final overallHealth = attention == 0 ? 'Good' : 'Needs Attention';

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Overall Apiary Health',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),

            const SizedBox(height: 10),

            Text(
              overallHealth,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: attention == 0 ? Colors.green : Colors.orange,
              ),
            ),

            const SizedBox(height: 14),

            Row(
              children: [
                Expanded(
                  child: _HealthCount(
                    label: 'Healthy',
                    count: healthy,
                    icon: Icons.check_circle_outline,
                  ),
                ),

                Expanded(
                  child: _HealthCount(
                    label: 'Attention',
                    count: attention,
                    icon: Icons.warning_amber_outlined,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHiveSummary(dynamic simulation) {
    if (simulation.hives.isEmpty) {
      return const SizedBox();
    }

    double totalTemperature = 0;
    double totalHumidity = 0;

    for (final hive in simulation.hives) {
      totalTemperature += hive.sensorReading.overallTemperature;

      totalHumidity += hive.sensorReading.humidity;
    }

    final averageTemperature = totalTemperature / simulation.hives.length;

    final averageHumidity = totalHumidity / simulation.hives.length;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Current Conditions',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),

            const SizedBox(height: 14),

            Row(
              children: [
                Expanded(
                  child: _ConditionItem(
                    icon: Icons.thermostat,
                    label: 'Avg. Temperature',
                    value: '${averageTemperature.toStringAsFixed(1)} °C',
                  ),
                ),

                Expanded(
                  child: _ConditionItem(
                    icon: Icons.water_drop_outlined,
                    label: 'Avg. Humidity',
                    value: '${averageHumidity.toStringAsFixed(1)}%',
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _HealthCount extends StatelessWidget {
  final String label;
  final int count;
  final IconData icon;

  const _HealthCount({
    required this.label,
    required this.count,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon),
        const SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '$count',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text(label, style: const TextStyle(fontSize: 12)),
          ],
        ),
      ],
    );
  }
}

class _ConditionItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _ConditionItem({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
              ),
              const SizedBox(height: 3),
              Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
            ],
          ),
        ),
      ],
    );
  }
}
