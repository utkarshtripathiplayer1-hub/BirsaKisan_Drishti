import 'package:crop_recommendation_system/Chatbot/chatbot_screen.dart';
import 'package:crop_recommendation_system/OtherScreens/about_us.dart';
import 'package:crop_recommendation_system/OtherScreens/faqs.dart';
import 'package:crop_recommendation_system/OtherScreens/feedback.dart';
import 'package:crop_recommendation_system/OtherScreens/key_features.dart';
import 'package:crop_recommendation_system/OtherScreens/language_selection.dart';
import 'package:crop_recommendation_system/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';


class Setting extends StatelessWidget {
  const Setting({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Colors.white,
          size: 30,
          weight: 40.0,
        ),
        centerTitle: true,
        title: AutoSizeText(
          minFontSize: 15,
          AppLocalizations.of(context)!.settings,
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 35,
          ),
        ),
        backgroundColor: Colors.green.shade900,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 10),

            Center(child: Icon(Icons.settings, color: Colors.black, size: 150)),

            SizedBox(height: 10),

            ListTile(
              contentPadding: EdgeInsets.symmetric(horizontal: 28, vertical: 2),
              leading: Icon(Icons.person_outline),
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
              //     MaterialPageRoute(builder: (_) => AboutUs()),
              //   );
              // },
            ),

            Divider(),

            ListTile(
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 28,
                vertical: 2,
              ),
              leading: const Icon(Icons.language),
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
                  Icon(Icons.edit, size: 18),
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
              leading: Icon(Icons.key),
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
              leading: Icon(Icons.chat_bubble_outline),
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
              leading: Icon(Icons.help),
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
              leading: Icon(Icons.groups),
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
              leading: Icon(Icons.logout),
              title: Text(
                AppLocalizations.of(context)!.logout,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                ),
              ),
              onTap: () {},
            ),

            Divider(),

            ListTile(
              contentPadding: EdgeInsets.symmetric(horizontal: 28, vertical: 2),
              leading: Icon(Icons.delete_outline),
              title: Text(
                AppLocalizations.of(context)!.deleteAccount,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                ),
              ),
              onTap: () {},
            ),

            Divider(),

            ListTile(
              contentPadding: EdgeInsets.symmetric(horizontal: 28, vertical: 2),
              leading: Icon(Icons.rate_review),
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
          ],
        ),
      ),
    );
  }
}
