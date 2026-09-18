import 'package:flutter/material.dart';
<<<<<<< HEAD
import 'package:provider/provider.dart';
import 'package:task_management_system/theme/app_theme.dart';
import 'package:task_management_system/providers/project_provider.dart';
import 'package:task_management_system/screens/home_screen.dart';
=======

import 'algorithms/divide_and_conquer.dart';
import 'algorithms/merge_sort.dart';
import 'algorithms/quick_sort.dart';
import 'models/task.dart';
>>>>>>> origin/yahia-branch

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
<<<<<<< HEAD
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ProjectProvider()),
      ],
      child: MaterialApp(
        title: 'نظام إدارة المهام',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: ThemeMode.light,
        home: const HomeScreen(),
=======
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Comparison Sorting & Divide and Conquer',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const SortingPage(),
    );
  }
}

class SortingPage extends StatefulWidget {
  const SortingPage({super.key});

  @override
  State<SortingPage> createState() => _SortingPageState();
}

class _SortingPageState extends State<SortingPage> {
  late Task projectRoot;
  late List<Task> tasks;

  double mergePriorityTime = 0;
  double quickPriorityTime = 0;
  double mergeDateTime = 0;
  double quickDateTime = 0;

  double benchmarkMergeTime = 0;
  double benchmarkQuickTime = 0;
  int benchmarkSize = 1000;

  double totalProjectHours = 0;
  List<String> callStack = [];

  @override
  void initState() {
    super.initState();
    projectRoot = _createProject();
    tasks = List<Task>.from(projectRoot.subtasks);
    totalProjectHours = _calculateWithoutTrace(projectRoot);
  }

  Task _createProject() {
    return Task(
      title: 'Project Root',
      description: 'Root of the project task tree',
      priority: 'High',
      dueDate: DateTime(2026, 9, 30),
      expectedHours: 0,
      subtasks: [
        Task(
          title: 'Design Login Page',
          description: 'Create the login interface',
          priority: 'High',
          dueDate: DateTime(2026, 9, 20),
          expectedHours: 5,
          subtasks: [
            Task(
              title: 'Design Login UI',
              description: 'Create the login design',
              priority: 'Medium',
              dueDate: DateTime(2026, 9, 18),
              expectedHours: 2,
            ),
            Task(
              title: 'Implement Login',
              description: 'Write login functionality',
              priority: 'High',
              dueDate: DateTime(2026, 9, 19),
              expectedHours: 3,
            ),
          ],
        ),
        Task(
          title: 'Create Database',
          description: 'Build the project database',
          priority: 'Low',
          dueDate: DateTime(2026, 9, 25),
          expectedHours: 8,
          subtasks: [
            Task(
              title: 'Create Tables',
              description: 'Create database tables',
              priority: 'Medium',
              dueDate: DateTime(2026, 9, 22),
              expectedHours: 3,
            ),
            Task(
              title: 'Add Relationships',
              description: 'Create relationships between tables',
              priority: 'Low',
              dueDate: DateTime(2026, 9, 24),
              expectedHours: 2,
            ),
          ],
        ),
        Task(
          title: 'Implement API',
          description: 'Create the backend API',
          priority: 'Medium',
          dueDate: DateTime(2026, 9, 18),
          expectedHours: 6,
          subtasks: [
            Task(
              title: 'Create Endpoints',
              description: 'Create API endpoints',
              priority: 'High',
              dueDate: DateTime(2026, 9, 16),
              expectedHours: 2,
            ),
            Task(
              title: 'Test API',
              description: 'Test API requests',
              priority: 'Medium',
              dueDate: DateTime(2026, 9, 17),
              expectedHours: 2,
            ),
          ],
        ),
        Task(
          title: 'Testing',
          description: 'Test the application',
          priority: 'High',
          dueDate: DateTime(2026, 9, 15),
          expectedHours: 4,
          subtasks: [
            Task(
              title: 'Unit Testing',
              description: 'Test individual functions',
              priority: 'High',
              dueDate: DateTime(2026, 9, 14),
              expectedHours: 2,
            ),
          ],
        ),
      ],
    );
  }

  int priorityValue(String priority) {
    switch (priority) {
      case 'High':
        return 1;
      case 'Medium':
        return 2;
      default:
        return 3;
    }
  }

  int compareByPriority(Task a, Task b) {
    return priorityValue(a.priority).compareTo(priorityValue(b.priority));
  }

  int compareByDueDate(Task a, Task b) {
    return a.dueDate.compareTo(b.dueDate);
  }

