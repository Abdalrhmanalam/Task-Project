import 'package:task_management_system/models/models.dart';
import 'package:intl/intl.dart' as intl;

extension PriorityExtension on Priority {
  String get label {
    switch (this) {
      case Priority.high:
        return 'عالية';
      case Priority.medium:
        return 'متوسطة';
      case Priority.low:
        return 'منخفضة';
    }
  }
}

extension TaskStatusExtension on TaskStatus {
  String get label {
    switch (this) {
      case TaskStatus.neu:
        return 'جديد';
      case TaskStatus.inProgress:
        return 'قيد العمل';
      case TaskStatus.completed:
        return 'منتهي';
    }
  }
}

extension UserRoleExtension on UserRole {
  String get label {
    switch (this) {
      case UserRole.manager:
        return 'مدير المشروع';
      case UserRole.developer:
        return 'مطور';
      case UserRole.designer:
        return 'مصمم';
      case UserRole.tester:
        return 'مختبر';
      case UserRole.analyst:
        return 'محلل';
    }
  }
}

extension DateExtension on DateTime {
  String get formattedDate {
    return intl.DateFormat('dd/MM/yyyy', 'ar_SA').format(this);
  }

  String get formattedTime {
    return intl.DateFormat('HH:mm', 'ar_SA').format(this);
  }

  String get formattedDateTime {
    return intl.DateFormat('dd/MM/yyyy HH:mm', 'ar_SA').format(this);
  }

  bool get isToday {
    final now = DateTime.now();
    return year == now.year && month == now.month && day == now.day;
  }

  bool get isOverdue {
    return isBefore(DateTime.now()) && !isToday;
  }
}
