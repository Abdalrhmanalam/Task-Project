import '../models/task.dart';

typedef TraceCallback = void Function(String message, int depth);

class DivideAndConquer {
  /// Recursively calculates the total expected hours of the legacy task tree.
  static double calculateTotalHours(
    Task root, {
    TraceCallback? onTrace,
  }) {
    onTrace?.call('CALL: ${root.title} (${root.expectedHours} h)', 0);
    return _calculate(root, onTrace, 0);
  }

  /// Generic version used by the application task model and UI.
  static double calculateTotalHoursGeneric<T>(
    T root, {
    required double Function(T item) getHours,
    required List<T> Function(T item) getSubtasks,
    void Function(String message, int depth)? onTrace,
  }) {
    double calculate(T item, int depth) {
      final children = getSubtasks(item);
      final hours = getHours(item);
      onTrace?.call('CALL: $item ($hours h)', depth);
      var total = hours;
      for (final child in children) {
        total += calculate(child, depth + 1);
      }
      onTrace?.call('RETURN: $item -> ${total.toStringAsFixed(1)} h', depth);
      return total;
    }

    return calculate(root, 0);
  }

  static double _calculate(
    Task task,
    TraceCallback? onTrace,
    int depth,
  ) {
    var total = task.expectedHours;
    if (task.subtasks.isEmpty) {
      onTrace?.call(
        'RETURN: ${task.title} -> ${total.toStringAsFixed(1)} h',
        depth,
      );
      return total;
    }

    onTrace?.call(
      'DIVIDE: ${task.title} into ${task.subtasks.length} subtask(s)',
      depth,
    );
    for (final subtask in task.subtasks) {
      total += _calculate(subtask, onTrace, depth + 1);
    }
    onTrace?.call(
      'COMBINE/RETURN: ${task.title} -> ${total.toStringAsFixed(1)} h',
      depth,
    );
    return total;
  }
}
