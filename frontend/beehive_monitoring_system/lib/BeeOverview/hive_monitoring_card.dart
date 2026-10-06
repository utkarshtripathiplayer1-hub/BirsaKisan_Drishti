import 'package:beehive_monitoring_system/BeeOverview/simulation_model.dart';
import 'package:flutter/material.dart';

class HiveMonitoringCard extends StatelessWidget {
  final HiveModel hive;
  final VoidCallback onViewDetails;

  const HiveMonitoringCard({
    super.key,
    required this.hive,
    required this.onViewDetails,
  });

  @override
  Widget build(BuildContext context) {
    final prediction = hive.prediction;
    final sensor = hive.sensorReading;

    return Card(
      margin: const EdgeInsets.only(bottom: 14),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),

            const SizedBox(height: 16),

            _buildHealthStatus(prediction.overallHealth),

            const SizedBox(height: 16),

            _buildSensorGrid(sensor),

            const SizedBox(height: 16),

            _buildPredictionRow(prediction),

            const SizedBox(height: 16),

            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: onViewDetails,
                child: const Text('View Hive Details'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    final isActive = hive.status.toLowerCase() == 'active';

    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.amber.withOpacity(0.15),
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Icon(Icons.hive_outlined, size: 28, color: Colors.amber),
        ),

        const SizedBox(width: 12),

        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                hive.hiveName,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 4),

              Row(
                children: [
                  Container(
                    width: 7,
                    height: 7,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isActive ? Colors.green : Colors.grey,
                    ),
                  ),

                  const SizedBox(width: 6),

                  Text(
                    hive.status,
                    style: TextStyle(
                      fontSize: 12,
                      color: isActive
                          ? Colors.green.shade700
                          : Colors.grey.shade700,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildHealthStatus(String health) {
    final healthLower = health.toLowerCase();

    Color color;

    if (healthLower == 'good' || healthLower == 'healthy') {
      color = Colors.green;
    } else if (healthLower == 'moderate') {
      color = Colors.orange;
    } else {
      color = Colors.red;
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.10),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(
            healthLower == 'good' || healthLower == 'healthy'
                ? Icons.check_circle_outline
                : Icons.warning_amber_outlined,
            color: color,
          ),

          const SizedBox(width: 10),

          const Text(
            'Overall Health',
            style: TextStyle(fontWeight: FontWeight.w600),
          ),

          const Spacer(),

          Text(
            health,
            style: TextStyle(fontWeight: FontWeight.bold, color: color),
          ),
        ],
      ),
    );
  }

  Widget _buildSensorGrid(SensorReading sensor) {
    return Row(
      children: [
        Expanded(
          child: _MetricItem(
            icon: Icons.thermostat,
            label: 'Temperature',
            value: '${sensor.overallTemperature.toStringAsFixed(1)} °C',
          ),
        ),

        Expanded(
          child: _MetricItem(
            icon: Icons.water_drop_outlined,
            label: 'Humidity',
            value: '${sensor.humidity.toStringAsFixed(1)}%',
          ),
        ),

        Expanded(
          child: _MetricItem(
            icon: Icons.scale_outlined,
            label: 'Weight',
            value: '${sensor.hiveWeight.toStringAsFixed(1)} kg',
          ),
        ),
      ],
    );
  }

  Widget _buildPredictionRow(Prediction prediction) {
    return Column(
      children: [
        _PredictionItem(
          label: 'Bee Activity',
          value: _formatActivity(hive.sensorReading.foragingActivity),
          icon: Icons.flight_takeoff,
        ),

        const SizedBox(height: 10),

        _PredictionItem(
          label: 'Colony Stress',
          value: prediction.colonyStress,
          icon: Icons.warning_amber_outlined,
        ),

        const SizedBox(height: 10),

        _PredictionItem(
          label: 'Ventilation',
          value: prediction.ventilation,
          icon: Icons.air,
        ),
      ],
    );
  }

  String _formatActivity(double activity) {
    final percentage = (activity * 100).round();

    return '$percentage%';
  }
}

class _MetricItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _MetricItem({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, size: 22),

        const SizedBox(height: 6),

        Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
        ),

        const SizedBox(height: 3),

        Text(
          value,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}

class _PredictionItem extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;

  const _PredictionItem({
    required this.label,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 20),

        const SizedBox(width: 10),

        Expanded(
          child: Text(
            label,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
          ),
        ),

        Text(
          value,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}
