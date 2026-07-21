import 'package:beehive_monitoring_system/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';

class KeyFeatures extends StatelessWidget {
  const KeyFeatures({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFC98D26),

      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Color(0xFF574422),
          size: 30,
          weight: 40.0,
        ),
        centerTitle: true,
        title: AutoSizeText(
          minFontSize: 15,
          AppLocalizations.of(context)!.keyFeatures,
          style: TextStyle(
            color: Color(0xFF574422),
            fontWeight: FontWeight.bold,
            fontSize: 35,
          ),
        ),
        backgroundColor: const Color(0xFFC98D26).withValues(alpha: 0.59),
      ),

      body: SingleChildScrollView(
        child: Column(
          children: [
            // GREEN HEADER SECTION
            Container(
              width: double.infinity,
              height: MediaQuery.of(context).size.height * 0.28,
              color: const Color(0xFFF8FAF2),
              child: Opacity(
                opacity: 0.75,
                child: Image.asset(
                  'assets/images/beehive.png',
                  width: double.infinity,
                  height: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
            ),

            // GREY ROUNDED SECTION
            Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                color: Color(0xFFF8FAF2),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(35),
                  topRight: Radius.circular(35),
                ),
              ),
              child: Column(
                children: [
                  const SizedBox(height: 25),

                  Text(
                    AppLocalizations.of(context)!.features,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFFC98D26),
                    ),
                  ),

                  const SizedBox(height: 25),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: GridView.count(
                      crossAxisCount: 2,
                      crossAxisSpacing: 15,
                      mainAxisSpacing: 15,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      childAspectRatio: 0.82,
                      children: [
                        FeatureCard(
                          imagePath: "assets/images/live_monitoring.png",
                          title: AppLocalizations.of(context)!.liveMonitoring,
                          description: AppLocalizations.of(
                            context,
                          )!.keyFeaturedesc1,
                        ),
                        FeatureCard(
                          imagePath: "assets/images/hive_health.png",
                          title: AppLocalizations.of(context)!.hiveHealthScore,
                          description: AppLocalizations.of(
                            context,
                          )!.keyFeaturedesc2,
                        ),
                        FeatureCard(
                          imagePath: "assets/images/smart_alert.png",
                          title: AppLocalizations.of(context)!.smartAlerts,
                          description: AppLocalizations.of(
                            context,
                          )!.keyFeaturedesc3,
                        ),
                        FeatureCard(
                          imagePath: "assets/images/image_analysis.png",
                          title: AppLocalizations.of(context)!.mitesdetection,
                          description: AppLocalizations.of(
                            context,
                          )!.keyFeaturedesc4,
                        ),
                        FeatureCard(
                          imagePath: "assets/images/report.png",
                          title: AppLocalizations.of(context)!.provideReport,
                          description: AppLocalizations.of(
                            context,
                          )!.keyFeaturedesc5,
                        ),
                        FeatureCard(
                          imagePath: "assets/images/manage_device.png",
                          title: AppLocalizations.of(context)!.deviceManagement,
                          description: AppLocalizations.of(
                            context,
                          )!.keyFeaturedesc6,
                        ),
                        FeatureCard(
                          imagePath: "assets/images/graph.png",
                          title: AppLocalizations.of(context)!.hiveGraph,
                          description: AppLocalizations.of(
                            context,
                          )!.keyFeaturedesc7,
                        ),
                        FeatureCard(
                          imagePath: "assets/images/guide.png",
                          title: AppLocalizations.of(context)!.guideAndSupport,
                          description: AppLocalizations.of(
                            context,
                          )!.keyFeaturedesc8,
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 30),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class FeatureCard extends StatelessWidget {
  final String imagePath;
  final String title;
  final String description;

  const FeatureCard({
    super.key,
    required this.imagePath,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
        border: Border.all(color: Color(0xFFC98D26), width: 1.5),
        boxShadow: const [
          BoxShadow(
            color: Color(0xFFC98D26),
            blurRadius: 1.5,
            offset: Offset(2, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset(imagePath, height: 55, width: 55),

          const SizedBox(height: 12),

          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 8),

          Flexible(
            child: Text(
              textAlign: TextAlign.center,
              overflow: TextOverflow.fade,
              description,
              style: const TextStyle(fontSize: 13, height: 1.3),
            ),
          ),
        ],
      ),
    );
  }
}
