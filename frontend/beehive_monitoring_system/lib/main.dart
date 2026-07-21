import 'package:beehive_monitoring_system/Authentication/auth_provider.dart';
// import 'package:beehive_monitoring_system/Authentication/splash_screen.dart';
import 'package:beehive_monitoring_system/OtherScreens/dashboard.dart';
import 'package:beehive_monitoring_system/l10n/app_localizations.dart';
import 'package:beehive_monitoring_system/l10n/locale_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final localeProvider = LocaleProvider();
  await localeProvider.loadLocale();
  await dotenv.load(fileName: ".env");

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: localeProvider),
        ChangeNotifierProvider(create: (_) => AuthProvider()..restoreSession()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final localeProvider = context.watch<LocaleProvider>();
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      locale: localeProvider.locale,
      supportedLocales: const [
        Locale('en'),
        Locale('hi'),
        Locale('bn'),
        Locale('as'),
        Locale('gu'),
        Locale('kn'),
        Locale('ml'),
        Locale('mr'),
        Locale('or'),
        Locale('pa'),
        Locale('ta'),
        Locale('te'),
      ],

      localizationsDelegates: AppLocalizations.localizationsDelegates,

      theme: ThemeData(
        colorSchemeSeed: const Color(0xFFC98D26),
        useMaterial3: true,
        textTheme: GoogleFonts.interTextTheme(),
      ),
      home: const HomePage(),
    );
  }
}
