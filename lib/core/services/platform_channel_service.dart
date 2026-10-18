import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import '../constants/app_constants.dart';

class PlatformChannelService {
  static const MethodChannel _channel =
      MethodChannel(AppConstants.platformChannelName);

  /// Checks if UsageStats permission (SPECIAL ACCESS) is granted on Android
  static Future<bool> checkUsageStatsPermission() async {
    if (defaultTargetPlatform != TargetPlatform.android) return false;
    try {
      final bool hasPermission =
          await _channel.invokeMethod('checkUsageStatsPermission') ?? false;
      return hasPermission;
    } on PlatformException catch (e) {
      debugPrint('[PlatformChannel] checkUsageStatsPermission error: ${e.message}');
      return false;
    }
  }

  /// Opens Android system settings for Usage Access
  static Future<void> requestUsageStatsPermission() async {
    if (defaultTargetPlatform != TargetPlatform.android) return;
    try {
      await _channel.invokeMethod('requestUsageStatsPermission');
    } on PlatformException catch (e) {
      debugPrint('[PlatformChannel] requestUsageStatsPermission error: ${e.message}');
    }
  }

  /// Checks if AccessibilityService is active on Android
  static Future<bool> checkAccessibilityPermission() async {
    if (defaultTargetPlatform != TargetPlatform.android) return false;
    try {
      final bool isEnabled =
          await _channel.invokeMethod('checkAccessibilityPermission') ?? false;
      return isEnabled;
    } on PlatformException catch (e) {
      debugPrint('[PlatformChannel] checkAccessibilityPermission error: ${e.message}');
      return false;
    }
  }

  /// Opens Android Accessibility Settings
  static Future<void> requestAccessibilityPermission() async {
    if (defaultTargetPlatform != TargetPlatform.android) return;
    try {
      await _channel.invokeMethod('requestAccessibilityPermission');
    } on PlatformException catch (e) {
      debugPrint('[PlatformChannel] requestAccessibilityPermission error: ${e.message}');
    }
  }

  /// Starts Android Foreground Service for persistent GPS telemetry
  static Future<void> startLocationForegroundService() async {
    if (defaultTargetPlatform != TargetPlatform.android) return;
    try {
      await _channel.invokeMethod('startLocationForegroundService');
    } on PlatformException catch (e) {
      debugPrint('[PlatformChannel] startLocationForegroundService error: ${e.message}');
    }
  }

  /// Stops Android Foreground Service
  static Future<void> stopLocationForegroundService() async {
    if (defaultTargetPlatform != TargetPlatform.android) return;
    try {
      await _channel.invokeMethod('stopLocationForegroundService');
    } on PlatformException catch (e) {
      debugPrint('[PlatformChannel] stopLocationForegroundService error: ${e.message}');
    }
  }

  /// Fetches daily foreground usage stats per app (Android)
  static Future<List<Map<String, dynamic>>> getDailyAppUsage() async {
    if (defaultTargetPlatform != TargetPlatform.android) return [];
    try {
      final List<dynamic>? stats =
          await _channel.invokeMethod('getDailyAppUsage');
      if (stats != null) {
        return stats.map((e) => Map<String, dynamic>.from(e as Map)).toList();
      }
      return [];
    } on PlatformException catch (e) {
      debugPrint('[PlatformChannel] getDailyAppUsage error: ${e.message}');
      return [];
    }
  }

  /// Triggers or dismisses native lock overlay (Android / iOS)
  static Future<void> setNativeLockOverlay(bool isLocked) async {
    try {
      await _channel.invokeMethod('setNativeLockOverlay', {'isLocked': isLocked});
    } on PlatformException catch (e) {
      debugPrint('[PlatformChannel] setNativeLockOverlay error: ${e.message}');
    }
  }

  /// iOS FamilyControls authorization stub
  static Future<bool> requestFamilyControlsIOS() async {
    if (defaultTargetPlatform != TargetPlatform.iOS) return false;
    try {
      final bool granted =
          await _channel.invokeMethod('requestFamilyControls') ?? false;
      return granted;
    } on PlatformException catch (e) {
      debugPrint('[PlatformChannel] requestFamilyControls error: ${e.message}');
      return false;
    }
  }
}
