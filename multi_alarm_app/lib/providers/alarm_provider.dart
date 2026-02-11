import 'package:flutter/foundation.dart';
import 'package:multi_alarm_app/models/alarm_model.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class AlarmProvider with ChangeNotifier {
  List<AlarmModel> _alarms = [];
  bool _isLoading = false;

  List<AlarmModel> get alarms => _alarms;
  bool get isLoading => _isLoading;

  // 활성화된 알람
  List<AlarmModel> get enabledAlarms =>
      _alarms.where((alarm) => alarm.isEnabled).toList();

  // 비활성화된 알람
  List<AlarmModel> get disabledAlarms =>
      _alarms.where((alarm) => !alarm.isEnabled).toList();

  // 알람 개수
  int get alarmCount => _alarms.length;
  int get enabledAlarmCount => enabledAlarms.length;

  AlarmProvider() {
    _loadAlarms();
  }

  // 알람 로드
  Future<void> _loadAlarms() async {
    _isLoading = true;
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      final alarmsJson = prefs.getString('alarms');
      
      if (alarmsJson != null) {
        final List<dynamic> decoded = json.decode(alarmsJson);
        _alarms = decoded.map((json) => AlarmModel.fromJson(json)).toList();
      } else {
        // 임시 데모 데이터
        _alarms = [
          AlarmModel(
            title: '기상 알람',
            time: DateTime.now().add(const Duration(hours: 8)),
            repeatDays: [0, 1, 2, 3, 4], // 평일
          ),
          AlarmModel(
            title: '점심시간',
            time: DateTime.now().add(const Duration(hours: 12)),
            repeatDays: [0, 1, 2, 3, 4], // 평일
          ),
          AlarmModel(
            title: '운동 시간',
            time: DateTime.now().add(const Duration(hours: 18)),
            repeatDays: [0, 2, 4], // 월, 수, 금
          ),
        ];
      }

      _sortAlarms();
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      debugPrint('알람 로드 실패: $e');
      _isLoading = false;
      notifyListeners();
    }
  }

  // 알람 저장
  Future<void> _saveAlarms() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final alarmsJson = json.encode(_alarms.map((a) => a.toJson()).toList());
      await prefs.setString('alarms', alarmsJson);
    } catch (e) {
      debugPrint('알람 저장 실패: $e');
    }
  }

  // 알람 정렬 (시간순)
  void _sortAlarms() {
    _alarms.sort((a, b) => a.time.compareTo(b.time));
  }

  // 알람 추가
  Future<void> addAlarm(AlarmModel alarm) async {
    _alarms.add(alarm);
    _sortAlarms();
    await _saveAlarms();
    notifyListeners();
  }

  // 알람 수정
  Future<void> updateAlarm(String id, AlarmModel updatedAlarm) async {
    final index = _alarms.indexWhere((alarm) => alarm.id == id);
    if (index != -1) {
      _alarms[index] = updatedAlarm;
      _sortAlarms();
      await _saveAlarms();
      notifyListeners();
    }
  }

  // 알람 삭제
  Future<void> deleteAlarm(String id) async {
    _alarms.removeWhere((alarm) => alarm.id == id);
    await _saveAlarms();
    notifyListeners();
  }

  // 알람 토글 (활성화/비활성화)
  Future<void> toggleAlarm(String id) async {
    final index = _alarms.indexWhere((alarm) => alarm.id == id);
    if (index != -1) {
      _alarms[index] = _alarms[index].copyWith(
        isEnabled: !_alarms[index].isEnabled,
      );
      await _saveAlarms();
      notifyListeners();
    }
  }

  // 모든 알람 삭제
  Future<void> deleteAllAlarms() async {
    _alarms.clear();
    await _saveAlarms();
    notifyListeners();
  }

  // 알람 복제
  Future<void> duplicateAlarm(String id) async {
    final alarm = _alarms.firstWhere((a) => a.id == id);
    final newAlarm = AlarmModel(
      title: '${alarm.title} (복사)',
      time: alarm.time,
      repeatDays: alarm.repeatDays,
      sound: alarm.sound,
      vibrate: alarm.vibrate,
    );
    await addAlarm(newAlarm);
  }
}
