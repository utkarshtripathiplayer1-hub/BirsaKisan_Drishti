import 'package:beehive_monitoring_system/BeeOverview/apiary_monitoring_screen.dart';

import 'apiary_model.dart';
import 'apiary_monitoring_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MyApiariesScreen extends StatelessWidget {
  const MyApiariesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ApiaryMonitoringController());

    return Scaffold(
      appBar: AppBar(title: const Text('My Apiaries')),
      body: Obx(() {
        return _buildBody(controller);
      }),
    );
  }

  Widget _buildBody(ApiaryMonitoringController controller) {
    if (controller.isLoadingApiaries.value) {
      return const Center(child: CircularProgressIndicator());
    }

    if (controller.apiaryError.value.isNotEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.error_outline, size: 50),

              const SizedBox(height: 16),

              const Text(
                'Unable to load your apiaries',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 8),

              Text(controller.apiaryError.value, textAlign: TextAlign.center),

              const SizedBox(height: 20),

              ElevatedButton(
                onPressed: controller.loadApiaries,
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      );
    }

    if (controller.apiaries.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.hive_outlined, size: 60),

              SizedBox(height: 16),

              Text(
                'No apiaries found',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),

              SizedBox(height: 8),

              Text(
                'Set up an apiary to start monitoring your hives.',
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: controller.loadApiaries,
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: controller.apiaries.length,
        itemBuilder: (context, index) {
          final apiary = controller.apiaries[index];

          return ApiaryCard(
            apiary: apiary,
            onTap: () async{
              await controller.selectApiary(apiary);
              if (controller.simulation.value != null) {
                Get.to(() => const ApiaryMonitoringScreen());
              }
              // Navigation will be added later.
            },
          );
        },
      ),
    );
  }
}

class ApiaryCard extends StatelessWidget {
  final ApiaryModel apiary;
  final VoidCallback onTap;

  const ApiaryCard({super.key, required this.apiary, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),
              const SizedBox(height: 16),
              _buildLocation(),
              const SizedBox(height: 14),
              _buildInfoRow(),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: onTap,
                  child: const Text('View Monitoring'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: Colors.amber.withOpacity(0.15),
          ),
          child: const Icon(Icons.hive_outlined, size: 30, color: Colors.amber),
        ),

        const SizedBox(width: 12),

        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                apiary.name,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),

              if (apiary.description.isNotEmpty) ...[
                const SizedBox(height: 4),
                Text(
                  apiary.description,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(color: Colors.grey.shade600),
                ),
              ],
            ],
          ),
        ),

        _buildStatus(),
      ],
    );
  }

  Widget _buildStatus() {
    final isActive = apiary.status.toLowerCase() == 'active';

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: isActive
            ? Colors.green.withOpacity(0.12)
            : Colors.grey.withOpacity(0.12),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
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
            apiary.status,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: isActive ? Colors.green.shade700 : Colors.grey.shade700,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLocation() {
    final locationParts = [
      apiary.village,
      apiary.district,
    ].where((value) => value.isNotEmpty).toList();

    final location = locationParts.join(', ');

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Icon(Icons.location_on_outlined, size: 20),

        const SizedBox(width: 8),

        Expanded(
          child: Text(
            location.isEmpty ? 'Location not available' : location,
            style: TextStyle(color: Colors.grey.shade700),
          ),
        ),
      ],
    );
  }

  Widget _buildInfoRow() {
    return Row(
      children: [
        Expanded(
          child: _InfoItem(
            icon: Icons.hive_outlined,
            label: 'Hives',
            value: '${apiary.hiveCount} / ${apiary.targetHiveCount}',
          ),
        ),

        Expanded(
          child: _InfoItem(
            icon: Icons.category_outlined,
            label: 'Type',
            value: _formatHiveType(apiary.hiveType),
          ),
        ),
      ],
    );
  }

  String _formatHiveType(String type) {
    if (type.isEmpty) {
      return 'Unknown';
    }

    switch (type.toLowerCase()) {
      case 'langstroth':
        return 'Langstroth';

      case 'top bar':
        return 'Top Bar';

      case 'warre':
        return 'Warré';

      default:
        return type;
    }
  }
}

class _InfoItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _InfoItem({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 22, color: Colors.grey.shade700),

        const SizedBox(width: 8),

        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
            ),

            const SizedBox(height: 2),

            Text(
              value,
              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ],
    );
  }
}
