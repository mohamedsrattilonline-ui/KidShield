class WebActivityModel {
  final String id;
  final String childId;
  final String domain;
  final String pageTitle;
  final String category;
  final bool isBlocked;
  final DateTime timestamp;

  WebActivityModel({
    required this.id,
    required this.childId,
    required this.domain,
    required this.pageTitle,
    required this.category,
    required this.isBlocked,
    required this.timestamp,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'childId': childId,
      'domain': domain,
      'pageTitle': pageTitle,
      'category': category,
      'isBlocked': isBlocked,
      'timestamp': timestamp.toIso8601String(),
    };
  }

  factory WebActivityModel.fromMap(Map<String, dynamic> map, {String? docId}) {
    return WebActivityModel(
      id: docId ?? map['id'] ?? '',
      childId: map['childId'] ?? '',
      domain: map['domain'] ?? '',
      pageTitle: map['pageTitle'] ?? 'Web Page',
      category: map['category'] ?? 'General',
      isBlocked: map['isBlocked'] as bool? ?? false,
      timestamp: map['timestamp'] != null
          ? DateTime.tryParse(map['timestamp'].toString()) ?? DateTime.now()
          : DateTime.now(),
    );
  }
}
