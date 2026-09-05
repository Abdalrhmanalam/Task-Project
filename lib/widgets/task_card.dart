import 'package:flutter/material.dart';
import 'package:intl/intl.dart' as intl;
import 'package:task_management_system/models/models.dart';
import 'package:task_management_system/theme/app_theme.dart';

class TaskCard extends StatelessWidget {
  final Task task;
  final VoidCallback? onTap;

  const TaskCard({
    Key? key,
    required this.task,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        margin: const EdgeInsets.only(bottom: AppTheme.spacing12),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppTheme.borderRadius12),
            gradient: LinearGradient(
              colors: [
                Colors.white,
                Colors.grey[50]!,
              ],
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(AppTheme.spacing12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        task.title,
                        style: Theme.of(context).textTheme.titleMedium,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppTheme.spacing8,
                        vertical: AppTheme.spacing4,
                      ),
                      decoration: BoxDecoration(
                        color: _getPriorityColor(task.priority),
                        borderRadius:
                            BorderRadius.circular(AppTheme.borderRadius8),
                      ),
                      child: Text(
                        _getPriorityLabel(task.priority),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppTheme.spacing8),
                Text(
                  task.description,
                  style: Theme.of(context).textTheme.bodySmall,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: AppTheme.spacing12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      intl.DateFormat('dd/MM').format(task.dueDate),
                      style: Theme.of(context).textTheme.labelSmall,
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppTheme.spacing8,
                        vertical: AppTheme.spacing4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.blue.withOpacity(0.1),
                        borderRadius:
                            BorderRadius.circular(AppTheme.borderRadius8),
                      ),
                      child: Text(
                        '${task.estimatedHours.toInt()}س',
                        style: const TextStyle(fontSize: 12),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Color _getPriorityColor(Priority priority) {
    switch (priority) {
      case Priority.high:
        return AppTheme.highPriorityColor;
      case Priority.medium:
        return AppTheme.mediumPriorityColor;
      case Priority.low:
        return AppTheme.lowPriorityColor;
    }
  }

  String _getPriorityLabel(Priority priority) {
    switch (priority) {
      case Priority.high:
        return 'عالية';
      case Priority.medium:
        return 'متوسطة';
      case Priority.low:
        return 'منخفضة';
    }
  }
}
