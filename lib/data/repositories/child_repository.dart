import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';
import '../../core/constants/firestore_collections.dart';
import '../../core/services/firebase_service.dart';
import '../models/child_device_model.dart';
import '../models/rules_model.dart';
import '../models/sos_alert_model.dart';
import 'mock_data_store.dart';

class ChildRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final MockDataStore _mockStore = MockDataStore();
  final Uuid _uuid = const Uuid();

  /// Stream current rules for this child device
  Stream<RulesModel?> streamRules(String childId) {
    if (FirebaseService.isInitialized) {
      return _firestore
          .collection(FirestoreCollections.rules)
          .doc(childId)
          .snapshots()
          .map((doc) => doc.exists ? RulesModel.fromMap(doc.data()!, docId: doc.id) : null);
    } else {
      return _mockStore.streamRules(childId);
    }
  }

  /// Update child GPS coordinates and battery stats to Firestore
  Future<void> updateTelemetry({
    required String childId,
    required double latitude,
    required double longitude,
    required double accuracy,
    required int batteryLevel,
    required bool isCharging,
  }) async {
    final now = DateTime.now();
    if (FirebaseService.isInitialized) {
      await _firestore
          .collection(FirestoreCollections.children)
          .doc(childId)
          .update({
        'latitude': latitude,
        'longitude': longitude,
        'accuracy': accuracy,
        'batteryLevel': batteryLevel,
        'isCharging': isCharging,
        'isOnline': true,
        'lastPingAt': now.toIso8601String(),
      });
    } else {
      final existing = _mockStore.getChild(childId);
      if (existing != null) {
        await _mockStore.updateChild(
          existing.copyWith(
            latitude: latitude,
            longitude: longitude,
            accuracy: accuracy,
            batteryLevel: batteryLevel,
            isCharging: isCharging,
            isOnline: true,
            lastPingAt: now,
          ),
        );
      }
    }
  }

  /// Trigger emergency SOS alert
  Future<SosAlertModel> triggerSosAlert({
    required String childId,
    required String parentId,
    required String childName,
    required double latitude,
    required double longitude,
    required int batteryLevel,
  }) async {
    final alertId = _uuid.v4();
    final alert = SosAlertModel(
      alertId: alertId,
      childId: childId,
      parentId: parentId,
      childName: childName,
      latitude: latitude,
      longitude: longitude,
      batteryLevel: batteryLevel,
      timestamp: DateTime.now(),
      isResolved: false,
    );

    if (FirebaseService.isInitialized) {
      await _firestore
          .collection(FirestoreCollections.sosAlerts)
          .doc(alertId)
          .set(alert.toMap());
    } else {
      await _mockStore.triggerAlert(alert);
    }

    return alert;
  }
}
