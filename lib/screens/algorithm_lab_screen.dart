import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_management_system/algorithms/divide_and_conquer.dart';
import 'package:task_management_system/algorithms/merge_sort.dart';
import 'package:task_management_system/algorithms/quick_sort.dart';
import 'package:task_management_system/models/models.dart';
import 'package:task_management_system/providers/project_provider.dart';
import 'package:task_management_system/theme/app_theme.dart';

class AlgorithmLabScreen extends StatefulWidget {
  const AlgorithmLabScreen({super.key});

  @override
  State<AlgorithmLabScreen> createState() => _AlgorithmLabScreenState();
}

class _AlgorithmLabScreenState extends State<AlgorithmLabScreen> {
  List<Task> _sortedTasks = const [];
  String _sortDescription = 'لم يتم تشغيل خوارزمية بعد';
  String _sortDuration = '-';
  double? _totalHours;
  List<String> _trace = const [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('مختبر الخوارزميات')),
      body: Consumer<ProjectProvider>(
        builder: (context, provider, _) {
          final project = provider.currentProject;
          if (project == null) {
            return const Center(child: Text('لا يوجد مشروع محدد'));
          }

          final tasks = project.tasks;
          final displayedTasks = _sortedTasks.isEmpty ? tasks : _sortedTasks;

          return Container(
            decoration: const BoxDecoration(
              gradient: AppTheme.backgroundGradient,
            ),
            child: ListView(
              padding: const EdgeInsets.all(AppTheme.spacing16),
              children: [
                _buildIntro(context, tasks.length),
                const SizedBox(height: AppTheme.spacing16),
                _buildSortingCard(context, tasks),
                const SizedBox(height: AppTheme.spacing16),
                _buildTaskResults(context, displayedTasks),
                const SizedBox(height: AppTheme.spacing16),
                _buildDivideAndConquerCard(context, project.tasks),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildIntro(BuildContext context, int taskCount) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppTheme.spacing16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'الخوارزميات المرتبطة بالمشروع',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: AppTheme.spacing8),
            Text(
              'عدد المهام الرئيسية: $taskCount. اختر خوارزمية لترتيب المهام أو احسب الساعات recursively باستخدام Divide and Conquer.',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSortingCard(BuildContext context, List<Task> tasks) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppTheme.spacing16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Comparison Sorting', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: AppTheme.spacing8),
            const Text('يتم نسخ قائمة المهام قبل الترتيب حتى لا تتأثر بيانات المشروع الأصلية.'),
            const SizedBox(height: AppTheme.spacing12),
            Wrap(
              spacing: AppTheme.spacing8,
              runSpacing: AppTheme.spacing8,
              children: [
                ElevatedButton.icon(
                  onPressed: tasks.length < 2 ? null : () => _sort(tasks, true, false),
                  icon: const Icon(Icons.merge_type),
                  label: const Text('Merge حسب الأولوية'),
                ),
                ElevatedButton.icon(
                  onPressed: tasks.length < 2 ? null : () => _sort(tasks, false, false),
                  icon: const Icon(Icons.flash_on),
                  label: const Text('Quick حسب الأولوية'),
                ),
                ElevatedButton.icon(
                  onPressed: tasks.length < 2 ? null : () => _sort(tasks, true, true),
                  icon: const Icon(Icons.calendar_month),
                  label: const Text('Merge حسب التاريخ'),
                ),
                ElevatedButton.icon(
                  onPressed: tasks.length < 2 ? null : () => _sort(tasks, false, true),
                  icon: const Icon(Icons.calendar_today),
                  label: const Text('Quick حسب التاريخ'),
                ),
              ],
            ),
            const SizedBox(height: AppTheme.spacing12),
            Text('$_sortDescription - الزمن: $_sortDuration'),
          ],
        ),
      ),
    );
  }

