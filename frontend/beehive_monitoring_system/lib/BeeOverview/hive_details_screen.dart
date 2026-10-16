import 'package:beehive_monitoring_system/BeeOverview/simulation_model.dart';
import 'package:flutter/material.dart';

class HiveDetailsScreen extends StatelessWidget {
  final HiveModel hive;
  final String scenario;

  const HiveDetailsScreen({
    super.key,
    required this.hive,
    required this.scenario,
  });

  @override
  Widget build(BuildContext context) {
    final sensor = hive.sensorReading;
    final prediction = hive.prediction;

    return Scaffold(
      appBar: AppBar(title: Text(hive.hiveName)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildHeader(),

          const SizedBox(height: 16),

          _buildHealthCard(prediction.overallHealth),

          const SizedBox(height: 16),

          _buildSectionTitle('Hive Conditions'),

          const SizedBox(height: 10),

          _buildConditionsCard(sensor),

          const SizedBox(height: 20),

          _buildSectionTitle('Colony Status'),

          const SizedBox(height: 10),

          _buildColonyStatusCard(prediction),

          const SizedBox(height: 20),

          _buildSectionTitle('Production & Risk'),

          const SizedBox(height: 10),

          _buildProductionRiskCard(prediction),

          const SizedBox(height: 20),

          _buildAdvisory(prediction),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    final isActive = hive.status.toLowerCase() == 'active';

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.amber.withOpacity(0.15),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.hive_outlined,
                size: 34,
                color: Colors.amber,
              ),
            ),

            const SizedBox(width: 14),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    hive.hiveName,
                    style: const TextStyle(
                      fontSize: 21,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 5),

                  Row(
                    children: [
                      Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: isActive ? Colors.green : Colors.grey,
                        ),
                      ),

                      const SizedBox(width: 6),

                      Text(
                        hive.status,
                        style: TextStyle(
                          color: isActive
                              ? Colors.green.shade700
                              : Colors.grey.shade700,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHealthCard(String health) {
    final healthLower = health.toLowerCase();

    final isGood = healthLower == 'good' || healthLower == 'healthy';

    final color = isGood ? Colors.green : Colors.orange;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Row(
          children: [
            Icon(
              isGood ? Icons.check_circle : Icons.warning_amber_rounded,
              size: 40,
              color: color,
            ),

            const SizedBox(width: 14),

            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Overall Health',
                  style: TextStyle(fontSize: 13, color: Colors.grey),
                ),

                const SizedBox(height: 4),

                Text(
                  health,
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
    );
  }

  Widget _buildConditionsCard(SensorReading sensor) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: _MetricTile(
                    icon: Icons.thermostat,
                    colour: Colors.red,
                    label: 'Temperature',
                    value: '${sensor.overallTemperature.toStringAsFixed(1)} °C',
                  ),
                ),

                Expanded(
                  child: _MetricTile(
                    icon: Icons.water_drop_outlined,
                    colour: Colors.blue,
                    label: 'Humidity',
                    value: '${sensor.humidity.toStringAsFixed(1)}%',
                  ),
                ),
              ],
            ),

            const Divider(height: 28),

            Row(
              children: [
                Expanded(
                  child: _MetricTile(
                    icon: Icons.scale_outlined,
                    colour: Colors.brown,
                    label: 'Hive Weight',
                    value: '${sensor.hiveWeight.toStringAsFixed(1)} kg',
                  ),
                ),

                Expanded(
                  child: _MetricTile(
                    icon: Icons.flight_takeoff,
                    label: 'Bee Activity',
                    colour: Colors.orangeAccent,
                    value: '${(sensor.foragingActivity * 100).round()}%',
                  ),
                ),
              ],
            ),

            const Divider(height: 28),

            Row(
              children: [
                Expanded(
                  child: _MetricTile(
                    icon: Icons.trending_up,
                    label: 'Weight Change',
                    colour: Colors.deepPurple,
                    value: _formatWeightChange(sensor.weightChange24h),
                  ),
                ),

                Expanded(
                  child: _MetricTile(
                    icon: Icons.air,
                    label: 'Ventilation',
                    colour: Colors.purpleAccent,
                    value: hive.prediction.ventilation,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildColonyStatusCard(Prediction prediction) {
    return Card(
      child: Column(
        children: [
          _StatusRow(
            icon: Icons.warning_amber_outlined,
            label: 'Colony Stress',
            value: prediction.colonyStress,
          ),

          const Divider(height: 1),

          _StatusRow(
            icon: Icons.favorite_outline,
            label: 'Brood Health',
            value: prediction.broodHealth,
          ),

          const Divider(height: 1),

          _StatusRow(
            icon: Icons.emoji_nature_outlined,
            label: 'Queen Status',
            value: prediction.queenStatus,
          ),
        ],
      ),
    );
  }

  Widget _buildProductionRiskCard(Prediction prediction) {
    return Card(
      child: Column(
        children: [
          _StatusRow(
            icon: Icons.local_florist_outlined,
            label: 'Honey Production',
            value: prediction.honeyProduction,
          ),

          const Divider(height: 1),

          _StatusRow(
            icon: Icons.spa_outlined,
            label: 'Fungal Risk',
            value: prediction.fungalRisk,
          ),

          const Divider(height: 1),

          _StatusRow(
            icon: Icons.health_and_safety_outlined,
            label: 'Disease Risk',
            value: prediction.diseaseRisk,
          ),
        ],
      ),
    );
  }

  Widget _buildAdvisory(Prediction prediction) {
    String title;
    String message;
    IconData icon;

    switch (scenario) {
      case 'heat_stress':
        title = 'Heat Stress Advisory';
        icon = Icons.wb_sunny_outlined;

        message =
            'The hive may be experiencing heat stress. '
            'Check that the hive has adequate shade and '
            'good airflow. Avoid unnecessary disturbance '
            'during hot conditions.';
        break;

      case 'low_activity':
        title = 'Low Bee Activity';
        icon = Icons.flight_takeoff;

        message =
            'Bee activity appears lower than expected. '
            'Check the hive surroundings, weather conditions, '
            'food availability, and colony condition.';
        break;

      case 'poor_ventilation':
        title = 'Ventilation Advisory';
        icon = Icons.air;

        message =
            'The hive may need better ventilation. '
            'Check airflow around the hive and make sure '
            'the entrance and ventilation openings are not blocked.';
        break;

      case 'inspection':
        title = 'Inspection Recommended';
        icon = Icons.search;

        message =
            'This hive has been marked for inspection. '
            'Consider checking the colony, brood condition, '
            'queen status, and visible signs of disease or pests.';
        break;

      case 'recovery':
        title = 'Recovery Monitoring';
        icon = Icons.trending_up;

        message =
            'The colony appears to be recovering. '
            'Continue regular monitoring and avoid unnecessary '
            'disturbance while the colony stabilizes.';
        break;

      case 'normal':
      default:
        title = 'Routine Monitoring';
        icon = Icons.check_circle_outline;

        message =
            'The hive is under normal monitoring. '
            'Continue regular inspections and keep monitoring '
            'temperature, humidity, bee activity, and hive weight.';
        break;
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: Colors.orange),

                const SizedBox(width: 8),

                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            Text(message, style: const TextStyle(height: 1.5)),
          ],
        ),
      ),
    );
  }

  String _formatWeightChange(double change) {
    if (change > 0) {
      return '+${change.toStringAsFixed(2)} kg';
    }

    return '${change.toStringAsFixed(2)} kg';
  }
}

class _MetricTile extends StatelessWidget {
  final Color colour;
  final IconData icon;
  final String label;
  final String value;

  const _MetricTile({
    required this.colour,
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, size: 24, color: colour),

        const SizedBox(height: 7),

        Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
        ),

        const SizedBox(height: 4),

        Text(
          value,
          textAlign: TextAlign.center,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
        ),
      ],
    );
  }
}

class _StatusRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _StatusRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
      child: Row(
        children: [
          Icon(icon, size: 22),

          const SizedBox(width: 12),

          Expanded(
            child: Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),

          Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
