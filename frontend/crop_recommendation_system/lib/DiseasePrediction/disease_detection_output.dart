import 'dart:io';
import 'package:crop_recommendation_system/l10n/app_localizations.dart';
import 'package:flutter/material.dart';

class DiseaseDetectionOutput extends StatelessWidget {
  final Map<String, dynamic> response;
  final File imageFile;

  const DiseaseDetectionOutput({
    super.key,
    required this.response,
    required this.imageFile,
  });

  String formatDiseaseName(String? diseaseName) {
    if (diseaseName == null || diseaseName.trim().isEmpty) {
      return "Unknown Disease";
    }

    return diseaseName
        .split('_')
        .map(
          (word) => word.isEmpty
              ? word
              : word[0].toUpperCase() + word.substring(1).toLowerCase(),
        )
        .join(' ');
  }

  String formatValue(dynamic value) {
    if (value == null) {
      return "N/A";
    }

    final text = value.toString().trim();

    if (text.isEmpty) {
      return "N/A";
    }

    return text;
  }

  @override
  Widget build(BuildContext context) {
    final visualAnalysis =
        response["visual_analysis"] as Map<String, dynamic>? ?? {};

    final possibleCauses =
        response["possible_causes"] as Map<String, dynamic>? ?? {};

    final differentialDiagnosis =
        response["differential_diagnosis"] as List? ?? [];

    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context)!.diseaseDetection,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.green.shade900,
        iconTheme: const IconThemeData(
          color: Colors.white,
          size: 30,
          weight: 40.0,
        ),
        centerTitle: true,
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),

        child: Column(
          children: [
            const SizedBox(height: 15),

            // =========================
            // IMAGE
            // =========================
            Container(
              margin: const EdgeInsets.all(20),
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(22),
                child: Image.file(
                  imageFile,
                  width: double.infinity,
                  height: 250,
                  fit: BoxFit.cover,
                ),
              ),
            ),

            const SizedBox(height: 15),

            // =========================
            // BASIC DISEASE INFORMATION
            // =========================
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(25),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    formatDiseaseName(response['disease_name']?.toString()),
                    textAlign: TextAlign.start,
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Colors.green.shade900,
                    ),
                  ),

                  const SizedBox(height: 15),

                  _buildInfoRow(
                    icon: Icons.eco,
                    label: "Crop Type",
                    value: formatValue(response["crop_type"]),
                  ),

                  _buildInfoRow(
                    icon: Icons.local_florist,
                    label: "Plant Part",
                    value: formatValue(response["plant_part"]),
                  ),

                  _buildInfoRow(
                    icon: Icons.favorite,
                    label: "Health Status",
                    value: formatValue(response["health_status"]),
                  ),

                  _buildInfoRow(
                    icon: Icons.percent,
                    label: "Confidence",
                    value: "${formatValue(response["confidence"])}%",
                  ),

                  _buildInfoRow(
                    icon: Icons.warning_amber_rounded,
                    label: "Severity",
                    value: formatValue(response["severity"]),
                  ),

                  _buildInfoRow(
                    icon: Icons.timeline,
                    label: "Disease Stage",
                    value: formatValue(response["disease_stage"]),
                  ),

                  _buildInfoRow(
                    icon: Icons.trending_up,
                    label: "Spread Risk",
                    value: formatValue(response["spread_risk"]),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // =========================
            // VISUAL ANALYSIS
            // =========================
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(25),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Visual Analysis",
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),

                  const SizedBox(height: 15),

                  _buildAnalysisItem(
                    title: "Symptoms Detected",
                    data: (visualAnalysis["symptoms_detected"] as List?) ?? [],
                  ),

                  _buildAnalysisItem(
                    title: "Affected Parts",
                    data: (visualAnalysis["affected_parts"] as List?) ?? [],
                  ),

                  _buildAnalysisItem(
                    title: "Color Changes",
                    data: (visualAnalysis["color_changes"] as List?) ?? [],
                  ),

                  const SizedBox(height: 10),

                  Text(
                    "Estimated Affected Area: "
                    "${formatValue(visualAnalysis["estimated_affected_area_percent"])}%",
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // =========================
            // DIFFERENTIAL DIAGNOSIS
            // =========================
            if (differentialDiagnosis.isNotEmpty)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(25),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Differential Diagnosis",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 15),

                    ...differentialDiagnosis.map((item) {
                      final diagnosis = item as Map<String, dynamic>;

                      return Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: Colors.grey.shade100,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              formatDiseaseName(diagnosis["name"]?.toString()),
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),

                            const SizedBox(height: 5),

                            Text(
                              "Probability: "
                              "${formatValue(diagnosis["probability"])}%",
                              style: const TextStyle(fontSize: 16),
                            ),

                            if (diagnosis["reason"] != null &&
                                diagnosis["reason"]
                                    .toString()
                                    .trim()
                                    .isNotEmpty)
                              Padding(
                                padding: const EdgeInsets.only(top: 5),
                                child: Text(
                                  "Reason: "
                                  "${diagnosis["reason"]}",
                                  style: const TextStyle(fontSize: 15),
                                ),
                              ),
                          ],
                        ),
                      );
                    }),
                  ],
                ),
              ),

            const SizedBox(height: 20),

            // =========================
            // POSSIBLE CAUSES
            // =========================
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(25),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Possible Causes",
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),

                  const SizedBox(height: 15),

                  if (possibleCauses["primary"] != null &&
                      possibleCauses["primary"].toString().trim().isNotEmpty)
                    Text(
                      "Primary Cause: "
                      "${possibleCauses["primary"]}",
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w500,
                      ),
                    ),

                  const SizedBox(height: 10),

                  ...((possibleCauses["secondary"] as List?) ?? []).map(
                    (cause) => Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Text(
                        "• $cause",
                        style: const TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // =========================
            // IMMEDIATE ACTIONS
            // =========================
            buildListContainer(
              title: "Immediate Actions",
              icon: Icons.warning,
              iconColor: Colors.red,
              data: (response["immediate_actions"] as List?) ?? [],
            ),

            const SizedBox(height: 20),

            // =========================
            // ORGANIC TREATMENT
            // =========================
            buildListContainer(
              title: "Organic Treatment",
              icon: Icons.eco,
              iconColor: Colors.green,
              data: (response["organic_treatment"] as List?) ?? [],
            ),

            const SizedBox(height: 20),

            // =========================
            // CHEMICAL TREATMENT
            // =========================
            buildListContainer(
              title: "Chemical Treatment",
              icon: Icons.medication,
              iconColor: Colors.blue,
              data: (response["chemical_treatment"] as List?) ?? [],
            ),

            const SizedBox(height: 50),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // INFO ROW
  // ============================================================

  Widget _buildInfoRow({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: Colors.green.shade700, size: 24),

          const SizedBox(width: 10),

          Expanded(
            child: RichText(
              text: TextSpan(
                style: const TextStyle(color: Colors.black, fontSize: 18),
                children: [
                  TextSpan(
                    text: "$label: ",
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  TextSpan(text: value),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // VISUAL ANALYSIS ITEM
  // ============================================================

  Widget _buildAnalysisItem({required String title, required List data}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 5),

          if (data.isEmpty)
            const Text("None detected", style: TextStyle(fontSize: 16))
          else
            ...data.map(
              (item) => Padding(
                padding: const EdgeInsets.only(bottom: 5),
                child: Text("• $item", style: const TextStyle(fontSize: 16)),
              ),
            ),
        ],
      ),
    );
  }

  // ============================================================
  // LIST CONTAINER
  // ============================================================

  Widget buildListContainer({
    required String title,
    required IconData icon,
    required Color iconColor,
    required List data,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 35, color: iconColor),

              const SizedBox(width: 10),

              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 15),

          if (data.isEmpty)
            const Text(
              "No information available.",
              style: TextStyle(fontSize: 16),
            )
          else
            ...data.map(
              (e) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Text("• $e", style: const TextStyle(fontSize: 16)),
              ),
            ),
        ],
      ),
    );
  }
}
