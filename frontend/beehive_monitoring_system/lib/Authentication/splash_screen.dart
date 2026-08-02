import 'package:beehive_monitoring_system/Authentication/auth_provider.dart';
import 'package:beehive_monitoring_system/Authentication/login_screen.dart';
import 'package:beehive_monitoring_system/OtherScreens/startup_screen.dart';
import 'package:beehive_monitoring_system/l10n/locale_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _initialize();
  }

  Future<void> _initialize() async {
    final authProvider = context.read<AuthProvider>();

    await authProvider.restoreSession();

    if (!mounted) return;

    if (authProvider.isAuthenticated) {
      final language = authProvider.currentUser?.preferredLanguage ?? "en";

      await context.read<LocaleProvider>().setLocale(language);

      if (!mounted) return;

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const StartupScreen()),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const LoginScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Center(child: CircularProgressIndicator()));
  }
}
