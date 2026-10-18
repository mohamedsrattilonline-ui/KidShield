import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import '../core/constants/app_constants.dart';
import '../core/services/battery_service.dart';
import '../core/services/location_service.dart';
import '../core/services/platform_channel_service.dart';
import '../data/models/rules_model.dart';
import '../data/repositories/child_repository.dart';
import '../data/repositories/pairing_repository.dart';

class ChildTelemetryProvider extends ChangeNotifier {
  final ChildRepository _childRepository = ChildRepository();
  final PairingRepository _pairingRepository = PairingRepository();

  String? _childId;
  String? _parentId;
  String? _childName;
  bool _isPaired = false;
  bool _isPairing = false;
  String? _pairingError;

  // Live telemetry state
  double _currentLatitude = LocationService.fallbackLat;
  double _currentLongitude = LocationService.fallbackLng;
  double _currentAccuracy = 10.0;
  int _currentBatteryLevel = 90;
  bool _isCharging = false;
  bool _isProtectionActive = false;

  // Bedtime & Lock state
  RulesModel? _currentRules;
  bool _isDeviceLocked = false;

  Timer? _telemetryTimer;
  StreamSubscription? _rulesSub;

  String? get childId => _childId;
  String? get parentId => _parentId;
  String? get childName => _childName;
  bool get isPaired => _isPaired;
  bool get isPairing => _isPairing;
  String? get pairingError => _pairingError;

  double get currentLatitude => _currentLatitude;
  double get currentLongitude => _currentLongitude;
  int get currentBatteryLevel => _currentBatteryLevel;
  bool get isCharging => _isCharging;
  bool get isProtectionActive => _isProtectionActive;
  bool get isDeviceLocked => _isDeviceLocked;
  RulesModel? get currentRules => _currentRules;

  ChildTelemetryProvider() {
    _loadChildState();
  }

  Future<void> _loadChildState() async {
    final prefs = await SharedPreferences.getInstance();
    _childId = prefs.getString(AppConstants.keyChildId);
    _parentId = prefs.getString(AppConstants.keyParentId);
    _childName = prefs.getString(AppConstants.keyChildName);

    if (_childId != null && _parentId != null) {
      _isPaired = true;
      startActiveProtection();
    }
    notifyListeners();
  }

  Future<bool> pairWithPin({
    required String pin,
    required String customChildName,
  }) async {
    _isPairing = true;
    _pairingError = null;
    notifyListeners();

    try {
      final generatedId = const Uuid().v4();
      final platformName = defaultTargetPlatform.name;

      final success = await _pairingRepository.linkDeviceWithPin(
        pin: pin.trim(),
        childId: generatedId,
        childName: customChildName.trim(),
        deviceName: 'Device ($platformName)',
        platform: platformName,
      );

      if (success) {
        _childId = generatedId;
        _childName = customChildName.isNotEmpty ? customChildName : 'Protected Child';
        
        // Find associated parentId from store or cache
        _parentId = 'parent_user_01'; // Default linked parent
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString(AppConstants.keyChildId, _childId!);
        await prefs.setString(AppConstants.keyParentId, _parentId!);
        await prefs.setString(AppConstants.keyChildName, _childName!);

        _isPaired = true;
        _isPairing = false;
        startActiveProtection();
        notifyListeners();
        return true;
      } else {
        _pairingError = 'Invalid or expired 6-digit PIN code.';
        _isPairing = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      _pairingError = 'Pairing error: $e';
      _isPairing = false;
      notifyListeners();
      return false;
    }
  }

  void startActiveProtection() {
    if (_isProtectionActive) return;
    _isProtectionActive = true;

    // Start native Android foreground service
    PlatformChannelService.startLocationForegroundService();

    // Listen to live rules
    if (_childId != null) {
      _rulesSub?.cancel();
      _rulesSub = _childRepository.streamRules(_childId!).listen((rules) {
        if (rules != null) {
          _currentRules = rules;
          _isDeviceLocked = rules.shouldLockDevice;
          PlatformChannelService.setNativeLockOverlay(_isDeviceLocked);
          notifyListeners();
        }
      });
    }

    // Start periodic background telemetry update (every 10 seconds)
    _telemetryTimer?.cancel();
    _telemetryTimer = Timer.periodic(
      const Duration(seconds: AppConstants.locationUpdateIntervalSeconds),
      (_) => _publishTelemetry(),
    );

    // Initial publish
    _publishTelemetry();
    notifyListeners();
  }

  Future<void> _publishTelemetry() async {
    if (_childId == null) return;
    try {
      final loc = await LocationService.getCurrentLocation();
      final battery = await BatteryService.getBatteryInfo();

      _currentLatitude = loc.latitude;
      _currentLongitude = loc.longitude;
      _currentAccuracy = loc.accuracy;
      _currentBatteryLevel = battery.level;
      _isCharging = battery.isCharging;

      await _childRepository.updateTelemetry(
        childId: _childId!,
        latitude: _currentLatitude,
        longitude: _currentLongitude,
        accuracy: _currentAccuracy,
        batteryLevel: _currentBatteryLevel,
        isCharging: _isCharging,
      );

      // Check bedtime lock on device
      if (_currentRules != null) {
        final lockState = _currentRules!.shouldLockDevice;
        if (lockState != _isDeviceLocked) {
          _isDeviceLocked = lockState;
          PlatformChannelService.setNativeLockOverlay(_isDeviceLocked);
        }
      }

      notifyListeners();
    } catch (e) {
      debugPrint('[ChildTelemetryProvider] Telemetry sync error: $e');
    }
  }

  Future<void> triggerEmergencySos() async {
    if (_childId == null || _parentId == null) return;

    final loc = await LocationService.getCurrentLocation();
    final battery = await BatteryService.getBatteryInfo();

    await _childRepository.triggerSosAlert(
      childId: _childId!,
      parentId: _parentId!,
      childName: _childName ?? 'Child Device',
      latitude: loc.latitude,
      longitude: loc.longitude,
      batteryLevel: battery.level,
    );
  }

  Future<void> unpairDevice() async {
    _telemetryTimer?.cancel();
    _rulesSub?.cancel();
    PlatformChannelService.stopLocationForegroundService();

    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(AppConstants.keyChildId);
    await prefs.remove(AppConstants.keyParentId);
    await prefs.remove(AppConstants.keyChildName);

    _childId = null;
    _parentId = null;
    _childName = null;
    _isPaired = false;
    _isProtectionActive = false;
    _isDeviceLocked = false;
    notifyListeners();
  }

  @override
  void dispose() {
    _telemetryTimer?.cancel();
    _rulesSub?.cancel();
    super.dispose();
  }
}
