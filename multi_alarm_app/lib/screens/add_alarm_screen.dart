import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:multi_alarm_app/models/alarm_model.dart';
import 'package:multi_alarm_app/providers/alarm_provider.dart';

class AddAlarmScreen extends StatefulWidget {
  const AddAlarmScreen({super.key});

  @override
  State<AddAlarmScreen> createState() => _AddAlarmScreenState();
}

class _AddAlarmScreenState extends State<AddAlarmScreen> {
  TimeOfDay _selectedTime = TimeOfDay.now();
  final TextEditingController _titleController = TextEditingController(text: '알람');
  List<int> _selectedDays = [];
  bool _vibrate = true;

  final List<String> _dayNames = ['월', '화', '수', '목', '금', '토', '일'];

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  Future<void> _selectTime() async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
    );
    if (picked != null) {
      setState(() {
        _selectedTime = picked;
      });
    }
  }

  void _toggleDay(int day) {
    setState(() {
      if (_selectedDays.contains(day)) {
        _selectedDays.remove(day);
      } else {
        _selectedDays.add(day);
      }
    });
  }

  void _saveAlarm() {
    final now = DateTime.now();
    final alarmTime = DateTime(
      now.year,
      now.month,
      now.day,
      _selectedTime.hour,
      _selectedTime.minute,
    );

    final alarm = AlarmModel(
      title: _titleController.text,
      time: alarmTime,
      repeatDays: _selectedDays,
      vibrate: _vibrate,
    );

    Provider.of<AlarmProvider>(context, listen: false).addAlarm(alarm);
    Navigator.of(context).pop();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('알람이 추가되었습니다')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('알람 추가'),
        actions: [
          TextButton(
            onPressed: _saveAlarm,
            child: const Text(
              '저장',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // 시간 선택
          Card(
            child: InkWell(
              onTap: _selectTime,
              borderRadius: BorderRadius.circular(16),
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Row(
                  children: [
                    Icon(
                      Icons.access_time,
                      size: 32,
                      color: Theme.of(context).primaryColor,
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '시간',
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: Colors.grey[600],
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            _selectedTime.format(context),
                            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).primaryColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Icon(Icons.chevron_right),
                  ],
                ),
              ),
            ),
          ),

          const SizedBox(height: 16),

          // 제목 입력
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: TextField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: '알람 이름',
                  prefixIcon: Icon(Icons.label),
                  border: OutlineInputBorder(),
                ),
              ),
            ),
          ),

          const SizedBox(height: 16),

          // 반복 요일 선택
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.repeat),
                      const SizedBox(width: 8),
                      Text(
                        '반복',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Wrap(
                    spacing: 8,
                    children: List.generate(7, (index) {
                      final isSelected = _selectedDays.contains(index);
                      return FilterChip(
                        label: Text(_dayNames[index]),
                        selected: isSelected,
                        onSelected: (_) => _toggleDay(index),
                      );
                    }),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      OutlinedButton(
                        onPressed: () {
                          setState(() {
                            _selectedDays = [0, 1, 2, 3, 4]; // 평일
                          });
                        },
                        child: const Text('평일'),
                      ),
                      const SizedBox(width: 8),
                      OutlinedButton(
                        onPressed: () {
                          setState(() {
                            _selectedDays = [5, 6]; // 주말
                          });
                        },
                        child: const Text('주말'),
                      ),
                      const SizedBox(width: 8),
                      OutlinedButton(
                        onPressed: () {
                          setState(() {
                            _selectedDays = List.generate(7, (i) => i); // 매일
                          });
                        },
                        child: const Text('매일'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          // 진동 설정
          Card(
            child: SwitchListTile(
              title: const Text('진동'),
              subtitle: const Text('알람 시 진동'),
              secondary: const Icon(Icons.vibration),
              value: _vibrate,
              onChanged: (value) {
                setState(() {
                  _vibrate = value;
                });
              },
            ),
          ),
        ],
      ),
    );
  }
}
