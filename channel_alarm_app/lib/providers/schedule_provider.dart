import 'package:flutter/material.dart';
import '../models/scheduled_alarm_model.dart';
import 'package:uuid/uuid.dart';
import 'dart:async';

class ScheduleProvider with ChangeNotifier {
  final Map<String, List<ScheduledAlarm>> _channelSchedules = {};
  Timer? _checkTimer;
  
  // 알람 트리거 콜백
  Function(ScheduledAlarm)? onAlarmTriggered;
  
  ScheduleProvider() {
    // 1초마다 예약된 알람 체크
    _checkTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      _checkScheduledAlarms();
    });
  }
  
  @override
  void dispose() {
    _checkTimer?.cancel();
    super.dispose();
  }
  
  // 채널의 예약 목록 가져오기
  List<ScheduledAlarm> getChannelSchedules(String channelId) {
    final schedules = _channelSchedules[channelId] ?? [];
    // 완료되지 않은 것만, 시간 순으로 정렬
    return schedules
        .where((s) => !s.isCompleted)
        .toList()
      ..sort((a, b) => a.scheduledTime.compareTo(b.scheduledTime));
  }
  
  // 모든 예약 목록
  List<ScheduledAlarm> getAllSchedules() {
    final allSchedules = <ScheduledAlarm>[];
    for (var schedules in _channelSchedules.values) {
      allSchedules.addAll(schedules.where((s) => !s.isCompleted));
    }
    allSchedules.sort((a, b) => a.scheduledTime.compareTo(b.scheduledTime));
    return allSchedules;
  }
  
  // 예약 추가
  Future<ScheduledAlarm> scheduleAlarm({
    required String channelId,
    required String channelName,
    required String ownerId,
    required String ownerName,
    required ScheduleType type,
    required DateTime scheduledTime,
    String? content,
    String? mediaUrl,
  }) async {
    final alarm = ScheduledAlarm(
      id: const Uuid().v4(),
      channelId: channelId,
      channelName: channelName,
      ownerId: ownerId,
      ownerName: ownerName,
      type: type,
      scheduledTime: scheduledTime,
      content: content,
      mediaUrl: mediaUrl,
      createdAt: DateTime.now(),
    );
    
    if (_channelSchedules[channelId] == null) {
      _channelSchedules[channelId] = [];
    }
    _channelSchedules[channelId]!.add(alarm);
    
    notifyListeners();
    return alarm;
  }
  
  // 예약 취소
  void cancelSchedule(String channelId, String scheduleId) {
    final schedules = _channelSchedules[channelId];
    if (schedules != null) {
      schedules.removeWhere((s) => s.id == scheduleId);
      notifyListeners();
    }
  }
  
  // 예약된 알람 체크 (1초마다 실행)
  void _checkScheduledAlarms() {
    bool hasChanges = false;
    
    for (var channelId in _channelSchedules.keys) {
      final schedules = _channelSchedules[channelId]!;
      
      for (var i = 0; i < schedules.length; i++) {
        final alarm = schedules[i];
        
        // 시간이 도래하고 아직 완료되지 않았으면
        if (alarm.isDue) {
          debugPrint('🔔 알람 트리거! ${alarm.channelName} - ${alarm.typeLabel}');
          
          // 알람 트리거!
          if (onAlarmTriggered != null) {
            onAlarmTriggered!(alarm);
          }
          
          // 완료 처리
          schedules[i] = alarm.copyWith(isCompleted: true);
          hasChanges = true;
        }
      }
    }
    
    if (hasChanges) {
      notifyListeners();
    }
  }
  
  // 테스트용: 즉시 알람 (10초 후)
  Future<ScheduledAlarm> scheduleTestAlarm({
    required String channelId,
    required String channelName,
    required String ownerId,
    required String ownerName,
  }) async {
    return scheduleAlarm(
      channelId: channelId,
      channelName: channelName,
      ownerId: ownerId,
      ownerName: ownerName,
      type: ScheduleType.voice,
      scheduledTime: DateTime.now().add(const Duration(seconds: 10)),
      content: '테스트 알람입니다! 10초 후 울립니다!',
    );
  }
}
