import 'package:beehive_monitoring_system/Authentication/auth_api_service.dart';
import 'package:beehive_monitoring_system/Authentication/auth_provider.dart';
import 'package:beehive_monitoring_system/Authentication/login_screen.dart';
import 'package:beehive_monitoring_system/Chatbot/chatbot_screen.dart';
import 'package:beehive_monitoring_system/OtherScreens/about_us.dart';
import 'package:beehive_monitoring_system/OtherScreens/faqs.dart';
import 'package:beehive_monitoring_system/OtherScreens/key_features.dart';
import 'package:beehive_monitoring_system/OtherScreens/language_selection.dart';
import 'package:beehive_monitoring_system/feedBack/feedback.dart';
import 'package:beehive_monitoring_system/l10n/app_localizations.dart';
import 'package:beehive_monitoring_system/l10n/locale_provider.dart';
import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:provider/provider.dart';

class Setting extends StatelessWidget {
  const Setting({super.key});

  @override
  Widget build(BuildContext context) {
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
          AppLocalizations.of(context)!.settings,
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
            SizedBox(height: 10),

            Center(
              child: Icon(Icons.settings, color: Color(0xFF574422), size: 150),
            ),

            SizedBox(height: 10),

            ListTile(
              contentPadding: EdgeInsets.symmetric(horizontal: 28, vertical: 2),
              leading: Icon(Icons.person_outline, color: Color(0xFF574422)),
              title: Text(
                AppLocalizations.of(context)!.updateProfile,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                ),
              ),
              // onTap: () {
              //   Navigator.push(
              //     context,
              //     MaterialPageRoute(builder: (_) => ProfilePage()),
              //   );
              // },
            ),

            Divider(),

