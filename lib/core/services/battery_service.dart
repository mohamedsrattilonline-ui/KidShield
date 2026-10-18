import 'package:battery_plus/battery_plus.dart';
import 'package:flutter/foundation.dart';

class BatteryInfo {
  final int level;
  final bool isCharging;

  BatteryInfo({required this.level, required this.isCharging});
}

class BatteryService {
  static final Battery _battery = Battery();

  static Future<BatteryInfo> getBatteryInfo() async {
    try {
      final level = await _battery.batteryLevel;
      final state = await _battery.batteryState;
      final isCharging = (state == BatteryState.charging || state == BatteryState.full);
      return BatteryInfo(level: level, isCharging: isCharging);
    } catch (e) {
      debugPrint('[BatteryService] Failed to read battery level: $e. Fallback to 88%');
      return BatteryInfo(level: 88, isCharging: false);
    }
  }

  static Stream<BatteryState> get onBatteryStateChanged {
    try {
      return _battery.onBatteryStateChanged;
    } catch (e) {
      return const Stream.empty();
    }
  }
}
