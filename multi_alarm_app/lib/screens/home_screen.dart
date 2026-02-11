import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:multi_alarm_app/providers/alarm_provider.dart';
import 'package:multi_alarm_app/widgets/alarm_card.dart';
import 'package:multi_alarm_app/screens/add_alarm_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          '멀티 알람',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          Consumer<AlarmProvider>(
            builder: (context, provider, child) {
              return Padding(
                padding: const EdgeInsets.only(right: 16),
                child: Center(
                  child: Text(
                    '${provider.enabledAlarmCount}개 활성',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).primaryColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: Consumer<AlarmProvider>(
        builder: (context, alarmProvider, child) {
          if (alarmProvider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (alarmProvider.alarms.isEmpty) {
            return _buildEmptyState(context);
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: alarmProvider.alarms.length,
            itemBuilder: (context, index) {
              final alarm = alarmProvider.alarms[index];
              return AlarmCard(
                alarm: alarm,
                onToggle: () => alarmProvider.toggleAlarm(alarm.id),
                onDelete: () => _showDeleteDialog(context, alarmProvider, alarm.id),
                onTap: () {
                  // TODO: 알람 편집 화면으로 이동
                },
                onDuplicate: () => alarmProvider.duplicateAlarm(alarm.id),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => const AddAlarmScreen(),
            ),
          );
        },
        icon: const Icon(Icons.add),
        label: const Text('알람 추가'),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.alarm_off,
            size: 100,
            color: Colors.grey[300],
          ),
          const SizedBox(height: 24),
          Text(
            '알람이 없습니다',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '새 알람을 추가해보세요',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Colors.grey[500],
            ),
          ),
          const SizedBox(height: 32),
          ElevatedButton.icon(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => const AddAlarmScreen(),
                ),
              );
            },
            icon: const Icon(Icons.add),
            label: const Text('알람 추가'),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(
                horizontal: 24,
                vertical: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showDeleteDialog(BuildContext context, AlarmProvider provider, String id) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('알람 삭제'),
        content: const Text('이 알람을 삭제하시겠습니까?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('취소'),
          ),
          TextButton(
            onPressed: () {
              provider.deleteAlarm(id);
              Navigator.of(context).pop();
            },
            style: TextButton.styleFrom(
              foregroundColor: Colors.red,
            ),
            child: const Text('삭제'),
          ),
        ],
      ),
    );
  }
}
