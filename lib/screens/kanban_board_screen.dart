import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_management_system/models/models.dart';
import 'package:task_management_system/providers/project_provider.dart';
import 'package:task_management_system/theme/app_theme.dart';
import 'package:task_management_system/screens/task_form_screen.dart';
import 'package:task_management_system/widgets/task_card.dart';

class KanbanBoardScreen extends StatefulWidget {
  const KanbanBoardScreen({Key? key}) : super(key: key);

  @override
  State<KanbanBoardScreen> createState() => _KanbanBoardScreenState();
}

class _KanbanBoardScreenState extends State<KanbanBoardScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Consumer<ProjectProvider>(
          builder: (context, provider, _) =>
              Text(provider.currentProject?.name ?? 'المشروع'),
        ),
        elevation: 0,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => const TaskFormScreen(),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
      body: Consumer<ProjectProvider>(
        builder: (context, provider, _) {
          final project = provider.currentProject;
          if (project == null) {
            return const Center(child: Text('لا يوجد مشروع محدد'));
          }

          return Container(
            decoration: BoxDecoration(gradient: AppTheme.backgroundGradient),
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.all(AppTheme.spacing16),
              children: [
                _buildColumn(
                  context,
                  'جديد',
                  TaskStatus.neu,
                  project.tasks
                      .where((t) => t.status == TaskStatus.neu)
                      .toList(),
                ),
                const SizedBox(width: AppTheme.spacing12),
                _buildColumn(
                  context,
                  'قيد العمل',
                  TaskStatus.inProgress,
                  project.tasks
                      .where((t) => t.status == TaskStatus.inProgress)
                      .toList(),
                ),
                const SizedBox(width: AppTheme.spacing12),
                _buildColumn(
                  context,
                  'منتهي',
                  TaskStatus.completed,
                  project.tasks
                      .where((t) => t.status == TaskStatus.completed)
                      .toList(),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildColumn(
    BuildContext context,
    String title,
    TaskStatus status,
    List<Task> tasks,
  ) {
    return Container(
      width: MediaQuery.of(context).size.width - 32,
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(AppTheme.borderRadius12),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(AppTheme.spacing12),
            decoration: BoxDecoration(
              color: _getStatusColor(status),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(AppTheme.borderRadius12),
                topRight: Radius.circular(AppTheme.borderRadius12),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppTheme.spacing8,
                    vertical: AppTheme.spacing4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(AppTheme.borderRadius8),
                  ),
                  child: Text(
                    '${tasks.length}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(AppTheme.spacing12),
              itemCount: tasks.length,
              itemBuilder: (context, index) {
                return TaskCard(
                  task: tasks[index],
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => TaskFormScreen(task: tasks[index]),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(TaskStatus status) {
    switch (status) {
      case TaskStatus.neu:
        return AppTheme.newStatusColor;
      case TaskStatus.inProgress:
        return AppTheme.inProgressStatusColor;
      case TaskStatus.completed:
        return AppTheme.completedStatusColor;
    }
  }
}
