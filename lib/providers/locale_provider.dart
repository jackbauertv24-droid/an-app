import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocaleProvider extends ChangeNotifier {
  Locale _locale = const Locale('zh', 'Hant'); // Default to Traditional Chinese
  static const String _localeKey = 'selected_locale';

  Locale get locale => _locale;

  LocaleProvider() {
    _loadLocale();
  }

  Future<void> _loadLocale() async {
    final prefs = await SharedPreferences.getInstance();
    final localeCode = prefs.getString(_localeKey);
    if (localeCode != null) {
      final parts = localeCode.split('_');
      if (parts.length == 2) {
        _locale = Locale(parts[0], parts[1]);
      } else {
        _locale = Locale(parts[0]);
      }
      notifyListeners();
    }
  }

  Future<void> setLocale(Locale locale) async {
    _locale = locale;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_localeKey, '${locale.languageCode}_${locale.countryCode ?? ''}');
    notifyListeners();
  }

  void setTraditionalChinese() => setLocale(const Locale('zh', 'Hant'));
  void setSimplifiedChinese() => setLocale(const Locale('zh', 'Hans'));
  void setEnglish() => setLocale(const Locale('en'));
}
