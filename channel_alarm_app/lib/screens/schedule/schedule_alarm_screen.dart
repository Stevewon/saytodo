import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/channel_model.dart';
import '../../models/scheduled_alarm_model.dart';
import '../../providers/auth_provider.dart';
import '../../providers/schedule_provider.dart';

class ScheduleAlarmScreen extends StatefulWidget {
  final Channel channel;
  
  const ScheduleAlarmScreen({
    Key? key,
    required this.channel,
  }) : super(key: key);

  @override
  State<ScheduleAlarmScreen> createState() => _ScheduleAlarmScreenState();
}

class _ScheduleAlarmScreenState extends State<ScheduleAlarmScreen> {
  ScheduleType _selectedType = ScheduleType.voice;
  DateTime _selectedDate = DateTime.now();
  TimeOfDay _selectedTime = TimeOfDay.now();
  final _contentController = TextEditingController();
  
  @override
  void dispose() {
    _contentController.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context, listen: false);
    final scheduleProvider = Provider.of<ScheduleProvider>(context, listen: false);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('알람 예약'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 채널 정보
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.blue.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  const Icon(Icons.notifications_active, color: Colors.blue, size: 32),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.channel.name,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          '${widget.channel.memberIds.length}명에게 알람 전송',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 30),
            
            // 1단계: 콘텐츠 선택
            const Text(
              '1️⃣ 콘텐츠 선택',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            
            _buildTypeButton(ScheduleType.voice, '음성 메시지', Icons.mic, Colors.blue),
            const SizedBox(height: 12),
            _buildTypeButton(ScheduleType.video, '영상 메시지', Icons.videocam, Colors.red),
            const SizedBox(height: 12),
            _buildTypeButton(ScheduleType.youtube, '유튜브 링크', Icons.play_circle, Colors.green),
            
            const SizedBox(height: 30),
            
            // 2단계: 시간 선택
            const Text(
              '2️⃣ 알람 시간 선택',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            
            // 날짜 선택
            ListTile(
              leading: const Icon(Icons.calendar_today, color: Colors.blue),
              title: const Text('날짜'),
              subtitle: Text(_formatDate(_selectedDate)),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: _selectDate,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: BorderSide(color: Colors.grey[300]!),
              ),
            ),
            
            const SizedBox(height: 12),
            
            // 시간 선택
            ListTile(
              leading: const Icon(Icons.access_time, color: Colors.blue),
              title: const Text('시간'),
              subtitle: Text(_selectedTime.format(context)),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: _selectTime,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: BorderSide(color: Colors.grey[300]!),
              ),
            ),
            
            const SizedBox(height: 12),
            
            // 선택된 시간 표시
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.green.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  const Icon(Icons.alarm, color: Colors.green),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      _getScheduledTimeText(),
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 40),
            
            // 예약 버튼
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton.icon(
                onPressed: () async {
                  final scheduledDateTime = DateTime(
                    _selectedDate.year,
                    _selectedDate.month,
                    _selectedDate.day,
                    _selectedTime.hour,
                    _selectedTime.minute,
                  );
                  
                  // 과거 시간 체크
                  if (scheduledDateTime.isBefore(DateTime.now())) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('⚠️ 미래 시간을 선택해주세요!'),
                        backgroundColor: Colors.orange,
                      ),
                    );
                    return;
                  }
                  
                  // 예약 추가
                  await scheduleProvider.scheduleAlarm(
                    channelId: widget.channel.id,
                    channelName: widget.channel.name,
                    ownerId: auth.currentUser!.id,
                    ownerName: auth.currentUser!.displayName,
                    type: _selectedType,
                    scheduledTime: scheduledDateTime,
                    content: _contentController.text.isEmpty 
                        ? null 
                        : _contentController.text,
                  );
                  
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('✅ 알람이 예약되었습니다! ${_formatDate(scheduledDateTime)} ${_selectedTime.format(context)}'),
                        backgroundColor: Colors.green,
                        duration: const Duration(seconds: 3),
                      ),
                    );
                    Navigator.pop(context);
                  }
                },
                icon: const Icon(Icons.alarm_add, size: 28),
                label: const Text(
                  '예약 완료',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildTypeButton(ScheduleType type, String label, IconData icon, Color color) {
    final isSelected = _selectedType == type;
    
    return InkWell(
      onTap: () {
        setState(() {
          _selectedType = type;
        });
      },
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected ? color.withOpacity(0.2) : Colors.grey[100],
          border: Border.all(
            color: isSelected ? color : Colors.grey[300]!,
            width: isSelected ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(icon, color: isSelected ? color : Colors.grey[600], size: 32),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  color: isSelected ? color : Colors.black,
                ),
              ),
            ),
            if (isSelected)
              Icon(Icons.check_circle, color: color, size: 28),
          ],
        ),
      ),
    );
  }
  
  Future<void> _selectDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    
    if (picked != null) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }
  
  Future<void> _selectTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
    );
    
    if (picked != null) {
      setState(() {
        _selectedTime = picked;
      });
    }
  }
  
  String _formatDate(DateTime date) {
    return '${date.year}년 ${date.month}월 ${date.day}일';
  }
  
  String _getScheduledTimeText() {
    final scheduledDateTime = DateTime(
      _selectedDate.year,
      _selectedDate.month,
      _selectedDate.day,
      _selectedTime.hour,
      _selectedTime.minute,
    );
    
    final diff = scheduledDateTime.difference(DateTime.now());
    
    if (diff.inMinutes < 60) {
      return '${diff.inMinutes}분 후에 알람이 울립니다';
    } else if (diff.inHours < 24) {
      return '${diff.inHours}시간 ${diff.inMinutes % 60}분 후에 알람이 울립니다';
    } else {
      return '${diff.inDays}일 ${diff.inHours % 24}시간 후에 알람이 울립니다';
    }
  }
}
