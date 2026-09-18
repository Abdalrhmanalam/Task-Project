import '../models/task.dart';

typedef TraceCallback = void Function(String message, int depth);

class DivideAndConquer {
  /// Recursively calculates the total expected hours of a project tree.
  ///
  /// The supplied [root] represents the project/root task. Each node is
  /// processed once, so the time complexity is O(n), where n is the number
  /// of tasks and subtasks in the tree.
  static double calculateTotalHours(
    Task root, {
    TraceCallback? onTrace,
  }) {
    onTrace?.call('CALL: ${root.title} (${root.expectedHours} h)', 0);
    return _calculate(root, onTrace, 0);
  }

  static double _calculate(
    Task task,
    TraceCallback? onTrace,
    int depth,
  ) {
    double total = task.expectedHours;

    if (task.subtasks.isEmpty) {
      onTrace?.call(
        'RETURN: ${task.title} -> ${total.toStringAsFixed(1)} h',
        depth,
      );
      return total;
    }

    onTrace?.call('DIVIDE: ${task.title} into ${task.subtasks.length} subtask(s)', depth);

    for (final subtask in task.subtasks) {
      onTrace?.call('CALL: ${subtask.title}', depth + 1);
      total += _calculate(subtask, onTrace, depth + 1);
    }

    onTrace?.call(
      'COMBINE/RETURN: ${task.title} -> ${total.toStringAsFixed(1)} h',
      depth,
    );
    return total;
  }
}