  void _sortAndMeasure({required bool merge, required bool byDate}) {
    final original = List<Task>.from(projectRoot.subtasks);
    final sortedTasks = List<Task>.from(original);
    final comparator = byDate ? compareByDueDate : compareByPriority;

    final stopwatch = Stopwatch()..start();
    if (merge) {
      MergeSort.sort(sortedTasks, comparator);
    } else {
      QuickSort.sort(sortedTasks, comparator);
    }
    stopwatch.stop();

    final milliseconds = stopwatch.elapsedMicroseconds / 1000.0;

    setState(() {
      tasks = sortedTasks;
      projectRoot.subtasks = sortedTasks;
      if (merge && byDate) mergeDateTime = milliseconds;
      if (merge && !byDate) mergePriorityTime = milliseconds;
      if (!merge && byDate) quickDateTime = milliseconds;
      if (!merge && !byDate) quickPriorityTime = milliseconds;
    });
  }

  void sortUsingMergeSort() => _sortAndMeasure(merge: true, byDate: false);
  void sortUsingQuickSort() => _sortAndMeasure(merge: false, byDate: false);
  void sortUsingMergeSortByDate() => _sortAndMeasure(merge: true, byDate: true);
  void sortUsingQuickSortByDate() => _sortAndMeasure(merge: false, byDate: true);

  void resetTasks() {
    setState(() {
      projectRoot = _createProject();
      tasks = List<Task>.from(projectRoot.subtasks);
      callStack = [];
      totalProjectHours = _calculateWithoutTrace(projectRoot);
    });
  }

  double _calculateWithoutTrace(Task root) {
    return DivideAndConquer.calculateTotalHours(root);
  }

  void calculateTotalProjectHours() {
    final trace = <String>[];
    final total = DivideAndConquer.calculateTotalHours(
      projectRoot,
      onTrace: (message, depth) {
        trace.add('${'  ' * depth}$message');
      },
    );

    setState(() {
      totalProjectHours = total;
      callStack = trace;
    });
  }

  List<Task> _generateBenchmarkTasks(int count) {
    final priorities = ['High', 'Medium', 'Low'];
    final result = <Task>[];
    var seed = 1234567;

    for (var i = 0; i < count; i++) {
      seed = (seed * 1103515245 + 12345) & 0x7fffffff;
      final priority = priorities[seed % priorities.length];
      seed = (seed * 1103515245 + 12345) & 0x7fffffff;
      final day = (seed % 28) + 1;

      result.add(
        Task(
          title: 'Benchmark Task ${i + 1}',
          description: 'Generated test task',
          priority: priority,
          dueDate: DateTime(2026, 9, day),
          expectedHours: (i % 8) + 1,
        ),
      );
    }

    return result;
  }

  double _measureMerge(List<Task> source, int runs) {
    var best = double.infinity;
    for (var i = 0; i < runs; i++) {
      final data = List<Task>.from(source);
      final stopwatch = Stopwatch()..start();
      MergeSort.sort(data, compareByPriority);
      stopwatch.stop();
      final ms = stopwatch.elapsedMicroseconds / 1000.0;
      if (ms < best) best = ms;
    }
    return best;
  }

  double _measureQuick(List<Task> source, int runs) {
    var best = double.infinity;
    for (var i = 0; i < runs; i++) {
      final data = List<Task>.from(source);
      final stopwatch = Stopwatch()..start();
      QuickSort.sort(data, compareByPriority);
      stopwatch.stop();
      final ms = stopwatch.elapsedMicroseconds / 1000.0;
      if (ms < best) best = ms;
    }
    return best;
  }

  void runBenchmark() {
    final source = _generateBenchmarkTasks(benchmarkSize);
    final merge = _measureMerge(source, 5);
    final quick = _measureQuick(source, 5);

    setState(() {
      benchmarkMergeTime = merge;
      benchmarkQuickTime = quick;
    });
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/'
        '${date.month.toString().padLeft(2, '0')}/${date.year}';
  }

