import 'package:beehive_monitoring_system/l10n/app_localizations.dart';
import 'package:flutter/material.dart';

class LandingPage extends StatelessWidget {
  const LandingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Image.asset("assets/images/beebox.png"),
            SizedBox(height: 30),
            Text(
              AppLocalizations.of(context)!.setupApiary,
              style: TextStyle(
                color: Color(0xFF574422),
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              AppLocalizations.of(context)!.lessThanMin,
              style: TextStyle(color: Color(0xFF555252)),
            ),
            SizedBox(height: 50),
            ElevatedButton(
              onPressed: () {
                // Navigator.push(
                //   context,
                //   MaterialPageRoute(builder: (_) => ProfilePage()),
                // );
              },
              child: Text(
                AppLocalizations.of(context)!.cont,
                style: TextStyle(color: Color(0xFF574422)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
