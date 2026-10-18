class AppConstants {
  static const String appName = 'KidShield | حماية الطفل';
  static const String appVersion = '1.0.0';
  
  // Storage keys
  static const String keyAppMode = 'selected_app_mode';
  static const String keySelectedLanguage = 'selected_language';
  static const String keyChildId = 'registered_child_id';
  static const String keyParentId = 'registered_parent_id';
  static const String keyChildName = 'registered_child_name';

  // Modes
  static const String modeParent = 'PARENT';
  static const String modeChild = 'CHILD';

  // Pairing constants
  static const int pairingCodeLength = 6;
  static const int pairingCodeExpiryMinutes = 15;

  // Telemetry intervals
  static const int locationUpdateIntervalSeconds = 10;
  static const int batteryUpdateIntervalMinutes = 1;
  static const int lowBatteryThreshold = 20;

  // Platform Channel
  static const String platformChannelName = 'com.parental.safety/app_manager';
}
