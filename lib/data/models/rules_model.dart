class RulesModel {
  final String childId;
  final int dailyLimitMinutes;
  final int usedMinutesToday;
  final String bedtimeStart; // e.g. "21:00"
  final String bedtimeEnd;   // e.g. "07:00"
  final bool isBedtimeEnabled;
  final bool isRemoteLocked;
  final List<String> blockedPackages;
  
  // Optional Web Safety & Filtering toggles
  final bool isWebFilteringEnabled;
  final bool blockAdultContent;
  final bool logWebHistory;
  
  final DateTime updatedAt;

  RulesModel({
    required this.childId,
    this.dailyLimitMinutes = 120,
    this.usedMinutesToday = 0,
    this.bedtimeStart = '21:00',
    this.bedtimeEnd = '07:00',
    this.isBedtimeEnabled = false,
    this.isRemoteLocked = false,
    this.blockedPackages = const [],
    this.isWebFilteringEnabled = false,
    this.blockAdultContent = false,
    this.logWebHistory = true,
    DateTime? updatedAt,
  }) : updatedAt = updatedAt ?? DateTime.now();


  bool get isLimitExceeded => usedMinutesToday >= dailyLimitMinutes;

  /// Checks if current local time falls into bedtime hours
  bool isCurrentTimeInBedtime() {
    if (!isBedtimeEnabled) return false;
    final now = DateTime.now();
    final startParts = bedtimeStart.split(':');
    final endParts = bedtimeEnd.split(':');
    if (startParts.length < 2 || endParts.length < 2) return false;

    final startHour = int.tryParse(startParts[0]) ?? 21;
    final startMinute = int.tryParse(startParts[1]) ?? 0;
    final endHour = int.tryParse(endParts[0]) ?? 7;
    final endMinute = int.tryParse(endParts[1]) ?? 0;

    final currentTotal = now.hour * 60 + now.minute;
    final startTotal = startHour * 60 + startMinute;
    final endTotal = endHour * 60 + endMinute;

    if (startTotal <= endTotal) {
      return currentTotal >= startTotal && currentTotal < endTotal;
    } else {
      // Overnight (e.g. 21:00 to 07:00)
      return currentTotal >= startTotal || currentTotal < endTotal;
    }
  }

  bool get shouldLockDevice => isRemoteLocked || isLimitExceeded || isCurrentTimeInBedtime();

  Map<String, dynamic> toMap() {
    return {
      'childId': childId,
      'dailyLimitMinutes': dailyLimitMinutes,
      'usedMinutesToday': usedMinutesToday,
      'bedtimeStart': bedtimeStart,
      'bedtimeEnd': bedtimeEnd,
      'isBedtimeEnabled': isBedtimeEnabled,
      'isRemoteLocked': isRemoteLocked,
      'blockedPackages': blockedPackages,
      'isWebFilteringEnabled': isWebFilteringEnabled,
      'blockAdultContent': blockAdultContent,
      'logWebHistory': logWebHistory,
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  factory RulesModel.fromMap(Map<String, dynamic> map, {String? docId}) {
    return RulesModel(
      childId: docId ?? map['childId'] ?? '',
      dailyLimitMinutes: (map['dailyLimitMinutes'] as num?)?.toInt() ?? 120,
      usedMinutesToday: (map['usedMinutesToday'] as num?)?.toInt() ?? 0,
      bedtimeStart: map['bedtimeStart'] ?? '21:00',
      bedtimeEnd: map['bedtimeEnd'] ?? '07:00',
      isBedtimeEnabled: map['isBedtimeEnabled'] as bool? ?? true,
      isRemoteLocked: map['isRemoteLocked'] as bool? ?? false,
      blockedPackages: (map['blockedPackages'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      isWebFilteringEnabled: map['isWebFilteringEnabled'] as bool? ?? false,
      blockAdultContent: map['blockAdultContent'] as bool? ?? false,
      logWebHistory: map['logWebHistory'] as bool? ?? true,
      updatedAt: map['updatedAt'] != null
          ? DateTime.tryParse(map['updatedAt'].toString()) ?? DateTime.now()
          : DateTime.now(),
    );
  }

  RulesModel copyWith({
    String? childId,
    int? dailyLimitMinutes,
    int? usedMinutesToday,
    String? bedtimeStart,
    String? bedtimeEnd,
    bool? isBedtimeEnabled,
    bool? isRemoteLocked,
    List<String>? blockedPackages,
    bool? isWebFilteringEnabled,
    bool? blockAdultContent,
    bool? logWebHistory,
    DateTime? updatedAt,
  }) {
    return RulesModel(
      childId: childId ?? this.childId,
      dailyLimitMinutes: dailyLimitMinutes ?? this.dailyLimitMinutes,
      usedMinutesToday: usedMinutesToday ?? this.usedMinutesToday,
      bedtimeStart: bedtimeStart ?? this.bedtimeStart,
      bedtimeEnd: bedtimeEnd ?? this.bedtimeEnd,
      isBedtimeEnabled: isBedtimeEnabled ?? this.isBedtimeEnabled,
      isRemoteLocked: isRemoteLocked ?? this.isRemoteLocked,
      blockedPackages: blockedPackages ?? this.blockedPackages,
      isWebFilteringEnabled: isWebFilteringEnabled ?? this.isWebFilteringEnabled,
      blockAdultContent: blockAdultContent ?? this.blockAdultContent,
      logWebHistory: logWebHistory ?? this.logWebHistory,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
