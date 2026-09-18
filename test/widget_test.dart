import 'package:flutter_test/flutter_test.dart';
import 'package:task_management_system/algorithms/divide_and_conquer.dart';
import 'package:task_management_system/algorithms/merge_sort.dart';
import 'package:task_management_system/algorithms/quick_sort.dart';
import 'package:task_management_system/main.dart';
import 'package:task_management_system/models/task.dart';

void main() {
  test('Merge Sort sorts tasks by priority without using List.sort', () {
    final tasks = [
      Task(
        title: 'Low',
        description: '',
        priority: 'Low',
        dueDate: DateTime(2026, 9, 20),
        expectedHours: 2,
      ),
      Task(
        title: 'High',
        description: '',
        priority: 'High',
        dueDate: DateTime(2026, 9, 12),
        expectedHours: 3,
      ),
      Task(
        title: 'Medium',
        description: '',
        priority: 'Medium',
        dueDate: DateTime(2026, 9, 15),
        expectedHours: 4,
      ),
    ];

    const priority = {'High': 1, 'Medium': 2, 'Low': 3};
    MergeSort.sort(
      tasks,
      (a, b) => priority[a.priority]!.compareTo(priority[b.priority]!),
    );

    expect(tasks.map((task) => task.priority).toList(), [
      'High',
      'Medium',
      'Low',
    ]);
  });

  test('Quick Sort sorts tasks by due date', () {
    final tasks = [
      Task(
        title: '3',
        description: '',
        priority: 'Low',
        dueDate: DateTime(2026, 9, 20),
        expectedHours: 2,
      ),
      Task(
        title: '1',
        description: '',
        priority: 'High',
        dueDate: DateTime(2026, 9, 10),
        expectedHours: 3,
      ),
      Task(
        title: '2',
        description: '',
        priority: 'Medium',
        dueDate: DateTime(2026, 9, 15),
        expectedHours: 4,
      ),
    ];

    QuickSort.sort(tasks, (a, b) => a.dueDate.compareTo(b.dueDate));

    expect(tasks.map((task) => task.title).toList(), ['1', '2', '3']);
  });

  test('Divide and Conquer calculates all recursive task hours', () {
    final root = Task(
      title: 'Project',
      description: '',
      priority: 'High',
      dueDate: DateTime(2026, 9, 30),
      expectedHours: 0,
      subtasks: [
        Task(
          title: 'Main',
          description: '',
          priority: 'High',
          dueDate: DateTime(2026, 9, 20),
          expectedHours: 5,
          subtasks: [
            Task(
              title: 'Child 1',
              description: '',
              priority: 'Low',
              dueDate: DateTime(2026, 9, 21),
              expectedHours: 2,
            ),
            Task(
              title: 'Child 2',
              description: '',
              priority: 'Low',
              dueDate: DateTime(2026, 9, 22),
              expectedHours: 3,
            ),
          ],
        ),
      ],
    );

    expect(DivideAndConquer.calculateTotalHours(root), 10);
  });

  testWidgets('The task management application starts successfully', (
    tester,
  ) async {
    await tester.pumpWidget(const MyApp());
    await tester.pumpAndSettle();

    expect(find.byType(MaterialApp), findsOneWidget);
  });
}
