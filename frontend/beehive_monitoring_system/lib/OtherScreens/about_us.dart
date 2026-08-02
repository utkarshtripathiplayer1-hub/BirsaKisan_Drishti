import 'package:auto_size_text/auto_size_text.dart';
import 'package:beehive_monitoring_system/l10n/app_localizations.dart';
import 'package:flutter/material.dart';

class AboutUs extends StatelessWidget {
  const AboutUs({super.key});

  @override
  Widget build(BuildContext context) {
    final interStyle = Theme.of(context).textTheme.headlineMedium!;

    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Color(0xFF574422),
          size: 30,
          weight: 40.0,
        ),
        centerTitle: true,
        title: AutoSizeText(
          minFontSize: 15,
          AppLocalizations.of(context)!.aboutUs,
          style: TextStyle(
            color: Color(0xFF574422),
            fontWeight: FontWeight.bold,
            fontSize: 35,
          ),
        ),
        backgroundColor: const Color(0xFFC98D26).withValues(alpha: 0.59),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsetsGeometry.all(10),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(10),
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: "Birsa",
                          style: interStyle.copyWith(
                            fontSize: 32,
                            fontWeight: FontWeight.w900,
                            // fontFamily: "Timmana",
                            color: Color(0xFF574422),
                          ),
                        ),
                        TextSpan(
                          text: "Kisan",
                          style: interStyle.copyWith(
                            fontSize: 32,
                            fontWeight: FontWeight.w900,
                            // fontFamily: "Inter",
                            color: Color(0xFFC98D26),
                          ),
                        ),
                        TextSpan(
                          text: "Drishti",
                          style: interStyle.copyWith(
                            fontSize: 32,
                            fontWeight: FontWeight.w900,
                            // fontFamily: "Timmana",
                            color: Color(0xFF574422),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              Text(
                AppLocalizations.of(context)!.aboutusDesc1,
                style: TextStyle(
                  // fontSize: 25,
                  fontWeight: FontWeight.w600,
                  fontFamily: "Timmana",
                ),
              ),
              Container(height: 3, width: 200, color: Color(0xFFC98D26)),
              SizedBox(height: 20),
              Text(AppLocalizations.of(context)!.aboutusDesc2),
              SizedBox(height: 10),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  AppLocalizations.of(context)!.provided,
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                ),
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Container(
                  height: 3,
                  width: 150,
                  color: Color(0xFFC98D26),
                ),
              ),

              SizedBox(height: 20),

              GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 2.1,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),

                children: [
                  featureCard(
                    "assets/images/live_monitoring.png",
                    AppLocalizations.of(context)!.liveMonitoring,
                  ),

                  featureCard(
                    "assets/images/hive_health.png",
                    AppLocalizations.of(context)!.hiveHealthScore,
                  ),

                  featureCard(
                    "assets/images/image_analysis.png",
                    AppLocalizations.of(context)!.imageAnalysis,
                  ),

                  featureCard(
                    "assets/images/smart_alert.png",
                    AppLocalizations.of(context)!.smartAlerts,
                  ),

                  featureCard(
                    "assets/images/AI_assistant.png",
                    AppLocalizations.of(context)!.aiAssistant,
                  ),

                  featureCard(
                    "assets/images/community.png",
                    AppLocalizations.of(context)!.community,
                  ),

                  featureCard(
                    "assets/images/report.png",
                    AppLocalizations.of(context)!.provideReport,
                  ),

                  featureCard(
                    "assets/images/qr.png",
                    AppLocalizations.of(context)!.qrManagement,
                  ),
                ],
              ),
              SizedBox(height: 30),

              // OUR MISSION SECTION
              Row(
                children: [
                  Text(
                    AppLocalizations.of(context)!.mission,
                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                  ),

                  SizedBox(width: 10),

                  Image.asset(
                    "assets/images/mission_heart.png",
                    height: 55,
                    width: 55,
                    fit: BoxFit.contain,
                  ),
                ],
              ),

              SizedBox(height: 5),

              Align(
                alignment: Alignment.centerLeft,
                child: Container(
                  height: 3,
                  width: 220,
                  color: Color(0xFFC98D26),
                ),
              ),

              SizedBox(height: 15),

              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image.asset(
                    "assets/images/mission_icon.png",
                    height: 40,
                    width: 40,
                    fit: BoxFit.contain,
                  ),

                  SizedBox(width: 12),

                  Expanded(
                    child: Text(
                      AppLocalizations.of(context)!.missionDesc,
                      style: TextStyle(fontSize: 15, height: 1.4),
                    ),
                  ),
                ],
              ),

              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget featureCard(String imagePath, String title) {
    return Container(
      padding: const EdgeInsets.all(10),

      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Color(0xFFC98D26), width: 1.5),
        boxShadow: const [
          BoxShadow(
            color: Color(0xFFC98D26),
            blurRadius: 3.5,
            offset: Offset(2, 4),
          ),
        ],
      ),

      child: Row(
        children: [
          Image.asset(imagePath, height: 45, width: 45),

          const SizedBox(width: 8),

          Expanded(
            child: Text(
              title,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              softWrap: true,
              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }
}
