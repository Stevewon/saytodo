import 'package:uuid/uuid.dart';

class AlarmModel {
  final String id;
  final String title;
  final DateTime time;
  final bool isEnabled;
  final List<int> repeatDays; // 0=월, 1=화, ..., 6=일
  final String sound;
  final bool vibrate;

  AlarmModel({
    String? id,
    required this.title,
    required this.time,
    this.isEnabled = true,
    this.repeatDays = const [],
    this.sound = 'default',
    this.vibrate = true,
  }) : id = id ?? const Uuid().v4();

  // 복사 메서드
  AlarmModel copyWith({
    String? id,
    String? title,
    DateTime? time,
    bool? isEnabled,
    List<int>? repeatDays,
    String? sound,
    bool? vibrate,
  }) {
    return AlarmModel(
      id: id ?? this.id,
      title: title ?? this.title,
      time: time ?? this.time,
      isEnabled: isEnabled ?? this.isEnabled,
      repeatDays: repeatDays ?? this.repeatDays,
      sound: sound ?? this.sound,
      vibrate: vibrate ?? this.vibrate,
    );
  }

  // JSON 변환
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'time': time.toIso8601String(),
      'isEnabled': isEnabled,
      'repeatDays': repeatDays,
      'sound': sound,
      'vibrate': vibrate,
    };
  }

  factory AlarmModel.fromJson(Map<String, dynamic> json) {
    return AlarmModel(
      id: json['id'],
      title: json['title'],
      time: DateTime.parse(json['time']),
      isEnabled: json['isEnabled'],
      repeatDays: List<int>.from(json['repeatDays'] ?? []),
      sound: json['sound'] ?? 'default',
      vibrate: json['vibrate'] ?? true,
    );
  }

  // 시간 포맷팅
  String get formattedTime {
    final hour = time.hour.toString().padLeft(2, '0');
    final minute = time.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  // AM/PM 포맷
  String get formattedTimeAmPm {
    final hour = time.hour > 12 ? time.hour - 12 : time.hour;
    final hourStr = hour.toString().padLeft(2, '0');
    final minute = time.minute.toString().padLeft(2, '0');
    final period = time.hour >= 12 ? 'PM' : 'AM';
    return '$hourStr:$minute $period';
  }

  // 반복 요일 텍스트
  String get repeatDaysText {
    if (repeatDays.isEmpty) return '한 번만';
    if (repeatDays.length == 7) return '매일';
    if (repeatDays.length == 5 && 
        !repeatDays.contains(5) && 
        !repeatDays.contains(6)) return '평일';
    if (repeatDays.length == 2 && 
        repeatDays.contains(5) && 
        repeatDays.contains(6)) return '주말';
    
    const dayNames = ['월', '화', '수', '목', '금', '토', '일'];
    return repeatDays.map((day) => dayNames[day]).join(', ');
  }

  // 다음 알람 시간 계산
  DateTime get nextAlarmTime {
    final now = DateTime.now();
    var next = DateTime(now.year, now.month, now.day, time.hour, time.minute);
    
    if (repeatDays.isEmpty) {
      // 한 번만 울리는 알람
      if (next.isBefore(now)) {
        next = next.add(const Duration(days: 1));
      }
    } else {
      // 반복 알람
      while (!repeatDays.contains(next.weekday - 1) || next.isBefore(now)) {
        next = next.add(const Duration(days: 1));
      }
    }
    
    return next;
  }

  // 남은 시간 텍스트
  String get remainingTimeText {
    final next = nextAlarmTime;
    final diff = next.difference(DateTime.now());
    
    final hours = diff.inHours;
    final minutes = diff.inMinutes % 60;
    
    if (hours > 24) {
      return '${diff.inDays}일 ${hours % 24}시간 후';
    } else if (hours > 0) {
      return '$hours시간 $minutes분 후';
    } else {
      return '$minutes분 후';
    }
  }
}
