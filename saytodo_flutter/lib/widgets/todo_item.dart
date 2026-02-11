import 'package:flutter/material.dart';
import 'package:saytodo_flutter/models/todo_model.dart';
import 'package:intl/intl.dart';

class TodoItem extends StatelessWidget {
  final TodoModel todo;
  final VoidCallback onTap;
  final VoidCallback onToggle;
  final VoidCallback onDelete;

  const TodoItem({
    super.key,
    required this.todo,
    required this.onTap,
    required this.onToggle,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // 체크박스
              GestureDetector(
                onTap: onToggle,
                child: Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: todo.isCompleted
                          ? Theme.of(context).primaryColor
                          : Colors.grey,
                      width: 2,
                    ),
                    color: todo.isCompleted
                        ? Theme.of(context).primaryColor
                        : Colors.transparent,
                  ),
                  child: todo.isCompleted
                      ? const Icon(
                          Icons.check,
                          size: 16,
                          color: Colors.white,
                        )
                      : null,
                ),
              ),

              const SizedBox(width: 16),

              // 내용
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 제목
                    Text(
                      todo.title,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        decoration: todo.isCompleted
                            ? TextDecoration.lineThrough
                            : null,
                        color: todo.isCompleted
                            ? Colors.grey
                            : null,
                      ),
                    ),

                    if (todo.description != null) ...[
                      const SizedBox(height: 4),
                      Text(
                        todo.description!,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.grey[600],
                          decoration: todo.isCompleted
                              ? TextDecoration.lineThrough
                              : null,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],

                    const SizedBox(height: 8),

                    // 메타 정보
                    Row(
                      children: [
                        // 카테고리
                        _buildChip(
                          context,
                          todo.category,
                          Theme.of(context).primaryColor,
                        ),

                        const SizedBox(width: 8),

                        // 우선순위
                        _buildChip(
                          context,
                          todo.priorityText,
                          _getPriorityColor(todo.priority),
                        ),

                        const SizedBox(width: 8),

                        // 날짜
                        Text(
                          DateFormat('MM/dd').format(todo.createdAt),
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Colors.grey[500],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // 삭제 버튼
              IconButton(
                icon: const Icon(Icons.delete_outline),
                color: Colors.red[300],
                onPressed: onDelete,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildChip(BuildContext context, String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        label,
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
          color: color,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Color _getPriorityColor(int priority) {
    switch (priority) {
      case 1:
        return Colors.red;
      case 2:
        return Colors.orange;
      case 3:
        return Colors.green;
      default:
        return Colors.grey;
    }
  }
}
