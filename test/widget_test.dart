<<<<<<< HEAD
// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('Counter increments smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MaterialApp(
      home: Scaffold(
        body: Center(
          child: Text('0'),
        ),
        
      ),
    ));

    // Verify that our counter starts at 0.
    expect(find.text('0'), findsOneWidget);
    expect(find.text('1'), findsNothing);

    // Tap the '+' icon and trigger a frame.
    await tester.tap(find.byIcon(Icons.add));
    await tester.pump();

    // Verify that our counter has incremented.
    expect(find.text('0'), findsNothing);
    expect(find.text('1'), findsOneWidget);
=======
import 'package:flutter_test/flutter_test.dart';
import 'package:task_project/algorithms/divide_and_conquer.dart';
import 'package:task_project/algorithms/merge_sort.dart';
import 'package:task_project/algorithms/quick_sort.dart';
import 'package:task_project/main.dart';
import 'package:task_project/models/task.dart';

void main() {
  test('Merge Sort sorts tasks by priority without using List.sort', () {
    final tasks = [
      Task(title: 'Low', description: '', priority: 'Low', dueDate: DateTime(2026, 9, 20), expectedHours: 2),
      Task(title: 'High', description: '', priority: 'High', dueDate: DateTime(2026, 9, 12), expectedHours: 3),
      Task(title: 'Medium', description: '', priority: 'Medium', dueDate: DateTime(2026, 9, 15), expectedHours: 4),
    ];

    const priority = {'High': 1, 'Medium': 2, 'Low': 3};
    MergeSort.sort(tasks, (a, b) => priority[a.priority]!.compareTo(priority[b.priority]!));

    expect(tasks.map((e) => e.priority).toList(), ['High', 'Medium', 'Low']);
  });

  test('Quick Sort sorts tasks by due date', () {
    final tasks = [
      Task(title: '3', description: '', priority: 'Low', dueDate: DateTime(2026, 9, 20), expectedHours: 2),
      Task(title: '1', description: '', priority: 'High', dueDate: DateTime(2026, 9, 10), expectedHours: 3),
      Task(title: '2', description: '', priority: 'Medium', dueDate: DateTime(2026, 9, 15), expectedHours: 4),
    ];

    QuickSort.sort(tasks, (a, b) => a.dueDate.compareTo(b.dueDate));

    expect(tasks.map((e) => e.title).toList(), ['1', '2', '3']);
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
            Task(title: 'Child 1', description: '', priority: 'Low', dueDate: DateTime(2026, 9, 21), expectedHours: 2),
            Task(title: 'Child 2', description: '', priority: 'Low', dueDate: DateTime(2026, 9, 22), expectedHours: 3),
          ],
        ),
      ],
    );

    expect(DivideAndConquer.calculateTotalHours(root), 10);
  });

  testWidgets('Project page displays the required algorithm sections', (tester) async {
    await tester.pumpWidget(const MyApp());

    expect(find.text('Comparison Sorting'), findsOneWidget);
    expect(find.text('1. Comparison Sorting'), findsOneWidget);
    expect(find.text('2. Divide and Conquer'), findsOneWidget);
    expect(find.text('Fair Performance Benchmark'), findsOneWidget);
    expect(find.text('Algorithm Analysis'), findsOneWidget);
>>>>>>> origin/yahia-branch
  });
}