  Widget _buildTaskResults(BuildContext context, List<Task> tasks) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppTheme.spacing16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('نتيجة الترتيب', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: AppTheme.spacing8),
            if (tasks.isEmpty)
              const Text('لا توجد مهام لعرضها')
            else
              ...tasks.asMap().entries.map(
                    (entry) => ListTile(
                      dense: true,
                      leading: CircleAvatar(child: Text('${entry.key + 1}')),
                      title: Text(entry.value.title),
                      subtitle: Text(
                        'الأولوية: ${_priorityLabel(entry.value.priority)} | '
                        'التسليم: ${_dateLabel(entry.value.dueDate)}',
                      ),
                    ),
                  ),
          ],
        ),
      ),
    );
  }

  Widget _buildDivideAndConquerCard(BuildContext context, List<Task> tasks) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppTheme.spacing16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Divide and Conquer', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: AppTheme.spacing8),
            const Text('حساب مجموع الساعات للمهمة وجميع المهام الفرعية بشكل recursive.'),
            const SizedBox(height: AppTheme.spacing12),
            ElevatedButton.icon(
              onPressed: tasks.isEmpty ? null : () => _calculateHours(tasks),
              icon: const Icon(Icons.account_tree),
              label: const Text('احسب إجمالي الساعات وسجل الاستدعاءات'),
            ),
            if (_totalHours != null) ...[
              const SizedBox(height: AppTheme.spacing12),
              Text(
                'إجمالي الساعات: ${_totalHours!.toStringAsFixed(1)}',
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              if (_trace.isNotEmpty) ...[
                const SizedBox(height: AppTheme.spacing8),
                ExpansionTile(
                  title: const Text('عرض خطوات الاستدعاء recursive'),
                  children: _trace
                      .map((line) => Align(
                            alignment: AlignmentDirectional.centerStart,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
                              child: Text(line, style: const TextStyle(fontFamily: 'monospace')),
                            ),
                          ))
                      .toList(),
                ),
              ],
            ],
          ],
        ),
      ),
    );
  }

  void _sort(List<Task> source, bool useMerge, bool byDate) {
    final sorted = List<Task>.from(source);
    final stopwatch = Stopwatch()..start();

    int compare(Task a, Task b) {
      if (byDate) return a.dueDate.compareTo(b.dueDate);
      return _priorityValue(a.priority).compareTo(_priorityValue(b.priority));
    }

    if (useMerge) {
      MergeSort.sort(sorted, compare);
    } else {
      QuickSort.sort(sorted, compare);
    }
    stopwatch.stop();

    setState(() {
      _sortedTasks = sorted;
      _sortDescription = '${useMerge ? 'Merge Sort' : 'Quick Sort'} حسب ${byDate ? 'تاريخ التسليم' : 'الأولوية'}';
      _sortDuration = '${(stopwatch.elapsedMicroseconds / 1000).toStringAsFixed(3)} ms';
    });
  }

  void _calculateHours(List<Task> tasks) {
    final trace = <String>[];
    var total = 0.0;
    for (final task in tasks) {
      total += DivideAndConquer.calculateTotalHoursGeneric<Task>(
        task,
        getHours: (item) => item.estimatedHours,
        getSubtasks: (item) => item.subtasks,
        onTrace: (message, depth) => trace.add('${'  ' * depth}$message'),
      );
    }
    setState(() {
      _totalHours = total;
      _trace = trace;
    });
  }

  int _priorityValue(Priority priority) {
    switch (priority) {
      case Priority.high:
        return 1;
      case Priority.medium:
        return 2;
      case Priority.low:
        return 3;
    }
  }

  String _priorityLabel(Priority priority) {
    switch (priority) {
      case Priority.high:
        return 'عالية';
      case Priority.medium:
        return 'متوسطة';
      case Priority.low:
        return 'منخفضة';
    }
  }

  String _dateLabel(DateTime date) => '${date.day}/${date.month}/${date.year}';
}
