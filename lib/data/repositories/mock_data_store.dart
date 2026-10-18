import 'dart:async';
import '../models/child_device_model.dart';
import '../models/pairing_code_model.dart';
import '../models/rules_model.dart';
import '../models/sos_alert_model.dart';
import '../models/web_activity_model.dart';

/// Singleton in-memory reactive store that mimics Firestore collections
/// and provides live streams for real-time updates across screens.
class MockDataStore {
  static final MockDataStore _instance = MockDataStore._internal();
  factory MockDataStore() => _instance;
  MockDataStore._internal() {
    _initSeedData();
  }

  // Children StreamController
  final Map<String, ChildDeviceModel> _children = {};
  final StreamController<List<ChildDeviceModel>> _childrenStreamController =
      StreamController<List<ChildDeviceModel>>.broadcast();

  // Pairing Codes
  final Map<String, PairingCodeModel> _pairingCodes = {};

  // Rules
  final Map<String, RulesModel> _rules = {};
  final StreamController<RulesModel> _rulesStreamController =
      StreamController<RulesModel>.broadcast();

  // Alerts
  final List<SosAlertModel> _alerts = [];
  final StreamController<List<SosAlertModel>> _alertsStreamController =
      StreamController<List<SosAlertModel>>.broadcast();

  // Web Activity Logs
  final List<WebActivityModel> _webActivities = [];
  final StreamController<List<WebActivityModel>> _webActivityStreamController =
      StreamController<List<WebActivityModel>>.broadcast();

  void _initSeedData() {
    // Initial sample child for immediate testing & visualization
    final defaultChild = ChildDeviceModel(
      childId: 'child_sample_01',
      parentId: 'parent_user_01',
      childName: 'Sarah (سارة)',
      deviceName: 'Samsung Galaxy A53',
      platform: 'android',
      latitude: 30.0444,
      longitude: 31.2357,
      accuracy: 8.5,
      batteryLevel: 78,
      isCharging: false,
      isOnline: true,
      isBedtimeLocked: false,
      lastPingAt: DateTime.now(),
    );
    _children[defaultChild.childId] = defaultChild;

    _rules[defaultChild.childId] = RulesModel(
      childId: defaultChild.childId,
      dailyLimitMinutes: 120,
      usedMinutesToday: 45,
      bedtimeStart: '21:00',
      bedtimeEnd: '07:00',
      isBedtimeEnabled: false,
      isRemoteLocked: false,
      isWebFilteringEnabled: false,
      blockAdultContent: false,
      logWebHistory: true,
    );


    // Initial realistic browsing activity for demonstration
    final now = DateTime.now();
    _webActivities.addAll([
      WebActivityModel(
        id: 'web_01',
        childId: defaultChild.childId,
        domain: 'youtube.com',
        pageTitle: 'Educational Science Experiments for Kids',
        category: 'Entertainment',
        isBlocked: false,
        timestamp: now.subtract(const Duration(minutes: 15)),
      ),
      WebActivityModel(
        id: 'web_02',
        childId: defaultChild.childId,
        domain: 'wikipedia.org',
        pageTitle: 'Solar System - Wikipedia',
        category: 'Education',
        isBlocked: false,
        timestamp: now.subtract(const Duration(minutes: 38)),
      ),
      WebActivityModel(
        id: 'web_03',
        childId: defaultChild.childId,
        domain: 'khanacademy.org',
        pageTitle: 'Math Practice 5th Grade',
        category: 'Education',
        isBlocked: false,
        timestamp: now.subtract(const Duration(minutes: 55)),
      ),
      WebActivityModel(
        id: 'web_04',
        childId: defaultChild.childId,
        domain: 'unknown-suspicious-site.com',
        pageTitle: 'Restricted Adult Content',
        category: 'Restricted / Adult',
        isBlocked: true,
        timestamp: now.subtract(const Duration(hours: 2)),
      ),
    ]);
  }

  // Children Methods
  Stream<List<ChildDeviceModel>> streamChildren(String parentId) {
    Timer.run(() {
      final list = _children.values.where((c) => c.parentId == parentId).toList();
      _childrenStreamController.add(list);
    });
    return _childrenStreamController.stream.map(
      (list) => list.where((c) => c.parentId == parentId).toList(),
    );
  }

