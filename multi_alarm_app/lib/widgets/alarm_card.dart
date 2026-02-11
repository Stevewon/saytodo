import 'package:flutter/material.dart';
import 'package:multi_alarm_app/models/alarm_model.dart';

class AlarmCard extends StatelessWidget {
  final AlarmModel alarm;
  final VoidCallback onToggle;
  final VoidCallback onDelete;
  final VoidCallback onTap;
  final VoidCallback onDuplicate;

  const AlarmCard({
    super.key,
    required this.alarm,
    required this.onToggle,
    required this.onDelete,
    required this.onTap,
    required this.onDuplicate,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      color: alarm.isEnabled 
          ? Theme.of(context).cardColor
          : Theme.of(context).cardColor.withOpacity(0.5),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  // 시간 표시
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          alarm.formattedTimeAmPm,
                          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: alarm.isEnabled 
                                ? Theme.of(context).primaryColor
                                : Colors.grey,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          alarm.title,
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: alarm.isEnabled 
                                ? null
                                : Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // 토글 스위치
                  Switch(
                    value: alarm.isEnabled,
                    onChanged: (_) => onToggle(),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              // 반복 요일
              Row(
                children: [
                  Icon(
                    Icons.repeat,
                    size: 16,
                    color: Colors.grey[600],
                  ),
                  const SizedBox(width: 8),
                  Text(
                    alarm.repeatDaysText,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.grey[600],
                    ),
                  ),
                  const Spacer(),
                  if (alarm.isEnabled) ...[
                    Icon(
                      Icons.access_time,
                      size: 16,
                      color: Colors.grey[600],
                    ),
                    const SizedBox(width: 4),
                    Text(
                      alarm.remainingTimeText,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).primaryColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ],
              ),

              const SizedBox(height: 12),

              // 추가 정보
              Row(
                children: [
                  if (alarm.sound != 'default') ...[
                    _buildChip(
                      context,
                      Icons.music_note,
                      alarm.sound,
                    ),
                    const SizedBox(width: 8),
                  ],
                  if (alarm.vibrate) ...[
                    _buildChip(
                      context,
                      Icons.vibration,
                      '진동',
                    ),
                    const SizedBox(width: 8),
                  ],
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.content_copy),
                    iconSize: 20,
                    onPressed: onDuplicate,
                    tooltip: '복제',
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete_outline),
                    iconSize: 20,
                    color: Colors.red[300],
                    onPressed: onDelete,
                    tooltip: '삭제',
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildChip(BuildContext context, IconData icon, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 14,
            color: Theme.of(context).primaryColor,
          ),
          const SizedBox(width: 4),
          Text(
            label,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Theme.of(context).primaryColor,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
