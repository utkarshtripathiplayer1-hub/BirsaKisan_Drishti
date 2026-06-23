import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocaleProvider extends ChangeNotifier {
  Locale _locale = const Locale('en');

  Locale get locale => _locale;

  Future<void> setLocale(String languageCode) async {
    _locale = Locale(languageCode);

    final prefs = await SharedPreferences.getInstance();

    await prefs.setString(
      'selected_language',
      languageCode,
    );

    notifyListeners();
  }

  Future<void> loadLocale() async {
    final prefs = await SharedPreferences.getInstance();

    final languageCode =
        prefs.getString('selected_language') ?? 'en';

    _locale = Locale(languageCode);

    notifyListeners();
  }
}