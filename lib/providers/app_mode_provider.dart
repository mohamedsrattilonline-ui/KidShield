import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../core/constants/app_constants.dart';

enum AppMode {
  none,   // Not yet selected (shows Onboarding)
  parent, // Parent Dashboard
  child,  // Child Device
}

class AppModeProvider extends ChangeNotifier {
  AppMode _currentMode = AppMode.none;
  Locale _currentLocale = const Locale('ar'); // Default to Arabic RTL as requested
  bool _isInitialized = false;

  AppMode get currentMode => _currentMode;
  Locale get currentLocale => _currentLocale;
  bool get isInitialized => _isInitialized;
  bool get isArabic => _currentLocale.languageCode == 'ar';

  AppModeProvider() {
    _loadPreferences();
  }

  Future<void> _loadPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    final modeStr = prefs.getString(AppConstants.keyAppMode);
    if (modeStr == AppConstants.modeParent) {
      _currentMode = AppMode.parent;
    } else if (modeStr == AppConstants.modeChild) {
      _currentMode = AppMode.child;
    } else {
      _currentMode = AppMode.none;
    }

    final langStr = prefs.getString(AppConstants.keySelectedLanguage);
    if (langStr != null) {
      _currentLocale = Locale(langStr);
    }

    _isInitialized = true;
    notifyListeners();
  }

  Future<void> setAppMode(AppMode mode) async {
    _currentMode = mode;
    final prefs = await SharedPreferences.getInstance();
    if (mode == AppMode.parent) {
      await prefs.setString(AppConstants.keyAppMode, AppConstants.modeParent);
    } else if (mode == AppMode.child) {
      await prefs.setString(AppConstants.keyAppMode, AppConstants.modeChild);
    } else {
      await prefs.remove(AppConstants.keyAppMode);
    }
    notifyListeners();
  }

  Future<void> setLocale(Locale locale) async {
    _currentLocale = locale;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(AppConstants.keySelectedLanguage, locale.languageCode);
    notifyListeners();
  }

  void toggleLanguage() {
    if (_currentLocale.languageCode == 'ar') {
      setLocale(const Locale('en'));
    } else {
      setLocale(const Locale('ar'));
    }
  }

  Future<void> resetToOnboarding() async {
    _currentMode = AppMode.none;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(AppConstants.keyAppMode);
    notifyListeners();
  }
}
