class ChildDeviceModel {
  final String childId;
  final String parentId;
  final String childName;
  final String deviceName;
  final String platform;
  final double latitude;
  final double longitude;
  final double accuracy;
  final int batteryLevel;
  final bool isCharging;
  final bool isOnline;
  final bool isBedtimeLocked;
  final DateTime lastPingAt;

  ChildDeviceModel({
    required this.childId,
    required this.parentId,
    required this.childName,
    required this.deviceName,
    required this.platform,
    required this.latitude,
    required this.longitude,
    required this.accuracy,
    required this.batteryLevel,
    required this.isCharging,
    required this.isOnline,
    required this.isBedtimeLocked,
    required this.lastPingAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'childId': childId,
      'parentId': parentId,
      'childName': childName,
      'deviceName': deviceName,
      'platform': platform,
      'latitude': latitude,
      'longitude': longitude,
      'accuracy': accuracy,
      'batteryLevel': batteryLevel,
      'isCharging': isCharging,
      'isOnline': isOnline,
      'isBedtimeLocked': isBedtimeLocked,
      'lastPingAt': lastPingAt.toIso8601String(),
    };
  }

  factory ChildDeviceModel.fromMap(Map<String, dynamic> map, {String? docId}) {
    return ChildDeviceModel(
      childId: docId ?? map['childId'] ?? '',
      parentId: map['parentId'] ?? '',
      childName: map['childName'] ?? 'Child Device',
      deviceName: map['deviceName'] ?? 'Unknown Device',
      platform: map['platform'] ?? 'unknown',
      latitude: (map['latitude'] as num?)?.toDouble() ?? 0.0,
      longitude: (map['longitude'] as num?)?.toDouble() ?? 0.0,
      accuracy: (map['accuracy'] as num?)?.toDouble() ?? 0.0,
      batteryLevel: (map['batteryLevel'] as num?)?.toInt() ?? 100,
      isCharging: map['isCharging'] as bool? ?? false,
      isOnline: map['isOnline'] as bool? ?? true,
      isBedtimeLocked: map['isBedtimeLocked'] as bool? ?? false,
      lastPingAt: map['lastPingAt'] != null
          ? DateTime.tryParse(map['lastPingAt'].toString()) ?? DateTime.now()
          : DateTime.now(),
    );
  }

  ChildDeviceModel copyWith({
    String? childId,
    String? parentId,
    String? childName,
    String? deviceName,
    String? platform,
    double? latitude,
    double? longitude,
    double? accuracy,
    int? batteryLevel,
    bool? isCharging,
    bool? isOnline,
    bool? isBedtimeLocked,
    DateTime? lastPingAt,
  }) {
    return ChildDeviceModel(
      childId: childId ?? this.childId,
      parentId: parentId ?? this.parentId,
      childName: childName ?? this.childName,
      deviceName: deviceName ?? this.deviceName,
      platform: platform ?? this.platform,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      accuracy: accuracy ?? this.accuracy,
      batteryLevel: batteryLevel ?? this.batteryLevel,
      isCharging: isCharging ?? this.isCharging,
      isOnline: isOnline ?? this.isOnline,
      isBedtimeLocked: isBedtimeLocked ?? this.isBedtimeLocked,
      lastPingAt: lastPingAt ?? this.lastPingAt,
    );
  }
}
