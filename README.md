<<<<<<< HEAD
# نظام إدارة المهام | Task Management System

نظام إدارة مشاريع متقدم مبني على **Flutter** مع تطبيق خوارزميات متقدمة لحل مشاكل إدارية واقعية.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
=======
# Task-Project
>>>>>>> 3e5e8ab6265aaa9e7359c93b0912bf7d08477956
=======
# Comparison Sorting & Divide and Conquer - Task Management

## Project idea
This Flutter project demonstrates two algorithmic requirements for project task management:

1. **Comparison Sorting:** Sort project tasks by priority or due date using manual Merge Sort and Quick Sort, without using Dart's built-in `sort()` function. The application measures execution time in milliseconds.
2. **Divide and Conquer / Recursion:** Treat the project as a root task containing a tree of subtasks. A recursive function calculates the total expected project hours, shows the recursive call stack, and combines the results of all branches.

## Algorithms
### Merge Sort
- Manual implementation.
- Best: O(n log n)
- Average: O(n log n)
- Worst: O(n log n)

### Quick Sort
- Manual implementation using the last element as pivot.
- Best: O(n log n)
- Average: O(n log n)
- Worst: O(n²)

### Divide and Conquer / Recursive calculation
The project root is passed to a recursive function. The function visits every task/subtask once, calculates each branch, and combines the returned hours.

- Time complexity: O(n), where n is the number of nodes/tasks.
- Auxiliary recursion stack: O(h), where h is the maximum tree depth.

## Fair performance comparison
The application can generate datasets of 100, 1,000, or 5,000 tasks. Both algorithms receive the **same original unsorted dataset**, each is executed five times, and the best measured time is displayed in milliseconds. This avoids comparing one algorithm on data already sorted by the other.

## What the UI demonstrates
- Sort by priority: High -> Medium -> Low.
- Sort by due date: earliest -> latest.
- Execution time for all four sort operations.
- Fair benchmark for Merge Sort vs Quick Sort.
- Project root and recursive task tree.
- Total project hours.
- Recursive Call Stack / Divide / Combine steps.
- Best, average, and worst-case complexity analysis.

## Important implementation rule
No built-in list sorting function is used. Both sorting algorithms are implemented manually in `lib/algorithms/`.

## Testing
Run:

```bash
flutter test
```

The tests verify Merge Sort, Quick Sort, recursive hour calculation, and the main project UI.
>>>>>>> origin/yahia-branch