  Widget _timeCard(String title, double time) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 6),
            Text('${time.toStringAsFixed(3)} ms', style: const TextStyle(fontSize: 20)),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Comparison Sorting'),
        centerTitle: true,
        actions: [
          IconButton(
            tooltip: 'Reset tasks',
            onPressed: resetTasks,
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Task Management Algorithms',
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'Compare Merge Sort and Quick Sort by priority and due date, '
              'then calculate project effort recursively using Divide and Conquer.',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Text('Project Tasks', style: TextStyle(fontSize: 21, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 10),
                    ...tasks.map(
                      (task) => Card(
                        margin: const EdgeInsets.only(bottom: 8),
                        child: ListTile(
                          title: Text(task.title, style: const TextStyle(fontWeight: FontWeight.bold)),
                          subtitle: Text(
                            'Priority: ${task.priority}\n'
                            'Due Date: ${_formatDate(task.dueDate)}\n'
                            'Expected Hours: ${task.expectedHours}\n'
                            'Subtasks: ${task.subtasks.length}',
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            const Text('1. Comparison Sorting', style: TextStyle(fontSize: 23, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                ElevatedButton.icon(onPressed: sortUsingMergeSort, icon: const Icon(Icons.merge_type), label: const Text('Merge Sort - Priority')),
                ElevatedButton.icon(onPressed: sortUsingQuickSort, icon: const Icon(Icons.flash_on), label: const Text('Quick Sort - Priority')),
                ElevatedButton.icon(onPressed: sortUsingMergeSortByDate, icon: const Icon(Icons.calendar_month), label: const Text('Merge Sort - Due Date')),
                ElevatedButton.icon(onPressed: sortUsingQuickSortByDate, icon: const Icon(Icons.calendar_today), label: const Text('Quick Sort - Due Date')),
              ],
            ),
            const SizedBox(height: 12),
            const Text('Measured time for the last operation:'),
            Wrap(
              spacing: 8,
              children: [
                _timeCard('Merge Sort - Priority', mergePriorityTime),
                _timeCard('Quick Sort - Priority', quickPriorityTime),
                _timeCard('Merge Sort - Date', mergeDateTime),
                _timeCard('Quick Sort - Date', quickDateTime),
              ],
            ),
            const SizedBox(height: 16),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Text('Fair Performance Benchmark', style: TextStyle(fontSize: 21, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    Text('Both algorithms use the same newly generated ${benchmarkSize}-task dataset. Each is run 5 times and the best measured time is shown.'),
                    const SizedBox(height: 10),
                    DropdownButton<int>(
                      value: benchmarkSize,
                      items: const [100, 1000, 5000].map((size) => DropdownMenuItem(value: size, child: Text('$size tasks'))).toList(),
                      onChanged: (value) => setState(() => benchmarkSize = value ?? 1000),
                    ),
                    ElevatedButton.icon(onPressed: runBenchmark, icon: const Icon(Icons.speed), label: const Text('Run Fair Comparison')),
                    const SizedBox(height: 8),
                    if (benchmarkMergeTime > 0 || benchmarkQuickTime > 0)
                      Text('Merge Sort: ${benchmarkMergeTime.toStringAsFixed(3)} ms\nQuick Sort: ${benchmarkQuickTime.toStringAsFixed(3)} ms'),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Text('2. Divide and Conquer', style: TextStyle(fontSize: 23, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            ElevatedButton.icon(
              onPressed: calculateTotalProjectHours,
              icon: const Icon(Icons.account_tree),
              label: const Text('Calculate Total Project Hours + Show Call Stack'),
            ),
            const SizedBox(height: 10),
            Text(
              'Total Project Hours: ${totalProjectHours.toStringAsFixed(1)} hours',
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            if (callStack.isNotEmpty)
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Recursive Call Stack / Steps', style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 8),
                      ...callStack.map((line) => Padding(
                            padding: const EdgeInsets.symmetric(vertical: 2),
                            child: Text(line, style: const TextStyle(fontFamily: 'monospace')),
                          )),
                    ],
                  ),
                ),
              ),
            const SizedBox(height: 20),
            const Text('Algorithm Analysis', style: TextStyle(fontSize: 23, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text('Merge Sort', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    Text('Best: O(n log n)   |   Average: O(n log n)   |   Worst: O(n log n)'),
                    SizedBox(height: 10),
                    Text('Quick Sort', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    Text('Best: O(n log n)   |   Average: O(n log n)   |   Worst: O(n²)'),
                    SizedBox(height: 10),
                    Text('Why can one outperform the other?', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    Text('Quick Sort can be faster in practice because it often has good cache locality and small constant factors. However, with a poor pivot repeatedly, its worst case becomes O(n²). Merge Sort keeps O(n log n) even in the worst case, so it is more predictable.'),
                    SizedBox(height: 10),
                    Text('Divide and Conquer analysis', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    Text('The recursive function starts from the project root, visits every task/subtask once, solves each branch recursively, and combines the returned hours. Therefore its time complexity is O(n) and the recursion uses a call stack whose maximum depth equals the tree depth.'),
                  ],
                ),
              ),
            ),
          ],
        ),
>>>>>>> origin/yahia-branch
      ),
    );
  }
}
