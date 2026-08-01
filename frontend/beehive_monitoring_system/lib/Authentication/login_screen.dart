import 'package:beehive_monitoring_system/Authentication/auth_provider.dart';
import 'package:beehive_monitoring_system/OtherScreens/dashboard.dart';
import 'package:beehive_monitoring_system/OtherScreens/language_selection.dart';
import 'package:beehive_monitoring_system/l10n/locale_provider.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/background.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 20),

                _buildHeader(),

                const SizedBox(height: 18),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 14),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      FeatureCard(
                        image: "assets/images/crop copy.png",
                        title: "Smart Crop\nAdvisory",
                      ),
                      FeatureCard(
                        image: "assets/images/bee.png",
                        title: "Bee Health\nMonitoring",
                      ),
                      FeatureCard(
                        image: "assets/images/weather.png",
                        title: "Real-time\nWeather",
                      ),
                      FeatureCard(
                        image: "assets/images/bot.png",
                        title: "AI Farming\nAssistant",
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 22),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: _buildLoginCard(context),
                ),

                const SizedBox(height: 18),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 35),
                  child: _buildTrustedFarmers(),
                ),

                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        Image.asset("assets/images/logo.jpg", width: 110),

        const SizedBox(height: 12),

        RichText(
          text: TextSpan(
            children: [
              const TextSpan(
                text: "BirsaKisanDrishti",
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Color(0xff0B4D24),
                ),
              ),

              WidgetSpan(
                alignment: PlaceholderAlignment.middle,
                child: Container(
                  margin: const EdgeInsets.only(left: 4),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 3,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Text(
                    "AI",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 10),

        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25),
          child: Row(
            children: [
              const Expanded(child: Divider(color: Colors.green, thickness: 2)),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Text(
                  "AI-Powered Agriculture Intelligence",
                  style: TextStyle(
                    color: Colors.green.shade900,
                    fontWeight: FontWeight.w600,
                    fontSize: 17,
                  ),
                ),
              ),

              const Expanded(child: Divider(color: Colors.green, thickness: 2)),
            ],
          ),
        ),

        const SizedBox(height: 12),

        const Text(
          "“स्मार्ट टेक्नॉलॉजी, समृद्ध शेतकरी”",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w500,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }

  Widget _buildLoginCard(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 242 / 255),
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 20 / 255),
            blurRadius: 25,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          const Text(
            "Welcome to BirsaKisanDrishti AI!",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Color(0xff0B4D24),
            ),
          ),

          const SizedBox(height: 12),

          RichText(
            textAlign: TextAlign.center,
            text: const TextSpan(
              style: TextStyle(
                fontSize: 18,
                color: Colors.black87,
                height: 1.4,
              ),
              children: [
                TextSpan(text: "Your intelligent farming companion\nfor "),

                TextSpan(
                  text: "better decisions",
                  style: TextStyle(
                    color: Colors.green,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                TextSpan(text: " and "),

                TextSpan(
                  text: "bountiful harvests.",
                  style: TextStyle(
                    color: Colors.green,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 18),

          SizedBox(
            width: double.infinity,
            height: 60,
            child: OutlinedButton(
              style: OutlinedButton.styleFrom(
                backgroundColor: Colors.white,
                side: BorderSide(color: Colors.grey.shade300),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18),
                ),
              ),
              onPressed: () async {
                try {
                  final authProvider = context.read<AuthProvider>();
                  final localeProvider = context.read<LocaleProvider>();

                  final isNewUser = await authProvider.login();

                  if (!context.mounted) return;

                  if (isNewUser) {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const LanguageSelectionScreen(),
                      ),
                    );
                  } else {
                    final language =
                        authProvider.currentUser?.preferredLanguage ?? 'en';

                    await localeProvider.setLocale(language);
                    Get.updateLocale(Locale(language));

                    if (!context.mounted) return;

                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (_) => const HomePage()),
                    );
                  }
                } catch (e) {
                  if (!context.mounted) return;

                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(SnackBar(content: Text(e.toString())));
                }
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset("assets/images/google.png", width: 28),

                  const SizedBox(width: 18),

                  const Text(
                    "Continue with Google",
                    style: TextStyle(
                      color: Colors.black87,
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 18),

          Row(
            children: [
              Expanded(
                child: _securityItem(
                  "assets/images/secuirity.png",
                  "End-to-End\nSecure Login",
                ),
              ),

              Expanded(
                child: _securityItem(
                  "assets/images/language.png",
                  "Available in\nMultiple Languages",
                ),
              ),

              Expanded(
                child: _securityItem(
                  "assets/images/cloud.png",
                  "Cloud\nSynced",
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _securityItem(String image, String text) {
    return Column(
      children: [
        Image.asset(image, width: 34),

        const SizedBox(height: 10),

        Text(
          text,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 14, height: 1.3),
        ),
      ],
    );
  }

  Widget _buildTrustedFarmers() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 235 / 255),
        borderRadius: BorderRadius.circular(40),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 20 / 255),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.verified_user_rounded, size: 28),

          const SizedBox(width: 10),

          Expanded(
            child: RichText(
              text: const TextSpan(
                style: TextStyle(fontSize: 18, color: Colors.black87),
                children: [
                  TextSpan(text: "Trusted by 500+ Farmers across India"),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class FeatureCard extends StatelessWidget {
  final String image;
  final String title;

  const FeatureCard({super.key, required this.image, required this.title});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 68,
      child: Column(
        children: [
          Container(
            width: 68,
            height: 68,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 235 / 255),
              borderRadius: BorderRadius.circular(18),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 20 / 255),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Image.asset(image, fit: BoxFit.contain),
            ),
          ),

          const SizedBox(height: 8),

          Text(
            title,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.visible,
            style: const TextStyle(
              fontSize: 11,
              height: 1.25,
              color: Color(0xff0B4D24),
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
