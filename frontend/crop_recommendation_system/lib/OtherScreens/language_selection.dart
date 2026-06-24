import 'package:crop_recommendation_system/OtherScreens/dashboard.dart';
import 'package:crop_recommendation_system/OtherScreens/permission_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import '../l10n/locale_provider.dart';

class LanguageSelectionScreen extends StatelessWidget {
  const LanguageSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final localeProvider = context.read<LocaleProvider>();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green.shade900,
        title: Text(
          "Choose Language",
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        iconTheme: const IconThemeData(
          color: Colors.white,
          size: 30,
          weight: 40.0,
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 10),

            Center(
              child: Icon(
                Icons.language,
                color: Colors.green.shade900,
                size: 150,
              ),
            ),

            SizedBox(height: 10),

            ListTile(
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 28,
                vertical: 2,
              ),
              title: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "English",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              onTap: () async {
                await localeProvider.setLocale('en');
                Get.updateLocale(const Locale('en'));
                await PermissionService.requestAllPermissions();
                Get.off(() => const HomePage());
              },
            ),

            Divider(),

            ListTile(
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 28,
                vertical: 2,
              ),
              title: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "हिन्दी",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              onTap: () async {
                await localeProvider.setLocale('hi');
                Get.updateLocale(const Locale('hi'));
                await PermissionService.requestAllPermissions();
                Get.off(() => const HomePage());
              },
            ),

            Divider(),

            ListTile(
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 28,
                vertical: 2,
              ),
              title: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "অসমীয়া",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              onTap: () async {
                await localeProvider.setLocale('as');
                Get.updateLocale(const Locale('as'));
                await PermissionService.requestAllPermissions();
                Get.off(() => const HomePage());
              },
            ),

            Divider(),

            ListTile(
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 28,
                vertical: 2,
              ),
              title: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "বাংলা",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              onTap: () async {
                await localeProvider.setLocale('bn');
                Get.updateLocale(const Locale('bn'));
                await PermissionService.requestAllPermissions();
                Get.off(() => const HomePage());
              },
            ),

            Divider(),

            ListTile(
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 28,
                vertical: 2,
              ),
              title: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "ଓଡିଆ",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              onTap: () async {
                await localeProvider.setLocale('or');
                Get.updateLocale(const Locale('or'));
                await PermissionService.requestAllPermissions();
                Get.off(() => const HomePage());
              },
            ),

            Divider(),

            ListTile(
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 28,
                vertical: 2,
              ),
              title: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "ਪੰਜਾਬੀ",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              onTap: () async {
                await localeProvider.setLocale('pa');
                Get.updateLocale(const Locale('pa'));
                await PermissionService.requestAllPermissions();
                Get.off(() => const HomePage());
              },
            ),

            Divider(),

            ListTile(
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 28,
                vertical: 2,
              ),
              title: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "ગુજરાતી",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              onTap: () async {
                await localeProvider.setLocale('gu');
                Get.updateLocale(const Locale('gu'));
                await PermissionService.requestAllPermissions();
                Get.off(() => const HomePage());
              },
            ),

            Divider(),

            ListTile(
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 28,
                vertical: 2,
              ),
              title: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "മലയാളം",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              onTap: () async {
                await localeProvider.setLocale('ml');
                Get.updateLocale(const Locale('ml'));
                await PermissionService.requestAllPermissions();
                Get.off(() => const HomePage());
              },
            ),

            Divider(),

            ListTile(
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 28,
                vertical: 2,
              ),
              title: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "ಕನ್ನಡ",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              onTap: () async {
                await localeProvider.setLocale('kn');
                Get.updateLocale(const Locale('kn'));
                await PermissionService.requestAllPermissions();
                Get.off(() => const HomePage());
              },
            ),

            Divider(),

            ListTile(
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 28,
                vertical: 2,
              ),
              title: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "తెలుగు",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              onTap: () async {
                await localeProvider.setLocale('te');
                Get.updateLocale(const Locale('te'));
                await PermissionService.requestAllPermissions();
                Get.off(() => const HomePage());
              },
            ),

            Divider(),

            ListTile(
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 28,
                vertical: 2,
              ),
              title: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "தமிழ்",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              onTap: () async {
                await localeProvider.setLocale('ta');
                Get.updateLocale(const Locale('ta'));
                await PermissionService.requestAllPermissions();
                Get.off(() => const HomePage());
              },
            ),
            Divider(),

            ListTile(
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 28,
                vertical: 2,
              ),
              title: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "मराठी",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              onTap: () async {
                await localeProvider.setLocale('mr');
                Get.updateLocale(const Locale('mr'));
                await PermissionService.requestAllPermissions();
                Get.off(() => const HomePage());
              },
            ),
            Divider(),
          ],
        ),
      ),
    );
  }
}