            ListTile(
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 28,
                vertical: 2,
              ),
              leading: Icon(Icons.language, color: Color(0xFF574422)),
              title: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    AppLocalizations.of(context)!.language,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(width: 8),
                  Icon(Icons.edit, size: 18, color: Color(0xFF574422)),
                ],
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => LanguageSelectionScreen()),
                );
              },
            ),

            Divider(),

            ListTile(
              contentPadding: EdgeInsets.symmetric(horizontal: 28, vertical: 2),
              leading: Icon(Icons.key, color: Color(0xFF574422)),
              title: Text(
                AppLocalizations.of(context)!.keyFeatures,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                ),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => KeyFeatures()),
                );
              },
            ),

            Divider(),

            ListTile(
              contentPadding: EdgeInsets.symmetric(horizontal: 28, vertical: 2),
              leading: Icon(
                Icons.chat_bubble_outline,
                color: Color(0xFF574422),
              ),
              title: Text(
                AppLocalizations.of(context)!.askChatbot,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                ),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => ChatbotScreen()),
                );
              },
            ),

            Divider(),

            ListTile(
              contentPadding: EdgeInsets.symmetric(horizontal: 28, vertical: 2),
              leading: Icon(Icons.help, color: Color(0xFF574422)),
              title: Text(
                AppLocalizations.of(context)!.goToFAQs,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                ),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => FAQS()),
                );
              },
            ),

            Divider(),

            ListTile(
              contentPadding: EdgeInsets.symmetric(horizontal: 28, vertical: 2),
              leading: Icon(Icons.groups, color: Color(0xFF574422)),
              title: Text(
                AppLocalizations.of(context)!.aboutUs,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                ),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => AboutUs()),
                );
              },
            ),

            Divider(),

            ListTile(
              contentPadding: EdgeInsets.symmetric(horizontal: 28, vertical: 2),
              leading: Icon(Icons.rate_review, color: Color(0xFF574422)),
              title: Text(
                AppLocalizations.of(context)!.feedback,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                ),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => FeedBack()),
                );
              },
            ),

            Divider(),

            ListTile(
              contentPadding: EdgeInsets.symmetric(horizontal: 28, vertical: 2),
              leading: Icon(
                Icons.logout,
                color: const Color.fromARGB(255, 166, 36, 13),
              ),
              title: Text(
                AppLocalizations.of(context)!.logout,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                ),
              ),
              onTap: () async {
                final shouldLogout = await showDialog<bool>(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      actionsAlignment: MainAxisAlignment.spaceBetween,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      title: Row(
                        children: [
                          Icon(
                            Icons.logout,
                            color: Color.fromARGB(255, 166, 36, 13),
                          ),
                          SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              "Logout",
                              style: TextStyle(fontSize: 20),
                            ),
                          ),
                        ],
                      ),
                      content: const Text(
                        "Are you sure you want to log out of BirsaKisanDrishti?",
                      ),
                      actions: [
                        TextButton(
                          style: TextButton.styleFrom(
                            backgroundColor: Colors.white,
                            side: BorderSide(
                              color: Color.fromARGB(255, 166, 36, 13),
                              width: 2,
                            ),
                          ),

                          onPressed: () {
                            Navigator.pop(context, false);
                          },
                          child: Text(
                            "Cancel",
                            style: TextStyle(
                              color: Color.fromARGB(255, 166, 36, 13),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        TextButton(
                          style: TextButton.styleFrom(
                            backgroundColor: Color.fromARGB(255, 166, 36, 13),
                          ),
                          onPressed: () {
                            Navigator.pop(context, true);
                          },
                          child: Text(
                            "Logout",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                );
                if (shouldLogout == true) {
                  try {
                    if (!context.mounted) return;
                    await context.read<AuthProvider>().logout();
                    if (!context.mounted) return;
                    await context.read<LocaleProvider>().resetLocale();
                    Get.updateLocale(const Locale('en'));
                    if (!context.mounted) return;
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (_) => const LoginScreen()),
                      (_) => false,
                    );
                  } catch (e) {
                    if (!context.mounted) return;
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text("Failed to logout account.\n$e"),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                }
              },
            ),

            Divider(),

            ListTile(
              contentPadding: EdgeInsets.symmetric(horizontal: 28, vertical: 2),
              leading: Icon(
                Icons.delete_outline,
                color: Color.fromARGB(255, 166, 36, 13),
              ),
              title: Text(
                AppLocalizations.of(context)!.deleteAccount,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                ),
              ),
              onTap: () async {
                final shouldDelete = await showDialog<bool>(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      actionsAlignment: MainAxisAlignment.spaceBetween,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      title: Row(
                        children: const [
                          Icon(
                            Icons.delete_outline,
                            color: Color.fromARGB(255, 166, 36, 13),
                          ),
                          SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              "Delete Account",
                              style: TextStyle(fontSize: 20),
                            ),
                          ),
                        ],
                      ),
                      content: const Text(
                        "Are you sure you want to permanently delete your BirsaKisanDrishti account? This action cannot be undone.",
                      ),
                      actions: [
                        TextButton(
                          style: TextButton.styleFrom(
                            backgroundColor: Colors.white,
                            side: BorderSide(
                              color: Color.fromARGB(255, 166, 36, 13),
                              width: 2,
                            ),
                          ),
                          onPressed: () {
                            Navigator.pop(context, false);
                          },
                          child: Text(
                            "Cancel",
                            style: TextStyle(
                              color: Color.fromARGB(255, 166, 36, 13),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        TextButton(
                          style: TextButton.styleFrom(
                            backgroundColor: Color.fromARGB(255, 166, 36, 13),
                          ),
                          onPressed: () {
                            Navigator.pop(context, true);
                          },
                          child: const Text(
                            "Delete",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                );
                if (shouldDelete == true) {
                  try {
                    if (!context.mounted) return;
                    await AuthApiService.deleteAccount();
                    if (!context.mounted) return;
                    await context.read<AuthProvider>().logout();
                    if (!context.mounted) return;
                    await context.read<LocaleProvider>().resetLocale();
                    Get.updateLocale(const Locale('en'));
                    if (!context.mounted) return;
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (_) => const LoginScreen()),
                      (_) => false,
                    );
                  } catch (e) {
                    if (!context.mounted) return;

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text("Failed to delete account.\n$e"),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                }
              },
            ),

            Divider(),
          ],
        ),
      ),
    );
  }
}