  Future<void> updateChild(ChildDeviceModel child) async {
    _children[child.childId] = child;
    _childrenStreamController.add(_children.values.toList());
  }

  ChildDeviceModel? getChild(String childId) => _children[childId];

  // Pairing Methods
  Future<void> savePairingCode(PairingCodeModel code) async {
    _pairingCodes[code.code] = code;
  }

  Future<PairingCodeModel?> findPairingCode(String pin) async {
    return _pairingCodes[pin];
  }

  Future<bool> linkChildDevice({
    required String pin,
    required String childId,
    required String childName,
    required String deviceName,
    required String platform,
  }) async {
    final record = _pairingCodes[pin];
    if (record == null || record.isExpired || record.isUsed) {
      return false;
    }

    final newChild = ChildDeviceModel(
      childId: childId,
      parentId: record.parentId,
      childName: childName.isNotEmpty ? childName : record.childTempName,
      deviceName: deviceName,
      platform: platform,
      latitude: 30.0444,
      longitude: 31.2357,
      accuracy: 10.0,
      batteryLevel: 95,
      isCharging: false,
      isOnline: true,
      isBedtimeLocked: false,
      lastPingAt: DateTime.now(),
    );

    _children[childId] = newChild;
    _rules[childId] = RulesModel(childId: childId);
    _pairingCodes[pin] = PairingCodeModel(
      code: record.code,
      parentId: record.parentId,
      childTempName: record.childTempName,
      createdAt: record.createdAt,
      expiresAt: record.expiresAt,
      isUsed: true,
      linkedChildId: childId,
    );

    _childrenStreamController.add(_children.values.toList());
    return true;
  }

  // Rules Methods
  Stream<RulesModel?> streamRules(String childId) {
    Timer.run(() {
      final r = _rules[childId] ?? RulesModel(childId: childId);
      _rulesStreamController.add(r);
    });
    return _rulesStreamController.stream.where((r) => r.childId == childId);
  }

  Future<void> updateRules(RulesModel rules) async {
    _rules[rules.childId] = rules;
    _rulesStreamController.add(rules);

    // Also update lock state on child model
    final child = _children[rules.childId];
    if (child != null) {
      _children[rules.childId] = child.copyWith(
        isBedtimeLocked: rules.shouldLockDevice,
      );
      _childrenStreamController.add(_children.values.toList());
    }
  }

  // Alerts Methods
  Stream<List<SosAlertModel>> streamAlerts(String parentId) {
    Timer.run(() {
      final list = _alerts.where((a) => a.parentId == parentId && !a.isResolved).toList();
      _alertsStreamController.add(list);
    });
    return _alertsStreamController.stream.map(
      (list) => list.where((a) => a.parentId == parentId && !a.isResolved).toList(),
    );
  }

  Future<void> triggerAlert(SosAlertModel alert) async {
    _alerts.insert(0, alert);
    _alertsStreamController.add(_alerts);
  }

  Future<void> resolveAlert(String alertId) async {
    final idx = _alerts.indexWhere((a) => a.alertId == alertId);
    if (idx != -1) {
      final old = _alerts[idx];
      _alerts[idx] = SosAlertModel(
        alertId: old.alertId,
        childId: old.childId,
        parentId: old.parentId,
        childName: old.childName,
        latitude: old.latitude,
        longitude: old.longitude,
        batteryLevel: old.batteryLevel,
        timestamp: old.timestamp,
        isResolved: true,
      );
      _alertsStreamController.add(_alerts);
    }
  }

  // Web Activity Methods
  Stream<List<WebActivityModel>> streamWebActivity(String childId) {
    Timer.run(() {
      final list = _webActivities.where((w) => w.childId == childId).toList();
      _webActivityStreamController.add(list);
    });
    return _webActivityStreamController.stream.map(
      (list) => list.where((w) => w.childId == childId).toList(),
    );
  }

  Future<void> logWebActivity(WebActivityModel activity) async {
    _webActivities.insert(0, activity);
    _webActivityStreamController.add(_webActivities);
  }
}
