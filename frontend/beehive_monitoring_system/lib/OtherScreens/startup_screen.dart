import 'package:beehive_monitoring_system/Authentication/auth_provider.dart';
import 'package:beehive_monitoring_system/OtherScreens/dashboard.dart';
import 'package:beehive_monitoring_system/OtherScreens/language_selection.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class StartupScreen extends StatefulWidget {
  const StartupScreen({super.key});

  @override
  State<StartupScreen> createState() => _StartupScreenState();
}

class _StartupScreenState extends State<StartupScreen> {
  @override
  void initState() {
    super.initState();
    _checkLanguage();
  }

  Future<void> _checkLanguage() async {
    final authProvider = context.read<AuthProvider>();
    final language = authProvider.currentUser?.preferredLanguage;

    if (!mounted) return;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => language == null
              ? const LanguageSelectionScreen()
              : const HomePage(),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Center(child: CircularProgressIndicator()));
  }
}
