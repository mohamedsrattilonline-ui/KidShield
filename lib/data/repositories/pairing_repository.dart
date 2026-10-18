import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../core/constants/firestore_collections.dart';
import '../../core/services/firebase_service.dart';
import '../models/pairing_code_model.dart';
import 'mock_data_store.dart';

class PairingRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final MockDataStore _mockStore = MockDataStore();

  /// Generates a random 6-digit numeric PIN
  String generate6DigitPin() {
    final random = Random();
    final pin = 100000 + random.nextInt(900000);
    return pin.toString();
  }

  /// Create a new pairing code record with 15 min expiration
  Future<PairingCodeModel> createPairingCode({
    required String parentId,
    required String childTempName,
  }) async {
    final pin = generate6DigitPin();
    final now = DateTime.now();
    final expiresAt = now.add(const Duration(minutes: 15));

    final model = PairingCodeModel(
      code: pin,
      parentId: parentId,
      childTempName: childTempName,
      createdAt: now,
      expiresAt: expiresAt,
      isUsed: false,
    );

    if (FirebaseService.isInitialized) {
      await _firestore
          .collection(FirestoreCollections.pairingCodes)
          .doc(pin)
          .set(model.toMap());
    } else {
      await _mockStore.savePairingCode(model);
    }

    return model;
  }

  /// Link child device to parent using 6-digit PIN or QR payload
  Future<bool> linkDeviceWithPin({
    required String pin,
    required String childId,
    required String childName,
    required String deviceName,
    required String platform,
  }) async {
    if (FirebaseService.isInitialized) {
      final docRef = _firestore
          .collection(FirestoreCollections.pairingCodes)
          .doc(pin);
      final doc = await docRef.get();

      if (!doc.exists) return false;
      final data = doc.data()!;
      final expiresAt = DateTime.tryParse(data['expiresAt'].toString());
      final isUsed = data['isUsed'] as bool? ?? false;

      if (isUsed || (expiresAt != null && DateTime.now().isAfter(expiresAt))) {
        return false;
      }

      final parentId = data['parentId'] as String;
      final finalChildName =
          childName.isNotEmpty ? childName : (data['childTempName'] ?? 'Child');

      // Create child document
      await _firestore
          .collection(FirestoreCollections.children)
          .doc(childId)
          .set({
        'childId': childId,
        'parentId': parentId,
        'childName': finalChildName,
        'deviceName': deviceName,
        'platform': platform,
        'latitude': 30.0444,
        'longitude': 31.2357,
        'accuracy': 10.0,
        'batteryLevel': 95,
        'isCharging': false,
        'isOnline': true,
        'isBedtimeLocked': false,
        'lastPingAt': DateTime.now().toIso8601String(),
      });

      // Mark pairing code as used
      await docRef.update({
        'isUsed': true,
        'linkedChildId': childId,
      });

      // Initialize default rules
      await _firestore
          .collection(FirestoreCollections.rules)
          .doc(childId)
          .set({
        'childId': childId,
        'dailyLimitMinutes': 120,
        'usedMinutesToday': 0,
        'bedtimeStart': '21:00',
        'bedtimeEnd': '07:00',
        'isBedtimeEnabled': true,
        'isRemoteLocked': false,
        'blockedPackages': [],
        'updatedAt': DateTime.now().toIso8601String(),
      });

      return true;
    } else {
      return await _mockStore.linkChildDevice(
        pin: pin,
        childId: childId,
        childName: childName,
        deviceName: deviceName,
        platform: platform,
      );
    }
  }
}
