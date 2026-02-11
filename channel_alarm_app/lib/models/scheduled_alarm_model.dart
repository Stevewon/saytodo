import 'package:flutter/material.dart';

enum ScheduleType {
  voice,   // 음성
  video,   // 영상
  youtube, // 유튜브 링크
}

class ScheduledAlarm {
  final String id;
  final String channelId;
  final String channelName;
  final String ownerId;
  final String ownerName;
  final ScheduleType type;
  final DateTime scheduledTime;
  final String? content;        // 링크 또는 메시지
  final String? mediaUrl;       // 음성/영상 파일 URL
  final bool isCompleted;
  final DateTime createdAt;
  
  ScheduledAlarm({
    required this.id,
    required this.channelId,
    required this.channelName,
    required this.ownerId,
    required this.ownerName,
    required this.type,
    required this.scheduledTime,
    this.content,
    this.mediaUrl,
    this.isCompleted = false,
    required this.createdAt,
  });
  
  // 남은 시간 계산
  Duration get remainingTime {
    return scheduledTime.difference(DateTime.now());
  }
  
  // 예약 시간이 도래했는지 확인
  bool get isDue {
    return DateTime.now().isAfter(scheduledTime) && !isCompleted;
  }
  
  // 타입별 아이콘
  IconData get icon {
    switch (type) {
      case ScheduleType.voice:
        return Icons.mic;
      case ScheduleType.video:
        return Icons.videocam;
      case ScheduleType.youtube:
        return Icons.play_circle;
    }
  }
  
  // 타입별 레이블
  String get typeLabel {
    switch (type) {
      case ScheduleType.voice:
        return '음성 메시지';
      case ScheduleType.video:
        return '영상 메시지';
      case ScheduleType.youtube:
        return '유튜브 링크';
    }
  }
  
  // 타입별 색상
  Color get color {
    switch (type) {
      case ScheduleType.voice:
        return Colors.blue;
      case ScheduleType.video:
        return Colors.red;
      case ScheduleType.youtube:
        return Colors.green;
    }
  }
  
  // 복사본 생성 (상태 변경용)
  ScheduledAlarm copyWith({
    bool? isCompleted,
  }) {
    return ScheduledAlarm(
      id: id,
      channelId: channelId,
      channelName: channelName,
      ownerId: ownerId,
      ownerName: ownerName,
      type: type,
      scheduledTime: scheduledTime,
      content: content,
      mediaUrl: mediaUrl,
      isCompleted: isCompleted ?? this.isCompleted,
      createdAt: createdAt,
    );
  }
}
