enum MessageType {
  voice,
  video,
  youtube,
  text,
}

class Message {
  final String id;
  final String channelId;
  final String senderId;
  final String senderName;
  final MessageType type;
  final String content;
  final String? mediaUrl;
  final int? duration;
  final String? thumbnailUrl;
  final DateTime createdAt;
  final List<String> readBy;

  Message({
    required this.id,
    required this.channelId,
    required this.senderId,
    required this.senderName,
    required this.type,
    required this.content,
    this.mediaUrl,
    this.duration,
    this.thumbnailUrl,
    required this.createdAt,
    required this.readBy,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'channelId': channelId,
      'senderId': senderId,
      'senderName': senderName,
      'type': type.toString().split('.').last,
      'content': content,
      'mediaUrl': mediaUrl,
      'duration': duration,
      'thumbnailUrl': thumbnailUrl,
      'createdAt': createdAt.toIso8601String(),
      'readBy': readBy,
    };
  }

  factory Message.fromMap(Map<String, dynamic> map) {
    return Message(
      id: map['id'] ?? '',
      channelId: map['channelId'] ?? '',
      senderId: map['senderId'] ?? '',
      senderName: map['senderName'] ?? '',
      type: MessageType.values.firstWhere(
        (e) => e.toString().split('.').last == map['type'],
        orElse: () => MessageType.text,
      ),
      content: map['content'] ?? '',
      mediaUrl: map['mediaUrl'],
      duration: map['duration'],
      thumbnailUrl: map['thumbnailUrl'],
      createdAt: DateTime.parse(map['createdAt']),
      readBy: List<String>.from(map['readBy'] ?? []),
    );
  }

  String getNotificationTitle() {
    switch (type) {
      case MessageType.voice:
        return '🎤 $senderName님이 음성 메시지를 보냈습니다';
      case MessageType.video:
        return '🎥 $senderName님이 영상을 보냈습니다';
      case MessageType.youtube:
        return '▶️ $senderName님이 유튜브 링크를 공유했습니다';
      case MessageType.text:
        return '💬 $senderName님이 메시지를 보냈습니다';
    }
  }

  String getNotificationBody() {
    switch (type) {
      case MessageType.voice:
        return '음성 메시지 ${duration ?? 0}초';
      case MessageType.video:
        return '영상 ${duration ?? 0}초';
      case MessageType.youtube:
        return content;
      case MessageType.text:
        return content;
    }
  }
}
