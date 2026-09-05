// ============================================================
// Priority
// ============================================================

enum Priority {
  high,
  medium,
  low,
}

// ============================================================
// Task Status
// ============================================================

enum TaskStatus {
  neu,
  inProgress,
  completed,
}

// ============================================================
// User Role
// ============================================================

enum UserRole {
  manager,
  developer,
  designer,
  tester,
  analyst,
}

// ============================================================
// Project Model
// ============================================================

class Project {
  final String id;
  final String name;
  final String description;
  final DateTime startDate;
  final DateTime endDate;
  final DateTime createdAt;
  final List<Task> tasks;
  final List<TeamMember> members;

  Project({
    required this.id,
    required this.name,
    required this.description,
    required this.startDate,
    required this.endDate,
    required this.createdAt,
    this.tasks = const [],
    this.members = const [],
  });

  Project copyWith({
    String? id,
    String? name,
    String? description,
    DateTime? startDate,
    DateTime? endDate,
    DateTime? createdAt,
    List<Task>? tasks,
    List<TeamMember>? members,
  }) {
    return Project(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      createdAt: createdAt ?? this.createdAt,
      tasks: tasks ?? this.tasks,
      members: members ?? this.members,
    );
  }
}

// ============================================================
// Task Model
// ============================================================

class Task {
  final String id;
  final String projectId;
  final String title;
  final String description;

  final Priority priority;
  final TaskStatus status;

  final DateTime dueDate;

  final String assignedTo;

  final DateTime createdAt;
  final DateTime updatedAt;

  // المهام الفرعية
  final List<Task> subtasks;

  // ID الخاص بالمهمة الأب
  final String? parentId;

  final double estimatedHours;
  final double actualHours;

  // سجل تغيرات الحالة
  final List<StatusChange> statusHistory;

  Task({
    required this.id,
    required this.projectId,
    required this.title,
    required this.description,
    required this.priority,
    required this.status,
    required this.dueDate,
    required this.assignedTo,
    required this.createdAt,
    required this.updatedAt,
    this.subtasks = const [],
    this.parentId,
    this.estimatedHours = 0,
    this.actualHours = 0,
    this.statusHistory = const [],
  });

  Task copyWith({
    String? id,
    String? projectId,
    String? title,
    String? description,
    Priority? priority,
    TaskStatus? status,
    DateTime? dueDate,
    String? assignedTo,
    DateTime? createdAt,
    DateTime? updatedAt,
    List<Task>? subtasks,
    String? parentId,
    double? estimatedHours,
    double? actualHours,
    List<StatusChange>? statusHistory,
  }) {
    return Task(
      id: id ?? this.id,
      projectId: projectId ?? this.projectId,
      title: title ?? this.title,
      description: description ?? this.description,
      priority: priority ?? this.priority,
      status: status ?? this.status,
      dueDate: dueDate ?? this.dueDate,
      assignedTo: assignedTo ?? this.assignedTo,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      subtasks: subtasks ?? this.subtasks,
      parentId: parentId ?? this.parentId,
      estimatedHours: estimatedHours ?? this.estimatedHours,
      actualHours: actualHours ?? this.actualHours,
      statusHistory: statusHistory ?? this.statusHistory,
    );
  }
}

// ============================================================
// Status Change
// ============================================================

class StatusChange {
  final TaskStatus from;
  final TaskStatus to;
  final DateTime changedAt;
  final String changedBy;

  StatusChange({
    required this.from,
    required this.to,
    required this.changedAt,
    required this.changedBy,
  });
}

// ============================================================
// Team Member
// ============================================================

class TeamMember {
  final String id;
  final String name;
  final String email;
  final UserRole role;
  final String? avatar;
  final int tasksCompleted;

  TeamMember({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    this.avatar,
    this.tasksCompleted = 0,
  });

  TeamMember copyWith({
    String? id,
    String? name,
    String? email,
    UserRole? role,
    String? avatar,
    int? tasksCompleted,
  }) {
    return TeamMember(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      role: role ?? this.role,
      avatar: avatar ?? this.avatar,
      tasksCompleted: tasksCompleted ?? this.tasksCompleted,
    );
  }
}

// ============================================================
// Project Statistics
// ============================================================

class ProjectStats {
  final int totalTasks;
  final int completedTasks;

  final double completionPercentage;

  final double totalEstimatedHours;
  final double totalActualHours;

  final Map<Priority, int> tasksByPriority;

  final Map<TaskStatus, int> tasksByStatus;

  final List<MemberStat> memberStats;

  ProjectStats({
    required this.totalTasks,
    required this.completedTasks,
    required this.completionPercentage,
    required this.totalEstimatedHours,
    required this.totalActualHours,
    required this.tasksByPriority,
    required this.tasksByStatus,
    required this.memberStats,
  });
}

// ============================================================
// Member Statistics
// ============================================================

class MemberStat {
  final String memberId;
  final String memberName;

  final int tasksAssigned;
  final int tasksCompleted;

  final double completionRate;

  final double estimatedHours;
  final double actualHours;

  MemberStat({
    required this.memberId,
    required this.memberName,
    required this.tasksAssigned,
    required this.tasksCompleted,
    required this.completionRate,
    required this.estimatedHours,
    required this.actualHours,
  });
}