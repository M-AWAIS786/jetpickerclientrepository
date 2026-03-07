class ChatUserModel {
  final String id;
  final String? fullName;
  final String? avatarUrl;

  ChatUserModel({required this.id, this.fullName, this.avatarUrl});

  factory ChatUserModel.fromJson(Map<String, dynamic> json) {
    return ChatUserModel(
      id: json['id']?.toString() ?? '',
      fullName: json['full_name']?.toString(),
      avatarUrl: json['avatar_url']?.toString(),
    );
  }

  String get initials {
    if (fullName == null || fullName!.isEmpty) return '?';
    final parts = fullName!.trim().split(' ');
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return fullName![0].toUpperCase();
  }
}

class ChatRoomModel {
  final String id;
  final String orderId;
  final ChatUserModel? orderer;
  final ChatUserModel? picker;
  final ChatUserModel? otherUser;
  final int unreadCount;
  final String? createdAt;
  final String? updatedAt;

  ChatRoomModel({
    required this.id,
    required this.orderId,
    this.orderer,
    this.picker,
    this.otherUser,
    this.unreadCount = 0,
    this.createdAt,
    this.updatedAt,
  });

  factory ChatRoomModel.fromJson(Map<String, dynamic> json) {
    return ChatRoomModel(
      id: json['id']?.toString() ?? '',
      orderId: json['order_id']?.toString() ?? '',
      orderer: json['orderer'] is Map<String, dynamic>
          ? ChatUserModel.fromJson(json['orderer'])
          : null,
      picker: json['picker'] is Map<String, dynamic>
          ? ChatUserModel.fromJson(json['picker'])
          : null,
      otherUser: json['other_user'] is Map<String, dynamic>
          ? ChatUserModel.fromJson(json['other_user'])
          : null,
      unreadCount: _toInt(json['unread_count']),
      createdAt: json['created_at']?.toString(),
      updatedAt: json['updated_at']?.toString(),
    );
  }
}

class ChatListItemModel {
  final String id;
  final String orderId;
  final ChatUserModel? otherUser;
  final String? lastMessage;
  final String? lastMessageTime;
  final int unreadCount;

  ChatListItemModel({
    required this.id,
    required this.orderId,
    this.otherUser,
    this.lastMessage,
    this.lastMessageTime,
    this.unreadCount = 0,
  });

  factory ChatListItemModel.fromJson(Map<String, dynamic> json) {
    return ChatListItemModel(
      id: json['id']?.toString() ?? '',
      orderId: json['order_id']?.toString() ?? '',
      otherUser: json['other_user'] is Map<String, dynamic>
          ? ChatUserModel.fromJson(json['other_user'])
          : null,
      lastMessage: json['last_message']?.toString(),
      lastMessageTime: json['last_message_time']?.toString(),
      unreadCount: _toInt(json['unread_count']),
    );
  }
}

class ChatMessageModel {
  final String id;
  final String chatRoomId;
  final String senderId;
  final String contentOriginal;
  final String? contentTranslated;
  final bool translationEnabled;
  final bool isRead;
  final String? createdAt;
  final ChatUserModel? sender;

  ChatMessageModel({
    required this.id,
    required this.chatRoomId,
    required this.senderId,
    required this.contentOriginal,
    this.contentTranslated,
    this.translationEnabled = false,
    this.isRead = false,
    this.createdAt,
    this.sender,
  });

  factory ChatMessageModel.fromJson(Map<String, dynamic> json) {
    return ChatMessageModel(
      id: json['id']?.toString() ?? '',
      chatRoomId: json['chat_room_id']?.toString() ?? '',
      senderId: json['sender_id']?.toString() ?? '',
      contentOriginal: json['content_original']?.toString() ?? '',
      contentTranslated: json['content_translated']?.toString(),
      translationEnabled: _toBool(json['translation_enabled']),
      isRead: _toBool(json['is_read']),
      createdAt: json['created_at']?.toString(),
      sender: json['sender'] is Map<String, dynamic>
          ? ChatUserModel.fromJson(json['sender'])
          : null,
    );
  }
}

/// Safe int conversion — handles String, int, double, null
int _toInt(dynamic value) {
  if (value == null) return 0;
  if (value is int) return value;
  if (value is double) return value.toInt();
  if (value is String) return int.tryParse(value) ?? 0;
  return 0;
}

/// Safe bool conversion — handles bool, int (0/1), String ("true"/"false"/"0"/"1")
bool _toBool(dynamic value) {
  if (value == null) return false;
  if (value is bool) return value;
  if (value is int) return value != 0;
  if (value is String) return value == 'true' || value == '1';
  return false;
}
