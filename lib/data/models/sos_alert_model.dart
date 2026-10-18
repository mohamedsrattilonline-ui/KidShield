class SosAlertModel {
  final String alertId;
  final String childId;
  final String parentId;
  final String childName;
  final double latitude;
  final double longitude;
  final int batteryLevel;
  final DateTime timestamp;
  final bool isResolved;

  SosAlertModel({
    required this.alertId,
    required this.childId,
    required this.parentId,
    required this.childName,
    required this.latitude,
    required this.longitude,
    required this.batteryLevel,
    required this.timestamp,
    this.isResolved = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'alertId': alertId,
      'childId': childId,
      'parentId': parentId,
      'childName': childName,
      'latitude': latitude,
      'longitude': longitude,
      'batteryLevel': batteryLevel,
      'timestamp': timestamp.toIso8601String(),
      'isResolved': isResolved,
    };
  }

  factory SosAlertModel.fromMap(Map<String, dynamic> map, {String? docId}) {
    return SosAlertModel(
      alertId: docId ?? map['alertId'] ?? '',
      childId: map['childId'] ?? '',
      parentId: map['parentId'] ?? '',
      childName: map['childName'] ?? 'Child',
      latitude: (map['latitude'] as num?)?.toDouble() ?? 0.0,
      longitude: (map['longitude'] as num?)?.toDouble() ?? 0.0,
      batteryLevel: (map['batteryLevel'] as num?)?.toInt() ?? 100,
      timestamp: map['timestamp'] != null
          ? DateTime.tryParse(map['timestamp'].toString()) ?? DateTime.now()
          : DateTime.now(),
      isResolved: map['isResolved'] as bool? ?? false,
    );
  }
}
