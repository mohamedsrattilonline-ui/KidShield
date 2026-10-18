import 'package:cloud_firestore/cloud_firestore.dart';
import '../../core/constants/firestore_collections.dart';
import '../../core/services/firebase_service.dart';
import '../models/child_device_model.dart';
import '../models/rules_model.dart';
import '../models/sos_alert_model.dart';
import '../models/web_activity_model.dart';
import 'mock_data_store.dart';

class ParentRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final MockDataStore _mockStore = MockDataStore();

  /// Stream all children linked to this parent
  Stream<List<ChildDeviceModel>> streamChildren(String parentId) {
    if (FirebaseService.isInitialized) {
      return _firestore
          .collection(FirestoreCollections.children)
          .where('parentId', isEqualTo: parentId)
          .snapshots()
          .map((snapshot) => snapshot.docs
              .map((doc) => ChildDeviceModel.fromMap(doc.data(), docId: doc.id))
              .toList());
    } else {
      return _mockStore.streamChildren(parentId);
    }
  }

  /// Stream unhandled SOS alerts for this parent
  Stream<List<SosAlertModel>> streamSosAlerts(String parentId) {
    if (FirebaseService.isInitialized) {
      return _firestore
          .collection(FirestoreCollections.sosAlerts)
          .where('parentId', isEqualTo: parentId)
          .where('isResolved', isEqualTo: false)
          .snapshots()
          .map((snapshot) => snapshot.docs
              .map((doc) => SosAlertModel.fromMap(doc.data(), docId: doc.id))
              .toList());
    } else {
      return _mockStore.streamAlerts(parentId);
    }
  }

  /// Mark SOS alert as resolved
  Future<void> resolveSosAlert(String alertId) async {
    if (FirebaseService.isInitialized) {
      await _firestore
          .collection(FirestoreCollections.sosAlerts)
          .doc(alertId)
          .update({'isResolved': true});
    } else {
      await _mockStore.resolveAlert(alertId);
    }
  }

  /// Update rules and bedtime locks for a child
  Future<void> updateChildRules(RulesModel rules) async {
    if (FirebaseService.isInitialized) {
      await _firestore
          .collection(FirestoreCollections.rules)
          .doc(rules.childId)
          .set(rules.toMap(), SetOptions(merge: true));

      // Also update child's bedtime locked state directly
      await _firestore
          .collection(FirestoreCollections.children)
          .doc(rules.childId)
          .update({'isBedtimeLocked': rules.shouldLockDevice});
    } else {
      await _mockStore.updateRules(rules);
    }
  }

  /// Get rules for a child
  Future<RulesModel> getChildRules(String childId) async {
    if (FirebaseService.isInitialized) {
      final doc = await _firestore
          .collection(FirestoreCollections.rules)
          .doc(childId)
          .get();
      if (doc.exists) {
        return RulesModel.fromMap(doc.data()!, docId: doc.id);
      }
    }
    return RulesModel(childId: childId);
  }

  /// Stream web activity logs for child
  Stream<List<WebActivityModel>> streamWebActivity(String childId) {
    if (FirebaseService.isInitialized) {
      return _firestore
          .collection('web_activity')
          .where('childId', isEqualTo: childId)
          .orderBy('timestamp', descending: true)
          .snapshots()
          .map((snapshot) => snapshot.docs
              .map((doc) => WebActivityModel.fromMap(doc.data(), docId: doc.id))
              .toList());
    } else {
      return _mockStore.streamWebActivity(childId);
    }
  }
}
