import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_management_system/models/models.dart';

class ProjectProvider extends ChangeNotifier {
  List<Project> _projects = [];
  Project? _currentProject;
  final List<TeamMember> _teamMembers = [
    TeamMember(
      id: '1',
      name: 'أحمد علي',
      email: 'ahmed@example.com',
      role: UserRole.manager,
      tasksCompleted: 5,
    ),
    TeamMember(
      id: '2',
      name: 'فاطمة محمد',
      email: 'fatima@example.com',
      role: UserRole.developer,
      tasksCompleted: 8,
    ),
    TeamMember(
      id: '3',
      name: 'محمود حسن',
      email: 'mahmoud@example.com',
      role: UserRole.designer,
      tasksCompleted: 6,
    ),
    TeamMember(
      id: '4',
      name: 'ليلى صالح',
      email: 'layla@example.com',
      role: UserRole.tester,
      tasksCompleted: 4,
    ),
    TeamMember(
      id: '5',
      name: 'عمر خالد',
      email: 'omar@example.com',
      role: UserRole.analyst,
      tasksCompleted: 7,
    ),
  ];

  List<Project> get projects => _projects;
  Project? get currentProject => _currentProject;
  List<TeamMember> get teamMembers => _teamMembers;

  void addProject(Project project) {
    final projectWithMembers = project.copyWith(
      members: _teamMembers,
    );
    _projects.add(projectWithMembers);
    _currentProject = projectWithMembers;
    notifyListeners();
  }

  void setCurrentProject(Project project) {
    _currentProject = project;
    notifyListeners();
  }

  void updateProject(Project project) {
    final index = _projects.indexWhere((p) => p.id == project.id);
    if (index != -1) {
      _projects[index] = project;
      if (_currentProject?.id == project.id) {
        _currentProject = project;
      }
      notifyListeners();
    }
  }

  void deleteProject(String projectId) {
    _projects.removeWhere((p) => p.id == projectId);
    if (_currentProject?.id == projectId) {
      _currentProject = null;
    }
    notifyListeners();
  }

  void addTask(Task task) {
    if (_currentProject != null) {
      final updatedTasks = [..._currentProject!.tasks, task];
      final updatedProject = _currentProject!.copyWith(tasks: updatedTasks);
      updateProject(updatedProject);
    }
  }

  void updateTask(Task task) {
    if (_currentProject != null) {
      final updatedTasks = _updateTaskRecursive(_currentProject!.tasks, task);
      final updatedProject = _currentProject!.copyWith(tasks: updatedTasks);
      updateProject(updatedProject);
    }
  }

  void addSubtask(String parentTaskId, Task subtask) {
    if (_currentProject != null) {
      final updatedTasks = _addSubtaskRecursive(
        _currentProject!.tasks,
        parentTaskId,
        subtask,
      );
      final updatedProject = _currentProject!.copyWith(tasks: updatedTasks);
      updateProject(updatedProject);
    }
  }

  void deleteTask(String taskId) {
    if (_currentProject != null) {
      final updatedTasks = _deleteTaskRecursive(_currentProject!.tasks, taskId);
      final updatedProject = _currentProject!.copyWith(tasks: updatedTasks);
      updateProject(updatedProject);
    }
  }

  List<Task> _updateTaskRecursive(List<Task> tasks, Task updatedTask) {
    return tasks.map((task) {
      if (task.id == updatedTask.id) {
        return updatedTask;
      }
      if (task.subtasks.isNotEmpty) {
        return task.copyWith(
          subtasks: _updateTaskRecursive(task.subtasks, updatedTask),
        );
      }
      return task;
    }).toList();
  }

  List<Task> _addSubtaskRecursive(
    List<Task> tasks,
    String parentId,
    Task subtask,
  ) {
    return tasks.map((task) {
      if (task.id == parentId) {
        return task.copyWith(
          subtasks: [...task.subtasks, subtask],
        );
      }
      if (task.subtasks.isNotEmpty) {
        return task.copyWith(
          subtasks: _addSubtaskRecursive(task.subtasks, parentId, subtask),
        );
      }
      return task;
    }).toList();
  }

  List<Task> _deleteTaskRecursive(List<Task> tasks, String taskId) {
    return tasks
        .where((task) => task.id != taskId)
        .map((task) {
          if (task.subtasks.isNotEmpty) {
            return task.copyWith(
              subtasks: _deleteTaskRecursive(task.subtasks, taskId),
            );
          }
          return task;
        })
        .toList();
  }

  ProjectStats getProjectStats(Project project) {
    int totalTasks = 0;
    int completedTasks = 0;
    double totalEstimatedHours = 0;
    double totalActualHours = 0;
    final Map<Priority, int> tasksByPriority = {
      Priority.high: 0,
      Priority.medium: 0,
      Priority.low: 0,
    };
    final Map<TaskStatus, int> tasksByStatus = {
      TaskStatus.neu: 0,
      TaskStatus.inProgress: 0,
      TaskStatus.completed: 0,
    };

    void countTasks(List<Task> tasks) {
      for (final task in tasks) {
        totalTasks++;
        if (task.status == TaskStatus.completed) {
          completedTasks++;
        }
        totalEstimatedHours += task.estimatedHours;
        totalActualHours += task.actualHours;
        tasksByPriority[task.priority] = tasksByPriority[task.priority]! + 1;
        tasksByStatus[task.status] = tasksByStatus[task.status]! + 1;

        if (task.subtasks.isNotEmpty) {
          countTasks(task.subtasks);
        }
      }
    }

    countTasks(project.tasks);

    final List<MemberStat> memberStats = project.members.map((member) {
      int tasksAssigned = 0;
      int tasksCompleted = 0;
      double estimatedHours = 0;
      double actualHours = 0;

      void countMemberTasks(List<Task> tasks) {
        for (final task in tasks) {
          if (task.assignedTo == member.id) {
            tasksAssigned++;
            if (task.status == TaskStatus.completed) {
              tasksCompleted++;
            }
            estimatedHours += task.estimatedHours;
            actualHours += task.actualHours;
          }
          if (task.subtasks.isNotEmpty) {
            countMemberTasks(task.subtasks);
          }
        }
      }

      countMemberTasks(project.tasks);

      return MemberStat(
        memberId: member.id,
        memberName: member.name,
        tasksAssigned: tasksAssigned,
        tasksCompleted: tasksCompleted,
        completionRate:
            tasksAssigned > 0 ? (tasksCompleted / tasksAssigned) * 100 : 0,
        estimatedHours: estimatedHours,
        actualHours: actualHours,
      );
    }).toList();

    return ProjectStats(
      totalTasks: totalTasks,
      completedTasks: completedTasks,
      completionPercentage:
          totalTasks > 0 ? (completedTasks / totalTasks) * 100 : 0,
      totalEstimatedHours: totalEstimatedHours,
      totalActualHours: totalActualHours,
      tasksByPriority: tasksByPriority,
      tasksByStatus: tasksByStatus,
      memberStats: memberStats,
    );
  }
}
