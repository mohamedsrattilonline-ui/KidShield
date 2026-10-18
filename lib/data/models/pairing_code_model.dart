class PairingCodeModel {
  final String code;
  final String parentId;
  final String childTempName;
  final DateTime createdAt;
  final DateTime expiresAt;
  final bool isUsed;
  final String? linkedChildId;

  PairingCodeModel({
    required this.code,
    required this.parentId,
    required this.childTempName,
    required this.createdAt,
    required this.expiresAt,
    this.isUsed = false,
    this.linkedChildId,
  });

  bool get isExpired => DateTime.now().isAfter(expiresAt);

  Map<String, dynamic> toMap() {
    return {
      'code': code,
      'parentId': parentId,
      'childTempName': childTempName,
      'createdAt': createdAt.toIso8601String(),
      'expiresAt': expiresAt.toIso8601String(),
      'isUsed': isUsed,
      'linkedChildId': linkedChildId,
    };
  }

  factory PairingCodeModel.fromMap(Map<String, dynamic> map, {String? docId}) {
    return PairingCodeModel(
      code: docId ?? map['code'] ?? '',
      parentId: map['parentId'] ?? '',
      childTempName: map['childTempName'] ?? '',
      createdAt: map['createdAt'] != null
          ? DateTime.tryParse(map['createdAt'].toString()) ?? DateTime.now()
          : DateTime.now(),
      expiresAt: map['expiresAt'] != null
          ? DateTime.tryParse(map['expiresAt'].toString()) ??
              DateTime.now().add(const Duration(minutes: 15))
          : DateTime.now().add(const Duration(minutes: 15)),
      isUsed: map['isUsed'] as bool? ?? false,
      linkedChildId: map['linkedChildId'] as String?,
    );
  }
}
