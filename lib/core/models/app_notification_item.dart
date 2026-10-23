/// Types of notifications supported by ShelfChef
enum AppNotificationType {
  expiringSoon,
  lowStock,
  itemAdded,
  general,
}

/// Representation of an in-app and system notification.
class AppNotificationItem {
  final String id;
  final String title;
  final String message;
  final AppNotificationType type;
  final DateTime timestamp;
  final bool isRead;
  final String? itemId;

  const AppNotificationItem({
    required this.id,
    required this.title,
    required this.message,
    required this.type,
    required this.timestamp,
    this.isRead = false,
    this.itemId,
  });

  AppNotificationItem copyWith({
    String? id,
    String? title,
    String? message,
    AppNotificationType? type,
    DateTime? timestamp,
    bool? isRead,
    String? itemId,
  }) {
    return AppNotificationItem(
      id: id ?? this.id,
      title: title ?? this.title,
      message: message ?? this.message,
      type: type ?? this.type,
      timestamp: timestamp ?? this.timestamp,
      isRead: isRead ?? this.isRead,
      itemId: itemId ?? this.itemId,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'message': message,
      'type': type.name,
      'timestamp': timestamp.toIso8601String(),
      'isRead': isRead,
      'itemId': itemId,
    };
  }

  factory AppNotificationItem.fromJson(Map<String, dynamic> json) {
    AppNotificationType parsedType = AppNotificationType.general;
    final typeStr = json['type']?.toString();
    for (final t in AppNotificationType.values) {
      if (t.name == typeStr) {
        parsedType = t;
        break;
      }
    }

    return AppNotificationItem(
      id: json['id']?.toString() ?? '',
      title: json['title']?.toString() ?? '',
      message: json['message']?.toString() ?? '',
      type: parsedType,
      timestamp: DateTime.tryParse(json['timestamp']?.toString() ?? '') ??
          DateTime.now(),
      isRead: json['isRead'] == true,
      itemId: json['itemId']?.toString(),
    );
  }

  String get timeAgo {
    final diff = DateTime.now().difference(timestamp);
    if (diff.inSeconds < 60) return 'Just now';
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    if (diff.inDays < 7) return '${diff.inDays}d ago';
    return '${timestamp.day}/${timestamp.month}';
  }
}
